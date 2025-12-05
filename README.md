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
    * [**Tables** - `02_create_tables.sql`](<INSERT_LINK_TO_02_CREATE_TABLES_SQL>)
    * [**Data** - `03_insert_data.sql`](<INSERT_LINK_TO_03_INSERT_DATA_SQL>)
    * [**Procedures** - `04_procedures.sql`](<INSERT_LINK_TO_04_PROCEDURES_SQL>)
    * [**Functions** - `05_functions.sql`](<INSERT_LINK_TO_05_FUNCTIONS_SQL>)
    * [**Packages** - `06_packages.sql`](<INSERT_LINK_TO_06_PACKAGES_SQL>)
    * [**Triggers** - `07_triggers.sql`](<INSERT_LINK_TO_07_TRIGGERS_SQL>)
    * [**Audit/Rules** - `20_restriction_and_audit.sql`](<INSERT_LINK_TO_20_RESTRICTION_AND_AUDIT_SQL>)
3.  Test using analytics queries and trigger tests

---

## 🧪 Testing and Verification
The system's core functionality and business rules are verified using the following test cases:

* **Stock Level Accuracy:** [Test Script for Trigger Validation](<INSERT_LINK_TO_TEST_STOCK_LEVEL_SCRIPT>) - Test stock level updates automatically reflect transactions.
* **Reorder Logic:** [Test Script for Reorder Procedure](<INSERT_LINK_TO_TEST_REORDER_PROCEDURE_SCRIPT>) - Verify the system correctly generates orders when stock falls below the reorder point.
* **Weekday/Holiday Constraint:** [Test Script for Business Rule Enforcement](<INSERT_LINK_TO_TEST_CONSTRAINT_SCRIPT>) - Attempt to process an order on a restricted day to verify the rule violation is enforced and logged.
* **Audit Trail:** [Query for Audit Log Validation](<INSERT_LINK_TO_AUDIT_LOG_QUERY>) - Confirm all attempted rule violations are successfully logged in the `AUDIT_LOG` table.
* **Analytics:** [Sample BI Queries](<INSERT_LINK_TO_ANALYTICS_QUERIES>) - Run sample queries to generate KPI data (e.g., Inventory turnover).

---

## 🖼️ Required Screenshots
* ER diagram
* Database structure
* Sample table data
* Procedure/trigger editor
* Test execution results
* Audit log records

## 📝 Documentation Included
* [ERD + BPMN](<INSERT_LINK_TO_ERD_FILE>)
* [BPMN](<INSERT_LINK_TO_BPMN_FILE>)
* [PHASE II](<INSERT_LINK_TO_PHASE_II_FILE>)
* [PHASE III](<INSERT_LINK_TO_PHASE_III_FILE>)
* [Data dictionary](<INSERT_LINK_TO_DATA_DICTIONARY_FILE>)
* [BI design](<INSERT_LINK_TO_BI_DESIGN_FILE>)
* [Logical data model](<INSERT_LINK_TO_LOGICAL_DATA_MODEL_FILE>)

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
