--  1) Utility function: is_current_user_employee
CREATE OR REPLACE FUNCTION fn_is_user_employee(p_user VARCHAR2) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM employees WHERE username = p_user;
    RETURN v_count > 0;
EXCEPTION WHEN OTHERS THEN
    RETURN FALSE;
END;
/

-- 2) Restriction check function: returns TRUE if DML should be blocked today (weekday OR holiday)
CREATE OR REPLACE FUNCTION fn_check_restriction RETURN BOOLEAN IS
    v_is_holiday NUMBER;
    v_dow VARCHAR2(3);
BEGIN
    -- Check holiday first (compare dates ignoring time)
    SELECT COUNT(*) INTO v_is_holiday FROM holidays WHERE TRUNC(holiday_date) = TRUNC(SYSDATE);

    -- Weekday check (Mon-Fri)
    v_dow := TO_CHAR(SYSDATE,'DY','NLS_DATE_LANGUAGE=ENGLISH');

    IF v_is_holiday > 0 THEN
        RETURN TRUE;
    ELSIF v_dow IN ('MON','TUE','WED','THU','FRI') THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE; -- weekend allowed
    END IF;
EXCEPTION WHEN OTHERS THEN
    -- In case of any error, be conservative (do not block)
    RETURN FALSE;
END;
/

-- 3) Procedure: write to audit log
CREATE OR REPLACE PROCEDURE pr_write_audit(p_obj VARCHAR2, p_action VARCHAR2, p_username VARCHAR2, p_status VARCHAR2, p_message VARCHAR2) IS
BEGIN
    INSERT INTO audit_log (log_id, object_name, action_type, action_date, username, status, message)
    VALUES (seq_audit_log.NEXTVAL, p_obj, p_action, SYSDATE, p_username, p_status, SUBSTR(p_message,1,4000));
    COMMIT;
END;
/

-- 4) Generic compound trigger for SALES table (apply same pattern to other tables you want audited)
-- This compound trigger blocks DML for employees on weekdays/holidays and logs everything.
CREATE OR REPLACE TRIGGER trg_audit_and_block_sales
FOR INSERT OR UPDATE OR DELETE ON sales
COMPOUND TRIGGER

    TYPE t_row_rec IS RECORD (action VARCHAR2(10), username VARCHAR2(30), object_name VARCHAR2(128));
    TYPE t_row_tab IS TABLE OF t_row_rec INDEX BY PLS_INTEGER;
    g_rows t_row_tab;
    g_idx PLS_INTEGER := 0;

BEFORE STATEMENT IS
BEGIN
    -- Nothing needed here for now
    NULL;
END BEFORE STATEMENT;

BEFORE EACH ROW IS
    v_user VARCHAR2(30);
BEGIN
    -- Determine performing user: prefer :new.created_by if present else USER (session)
    IF INSERTING THEN
        v_user := NVL(:NEW.created_by, USER);
    ELSIF UPDATING THEN
        v_user := NVL(:NEW.created_by, NVL(:OLD.created_by, USER));
    ELSE
        v_user := NVL(:OLD.created_by, USER);
    END IF;

    -- Save row info for AFTER statement logging
    g_idx := g_idx + 1;
    g_rows(g_idx).action := CASE WHEN INSERTING THEN 'INSERT' WHEN UPDATING THEN 'UPDATE' ELSE 'DELETE' END;
    g_rows(g_idx).username := v_user;
    g_rows(g_idx).object_name := 'SALES';

    -- If user is an employee and restriction applies, block DML
    IF fn_is_user_employee(v_user) AND fn_check_restriction THEN
        -- Log denied attempt
        pr_write_audit('SALES', CASE WHEN INSERTING THEN 'INSERT' WHEN UPDATING THEN 'UPDATE' ELSE 'DELETE' END, v_user, 'DENIED',
                       'DML blocked by business rule: Weekday or Holiday');
        RAISE_APPLICATION_ERROR(-20002, 'DML NOT ALLOWED for employees on weekdays or holidays.');
    END IF;
END BEFORE EACH ROW;

AFTER EACH ROW IS
BEGIN
    -- Allowed operation reached here; but we don't write audit per row here to avoid too many commits
    NULL;
END AFTER EACH ROW;

AFTER STATEMENT IS
BEGIN
    -- Write audit for allowed operations
    FOR i IN 1..g_rows.COUNT LOOP
        pr_write_audit(g_rows(i).object_name, g_rows(i).action, g_rows(i).username, 'ALLOWED', 'Operation completed');
    END LOOP;
END AFTER STATEMENT;

END trg_audit_and_block_sales;
/
