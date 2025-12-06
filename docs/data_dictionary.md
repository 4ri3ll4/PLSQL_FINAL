
## 📖 Data Dictionary 

| Table | Column | Type | Constraints | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **SUPPLIERS** | `supplier_id` | `NUMBER` | **PK** | Supplier identifier |
| | `supplier_name` | `VARCHAR2(100)` | NOT NULL | Supplier name |
| | `contact_info` | `VARCHAR2(200)` | | Email/phone/address |
| **EMPLOYEES** | `employee_id` | `NUMBER` | **PK** | Employee id |
| | `username` | `VARCHAR2(50)` | NOT NULL, **UNIQUE** | Login or id string |
| | `full_name` | `VARCHAR2(120)` | | Employee's full name |
| | `roll_name` | `VARCHAR2(50)` | | Employee's role name |
| **PRODUCTS** | `product_id` | `NUMBER` | **PK** | Product id |
| | `product_name` | `VARCHAR2(150)` | NOT NULL | Human-readable name |
| | `category` | `VARCHAR2(50)` | | Product category |
| | `unit_price` | `NUMBER(12,2)` | | Price per unit |
| | `stock_quantity` | `NUMBER` | NOT NULL, DEFAULT 0 | Current on-hand quantity |
| | `reorder_level` | `NUMBER` | NOT NULL, DEFAULT 0 | Reorder threshold |
| | `supplier_id` | `NUMBER` | **FK** $\to$ `suppliers(supplier_id)` | Preferred supplier |
| **SALES** | `sale_id` | `NUMBER` | **PK** | Sales transaction id |
| | `product_id` | `NUMBER` | **FK** $\to$ `products(product_id)` | Sold product |
| | `quantity_sold` | `NUMBER` | NOT NULL | Quantity sold |
| | `sale_date` | `DATE` | NOT NULL, DEFAULT SYSDATE | When sale occurred |
| | `created_by` | `VARCHAR2(50)` | | username/employee who recorded |
| **INVENTORY\_LOG** | `log_id` | `NUMBER` | **PK** | Inventory change id |
| | `product_id` | `NUMBER` | **FK** $\to$ `products(product_id)`, NOT NULL | Referring to the sold product |
| | `action_type` | `VARCHAR2(20)` | NOT NULL | SALE/RESTOCK/ADJUST |
| | `quantity_changed` | `NUMBER` | NOT NULL | Positive for inbound, negative for outbound |
| | `log_date` | `DATE` | NOT NULL, DEFAULT SYSDATE | When sale/restock/adjust occurred |
| | `created_by` | `VARCHAR2(50)` | | username/employee who recorded |
| **REORDER\_REQUESTS** | `request_id` | `NUMBER` | **PK** | Reorder request id |
| | `product_id` | `NUMBER` | **FK** $\to$ `products(product_id)`, NOT NULL | Referring to the product |
| | `reorder_quantity` | `NUMBER` | NOT NULL | Suggested quantity to order |
| | `request_date` | `DATE` | NOT NULL, DEFAULT SYSDATE | When reorder request occurred |
| | `status` | `VARCHAR2(20)` | DEFAULT 'PENDING' | PENDING/APPROVED/REJECTED |
| | `created_by` | `VARCHAR2(50)` | | username/employee who recorded |
| **HOLIDAYS** | `holiday_date` | `DATE` | **PK** | Holiday used by business rule |
| | `description` | `VARCHAR2(200)` | | Description of holidays observed |
| **AUDIT\_LOG** | `log_id` | `NUMBER` | **PK** | Audit record id |
| | `object_name` | `VARCHAR2(128)` | | Table/object touched |
| | `action_type` | `VARCHAR2(10)` | | INSERT/UPDATE/DELETE |
| | `action_date` | `DATE` | NOT NULL, DEFAULT SYSDATE | When insert/update/delete occurred |
| | `username` | `VARCHAR2(50)` | | Who performed action |
| | `status` | `VARCHAR2(20)` | | ALLOWED/DENIED |
| | `message` | `VARCHAR2(4000)` | | Any comments that might be added |

---


