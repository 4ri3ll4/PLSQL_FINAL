# 🧱 Phase III: Logical Model Design and BI Considerations

**Project:** Smart Inventory Optimization System

---

## 1. Cardinality & relationship notes
- SUPPLIERS (1) — (0..*) PRODUCTS: each product has one supplier (nullable if multi-supplier strategy). 
- PRODUCTS (1) — (0..*) SALES: each sale row references exactly one product; product can appear in many sales. 
- PRODUCTS (1) — (0..*) INVENTORY_LOG. 
- PRODUCTS (1) — (0..*) REORDER_REQUESTS. 
- SALES and INVENTORY_LOG are event/fact-like tables recording activity. 
## 2. Normalization Goal
The logical data model is designed to achieve and maintain **Third Normal Form (3NF)**. This approach minimizes data redundancy, protects data integrity (a core business requirement), and simplifies the maintenance of the Oracle database.

## 3. Normalization Justification
The structure ensures that data integrity rules are enforced across the following three forms:

| Normal Form | Requirement | How It Was Achieved in Design |
| :--- | :--- | :--- |
| **1NF** (First Normal Form)  | Eliminate repeating groups (no multi-valued attributes). | Ensured every column stores atomic values. For example, order line items were isolated and placed into the separate **ORDER\_ITEMS** table to prevent repeating product details within the main **ORDERS** table. |
| **2NF** (Second Normal Form)  | Eliminate partial dependencies (non-key attributes depend on the *entire* Primary Key). | Achieved primarily on tables with composite keys (like **ORDER\_ITEMS**). All attributes in this table (e.g., `QUANTITY`) are fully dependent on the *combination* of `ORDER_ID` and `PRODUCT_ID`. |
| **3NF** (Third Normal Form) | Eliminate transitive dependencies (non-key attributes depend on other non-key attributes). | Attributes that did not directly describe the Primary Key entity were moved to their own tables. For example, supplier details are stored only in the **SUPPLIERS** table and linked via a Foreign Key in the **PRODUCTS** table. |

## 4. Business Intelligence (BI) Design Considerations
To support the required analytical capabilities and dashboards, the database structure differentiates between dimensional and factual data:

* **Dimension Tables:** These contain descriptive, static data used to filter and aggregate facts. Examples include **PRODUCTS** and **SUPPLIERS**.
* **Fact Tables:** These contain quantitative, transactional data used for calculating KPIs. The primary fact tables are **STOCK\_TRANSACTIONS** (recording every sale and receipt) and the dedicated **AUDIT\_LOG**.
* **Aggregation and Auditing:** The design facilitates efficient calculation of KPIs like Inventory Turnover and Stockout Rate, and provides a clear mechanism for logging critical events in the audit trail.
