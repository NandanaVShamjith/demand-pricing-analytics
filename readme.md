# Demand Pricing & Operations Analysis  
**End-to-End Analytics Project | Python | SQL | Tableau | Streamlit**

---

## Project Overview
This project demonstrates an **end-to-end analytics workflow** combining **Python, SQL, Tableau, and Streamlit** to support data-driven pricing and operational decisions in an e-commerce context.

The analysis focuses on understanding how **price, demand, delivery performance, and seller behaviour** interact, and how these factors impact revenue stability and customer experience.

The project is designed as a **portfolio-ready, real-world analytics case**, not a tutorial or toy example.

---

## Business Problem
E-commerce platforms face several challenges:
- Setting optimal prices without reducing demand  
- Ensuring reliable delivery performance  
- Managing seller reliability and revenue concentration risk  
- Improving customer retention  

**Objective:**  
Use data to analyse pricing behaviour, operational performance, and seller risk, and translate findings into actionable business insights.

---

## Dataset
**Source:** Olist Brazilian E-commerce Dataset  

The dataset contains transactional and operational data related to:
- Customers  
- Sellers  
- Products  
- Orders  
- Order items  
- Customer reviews  

---

## Project Workflow
The project follows a realistic analytics lifecycle:

1. **Python** – Pricing model & data preparation  
2. **SQL** – Schema design & business analysis  
3. **Tableau Dashboard** – Executive-level visualization  
4. **Streamlit App** – Interactive analytics interface  

Each component has a **distinct and well-defined role**.

---

## Python: Pricing Model & Analysis

### Purpose
Python was used to:
- Clean and prepare raw datasets  
- Explore price and demand behaviour  
- Engineer analytical features  
- Build a **pricing model** to estimate an **optimal price point**  

### Key Work
- Analysed price distributions and demand patterns  
- Engineered features such as delivery duration, time variables, and price buckets  
- Built a pricing model to evaluate the relationship between price and demand  

### Outcome
- An **optimal price** was computed using a Python-based pricing model  
- The model output was later surfaced in both **Tableau and Streamlit** for decision support  

> Python provided the analytical foundation for pricing decisions.

---

## SQL: Schema Design & Business Analysis

### Schema Design
A clean, normalized schema with **6 final tables**:
- `customers`  
- `sellers`  
- `products`  
- `orders`  
- `order_items`  
- `order_reviews`  

### Data Engineering Decisions
- Primary keys defined on all tables (composite key for `order_items`)  
- Foreign keys used to enforce referential integrity  
- Imported tables used only as **staging**  
- Duplicate review records handled during insertion  

---

### SQL Business Questions Answered
1. **Seller Reliability & Cancellation Risk** – Cancellation risk is concentrated among low-volume sellers  
2. **Delivery Delay Root Cause** – Carrier delays exceed seller delays  
3. **Low-Rating Product Categories** – Several high-volume categories have consistently average ratings  
4. **Price vs Delivery Experience** – Higher-priced products experience longer delivery times  
5. **Customer Repeat Purchase Risk** – Average customer places only one order  
6. **Revenue Concentration Risk** – Revenue is heavily concentrated among a small group of sellers  
7. **Weekend vs Weekday Operations** – No significant operational difference between weekdays and weekends  

---

## Tableau Dashboard: Executive Visualization

### Dashboard Purpose
The **Tableau dashboard** was built to provide a **static, executive-level view** of pricing, demand trends, and operational performance.

### KPIs Displayed
- Total Orders: **98,666**  
- Total Revenue: **₹13.59M**  
- Average Order Value (AOV): **₹137.75**  
- **Optimal Price: ₹93 (derived from Python pricing model)**  

### Tableau Insights
- Demand shows a clear upward trend over time  
- Orders are higher on weekdays than weekends  
- Majority of deliveries are on time  
- Product catalogue is skewed toward low-priced items  
- Revenue is driven by a small number of categories  

---

## Streamlit App: Interactive Analytics

### Purpose
A **Streamlit application** was built to:
- Interactively explore pricing and operational metrics  
- Present Python model outputs dynamically  
- Allow users to drill into insights without using BI tools  

The Streamlit app complements Tableau by offering **interactivity**, while Tableau focuses on **executive storytelling**.

---

## Dashboard & App Preview
Download twb: https://drive.google.com/file/d/1YPWwSHXk-VqV_JWInqVjFzCOHcWY5IAO/view?usp=drive_link


---

## Key Business Takeaways
- Pricing optimization must be supported by operational efficiency  
- Logistics partner performance is a major delivery risk  
- Seller and revenue concentration introduce platform dependency risk  
- Delivery performance alone does not drive customer retention  

---

## Skills Demonstrated
- **Python:** Data cleaning, feature engineering, pricing model development  
- **SQL:** Joins, CTEs, CASE logic, window functions, data integrity handling  
- **Tableau:** Executive dashboard design and storytelling  
- **Streamlit:** Interactive analytics application development  
- **Data Modelling:** Normalized relational schema design  
- **Analytics:** Translating data into business insights  

---

## Conclusion
This project demonstrates the ability to move from **raw data to pricing models, operational analysis, and stakeholder-ready insights** using Python, SQL, Tableau, and Streamlit. The combination of modeling, relational analysis, executive visualization, and interactivity reflects how analytics solutions are built and communicated in real business environments.

---

## Author
**Nandana V Shamjith**  
Aspiring Data Analyst / Business Analyst
