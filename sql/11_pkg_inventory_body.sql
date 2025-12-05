CREATE OR REPLACE PACKAGE BODY pkg_inventory AS

    FUNCTION fn_predict_demand(p_product_id NUMBER) RETURN NUMBER IS
        v_avg NUMBER := 0;
    BEGIN
        SELECT NVL(AVG(quantity_sold),0)
        INTO v_avg
        FROM sales
        WHERE product_id = p_product_id
          AND sale_date >= TRUNC(SYSDATE) - 30;

        RETURN ROUND(v_avg,2);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN 0;
    END fn_predict_demand;

    PROCEDURE add_sale(p_product_id NUMBER, p_qty NUMBER, p_user VARCHAR2) IS
        v_stock NUMBER;
    BEGIN
        -- Insert sale
        INSERT INTO sales(sale_id, product_id, quantity_sold, sale_date, created_by)
        VALUES (seq_sales.NEXTVAL, p_product_id, p_qty, SYSDATE, p_user);

        -- Log inventory change
        INSERT INTO inventory_log(log_id, product_id, action_type, quantity_changed, log_date, created_by)
        VALUES (seq_inventory_log.NEXTVAL, p_product_id, 'SALE', -p_qty, SYSDATE, p_user);

        -- Update product stock
        SELECT stock_quantity INTO v_stock FROM products WHERE product_id = p_product_id FOR UPDATE;
        UPDATE products SET stock_quantity = GREATEST(0, stock_quantity - p_qty) WHERE product_id = p_product_id;

        COMMIT;

        -- Check for reorder after updating stock
        generate_reorder_if_needed(p_product_id, p_user);

    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
    END add_sale;

    PROCEDURE process_delivery(p_product_id NUMBER, p_qty NUMBER, p_user VARCHAR2) IS
    BEGIN
        -- Add to stock
        INSERT INTO inventory_log(log_id, product_id, action_type, quantity_changed, log_date, created_by)
        VALUES (seq_inventory_log.NEXTVAL, p_product_id, 'RESTOCK', p_qty, SYSDATE, p_user);

        UPDATE products
        SET stock_quantity = stock_quantity + p_qty
        WHERE product_id = p_product_id;

        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
    END process_delivery;

    PROCEDURE generate_reorder_if_needed(p_product_id NUMBER, p_user VARCHAR2) IS
        v_stock NUMBER;
        v_reorder_level NUMBER;
        v_pred NUMBER;
        v_reorder_qty NUMBER;
    BEGIN
        SELECT stock_quantity, reorder_level
        INTO v_stock, v_reorder_level
        FROM products
        WHERE product_id = p_product_id;

        v_pred := fn_predict_demand(p_product_id); -- predicted daily demand (avg over 30 days)
        -- Simple reorder formula: (predicted demand * lead_time) + safety_stock - current_stock
        -- For this example assume lead_time = 7 days, safety_stock = predicted * 2
        v_reorder_qty := CEIL(GREATEST( (v_pred * 7) + (v_pred * 2) - v_stock, v_reorder_level * 2 ));

        IF v_stock <= v_reorder_level THEN
            INSERT INTO reorder_requests(request_id, product_id, reorder_quantity, request_date, status, created_by)
            VALUES (seq_reorder_requests.NEXTVAL, p_product_id, v_reorder_qty, SYSDATE, 'PENDING', p_user);
            COMMIT;
        END IF;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        NULL;
    END generate_reorder_if_needed;

    PROCEDURE pr_optimize_inventory IS
        CURSOR c IS SELECT product_id FROM products;
        v_pred NUMBER;
    BEGIN
        FOR r IN c LOOP
            v_pred := fn_predict_demand(r.product_id);
            UPDATE products SET reorder_level = GREATEST(1, ROUND(v_pred * 3)) WHERE product_id = r.product_id;
        END LOOP;
        COMMIT;
    END pr_optimize_inventory;

END pkg_inventory;
/
