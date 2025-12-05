BEGIN
    FOR t IN (SELECT table_name FROM user_tables WHERE table_name IN
              ('REORDER_REQUESTS','INVENTORY_LOG','SALES','PRODUCTS','SUPPLIERS','HOLIDAYS','AUDIT_LOG','EMPLOYEES')) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Create suppliers
CREATE TABLE suppliers (
    supplier_id      NUMBER PRIMARY KEY,
    supplier_name    VARCHAR2(100) NOT NULL,
    contact_info     VARCHAR2(150)
);

-- Create employees (so we can identify employees for the DML restriction rule)
CREATE TABLE employees (
    employee_id      NUMBER PRIMARY KEY,
    username         VARCHAR2(30) UNIQUE,
    full_name        VARCHAR2(100),
    role_name        VARCHAR2(50)
);

-- Create products
CREATE TABLE products (
    product_id       NUMBER PRIMARY KEY,
    product_name     VARCHAR2(150) NOT NULL,
    category         VARCHAR2(50),
    unit_price       NUMBER(12,2),
    stock_quantity   NUMBER DEFAULT 0,
    reorder_level    NUMBER DEFAULT 0,
    supplier_id      NUMBER,
    CONSTRAINT fk_prod_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Create sales
CREATE TABLE sales (
    sale_id          NUMBER PRIMARY KEY,
    product_id       NUMBER NOT NULL,
    quantity_sold    NUMBER NOT NULL,
    sale_date        DATE DEFAULT SYSDATE,
    created_by       VARCHAR2(30),
    CONSTRAINT fk_sales_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create inventory_log
CREATE TABLE inventory_log (
    log_id           NUMBER PRIMARY KEY,
    product_id       NUMBER NOT NULL,
    action_type      VARCHAR2(20), -- SALE, RESTOCK, ADJUST
    quantity_changed NUMBER,
    log_date         DATE DEFAULT SYSDATE,
    created_by       VARCHAR2(30),
    CONSTRAINT fk_log_prod FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create reorder_requests
CREATE TABLE reorder_requests (
    request_id       NUMBER PRIMARY KEY,
    product_id       NUMBER NOT NULL,
    reorder_quantity NUMBER NOT NULL,
    request_date     DATE DEFAULT SYSDATE,
    status           VARCHAR2(20) DEFAULT 'PENDING',
    created_by       VARCHAR2(30),
    CONSTRAINT fk_rr_prod FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Holidays table for business-rule checks
CREATE TABLE holidays (
    holiday_date  DATE PRIMARY KEY,
    description   VARCHAR2(150)
);

-- Audit log table
CREATE TABLE audit_log (
    log_id       NUMBER PRIMARY KEY,
    object_name  VARCHAR2(128),
    action_type  VARCHAR2(10),
    action_date  DATE DEFAULT SYSDATE,
    username     VARCHAR2(30),
    status       VARCHAR2(20), -- ALLOWED / DENIED
    message      VARCHAR2(4000)
);

-- Sequences
CREATE SEQUENCE seq_suppliers START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_employees START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_products START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_sales START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_inventory_log START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_reorder_requests START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_audit_log START WITH 1 INCREMENT BY 1;

-- Indexes for performance
CREATE INDEX idx_sales_product_date ON sales(product_id, sale_date);
CREATE INDEX idx_products_supplier ON products(supplier_id);

COMMIT;
