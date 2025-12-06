# 🛒 Smart Inventory Optimization System

## PL/SQL Practicum – AUCA
**Student:** RUREBWAYIRE AMPOZE Ariella
**ID:** [27640]

---

## 💡 Project Overview
A **PL/SQL–driven inventory management system** that automates stock updates, predicts reorder needs, enforces business rules, and maintains an audit trail. The system reduces stockouts, prevents overstocking, and improves decision-making using analytics.

## ⚠️ Problem Statement
Many businesses struggle with **inaccurate stock records**, **delayed restocking**, and **manual errors**. This results in stockouts, financial loss, and inefficiency. The project solves this through **automated stock tracking**, **optimized reorder decisions**, and **auditing**.

## 🎯 Key Objectives
* Maintain **accurate real-time stock levels**
* Auto-generate **optimized reorder requests**
* Enforce business rules (**weekday/holiday restrictions**)
* Log all activities for **auditing**
* Support **analytics and BI reporting**

---

## 📁 Repository Structure
* **/docs/** ([View ERD/BPMN/Dictionary](<INSERT_DOCS_LINK_HERE>))
* **/sql/** (DDL, DML, procedures, functions, triggers)
* **/screenshots/** (ERD, sample data, audits)
* **/presentation/** ([View Presentation](<INSERT_PRESENTATION_LINK_HERE>))

## 🚀 Quick Start Instructions (Execution Order)
1.  Connect as **INV\_ADMIN** in SQL Developer
2.  Run scripts in this order:
    * ![**Tables & Sequences** - `01_create_tables_and_sequences.sql`](sql/01_create_tables_and_sequences.sql)
    * ![**Sample Data** - `02_insert_sample_data.sql`](sql/02_insert_sample_data.sql)
    * ![**Package Specification** - `10_pkg_inventory_spec.sql`](sql/10_pkg_inventory_spec.sql)
    * ![**Package Body** - `11_pkg_inventory_body.sql`](sql/11_pkg_inventory_body.sql)
    * ![**Audit/Rules** - `20_restriction_and_audit.sql`](sql/20_restriction_and_audit.sql)
3.  Test using the verification scripts below.

---

## 🧪 Testing and Verification
The system's core functionality and business rules are verified using the following test cases:

* **Core Logic Test Cases:** [Verification Queries](sql/03_test_queries.sql) - Run to test procedures/functions, basic stock updates, and primary business logic.
* **Constraint/Rule Enforcement:** [Audit and Restriction Script](sql/20_restriction_and_audit.sql) - **Critical Test** to verify that weekday/holiday restrictions are enforced and audit logs are correctly generated.
* **Analytics Validation:** [Analytics Examples](sql/12_analytics_examples.sql) - Run to confirm data aggregation and BI readiness for calculating KPIs.
* **Audit Trail Review:** [Query for Audit Log Validation](<INSERT_LINK_TO_AUDIT_LOG_QUERY>) - Confirm all attempted rule violations are successfully logged in the `AUDIT_LOG` table.
* **Analytics:** [Sample BI Queries](<INSERT_LINK_TO_ANALYTICS_QUERIES>) - Run sample queries to generate KPI data (e.g., Inventory turnover).

---

## 🖼️ Required Screenshots
* ER diagram v
* Database structure v
* Sample table data
* Procedure/trigger editor
* Test execution results
* Audit log records

## 📝 Documentation Included
* ![ERD](screenshots/SIOS_ERD.png)
* ![BPMN](screenshots/bpmn_diagram.png)
* ![PHASE II](docs/Phase II.pdf)
* ![PHASE III](docs/Phase III.pdf)
* ![Data dictionary](docs/Data Dictionary.pdf)
* ![BI design](<INSERT_LINK_TO_BI_DESIGN_FILE>)

---

## 📈 Business Intelligence
**KPIs supported:**
* Inventory turnover
* Stockout rate
* Supplier performance
* Sales trends
* Audit violations

**Dashboards include:**
* Executive Summary
* Audit Monitoring
* Inventory Performance

---

## ✅ Conclusion
This system improves **stock accuracy**, automates key operations, strengthens security through **auditing**, and provides **BI insights** for better decisions.
