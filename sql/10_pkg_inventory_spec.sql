CREATE OR REPLACE PACKAGE pkg_inventory AS
    PROCEDURE add_sale(p_product_id NUMBER, p_qty NUMBER, p_user VARCHAR2);
    PROCEDURE process_delivery(p_product_id NUMBER, p_qty NUMBER, p_user VARCHAR2);
    PROCEDURE generate_reorder_if_needed(p_product_id NUMBER, p_user VARCHAR2);
    PROCEDURE pr_optimize_inventory;
    FUNCTION fn_predict_demand(p_product_id NUMBER) RETURN NUMBER;
END pkg_inventory;
/
