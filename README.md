# Telecom-Customer-Churn-Prediction-in-R
An end-to-end data analysis project that uses exploratory data analysis and logistic regression to predict customer churn and inform retention strategies.
# 📊 Customer Churn Prediction using R & Tidymodels

This project analyzes telecom customer data to build a predictive model that identifies individuals likely to churn. The final output segments customers into "High," "Medium," and "Low" risk tiers, providing actionable insights for targeted retention campaigns.

### Table of Contents
* [Project Overview](#project-overview)
* [Data Source](#data-source)
* [Tools & Libraries](#tools--libraries)
* [Project Structure](#project-structure)
* [Analysis & Methodology](#analysis--methodology)
* [Results & Findings](#results--findings)
* [Contact](#contact)

---

### Project Overview

Customer churn is a critical metric for subscription-based businesses. This project aims to address this issue by leveraging machine learning to predict customer churn. By understanding the key drivers and identifying at-risk customers in advance, a business can take proactive steps to improve customer retention.

This analysis involves:
1.  **Data Cleaning:** Handling missing values to prepare the dataset for analysis.
2.  **Exploratory Data Analysis (EDA):** Visualizing data to uncover patterns and relationships between customer attributes and churn.
3.  **Predictive Modeling:** Building and evaluating a logistic regression model using the `tidymodels` framework.
4.  **Actionable Insights:** Creating a customer risk segmentation to guide business strategy.

---

### Data Source
The dataset used is the "Telcom Customer Churn" dataset, which contains customer demographics, account information, services signed up for, and churn status.

* **Source:** [Link to your data source, e.g., Kaggle]

---

### Tools & Libraries
* **Language:** `R`
* **Key R Packages:**
    * `tidyverse`: For data manipulation and visualization (includes `dplyr` and `ggplot2`).
    * `tidymodels`: A modern framework for modeling and machine learning in R.
    * `scales`: For formatting plot axes and labels.

---

### Project Structure
The project is organized as follows:
```
├── data/
│   └── Telcom-Customer-Churn.csv   # The raw dataset
│
├── scripts/
│   └── churn_analysis.R            # R script with the complete analysis
│
└── README.md                       # This file
```

---

### Analysis & Methodology

1.  **Data Cleaning:** The initial dataset contained missing values in the `TotalCharges` column for new customers with zero tenure. These rows were removed to ensure data quality for the model.

2.  **Exploratory Data Analysis (EDA):** Key insights from the EDA phase include:
    * **Contract Type:** Customers on a `Month-to-month` contract have a significantly higher churn rate compared to those on one or two-year contracts.
    * **Tenure:** Customers who churn tend to have a much shorter tenure.
    * **Payment Method:** Customers using `Electronic check` as their payment method churn more frequently than others.

3.  **Predictive Modeling:**
    * A logistic regression model was chosen for its interpretability.
    * The `tidymodels` framework was used to create a reproducible modeling pipeline (`recipe` and `workflow`).
    * The data was split into a 75% training set and a 25% testing set.
    * The model was trained to predict the `Churn` variable based on the following predictors: `tenure`, `Contract`, `MonthlyCharges`, `PaymentMethod`, and `SeniorCitizen`.

---

### Results & Findings

* **Model Performance:** The model achieved an accuracy of [**Enter your accuracy score here, e.g., 80.5%**] on the test set. The confusion matrix provides a detailed breakdown of correct and incorrect predictions for both churned and non-churned customers.

* **Key Churn Drivers:** The model coefficients confirm the findings from EDA, highlighting that shorter tenure and month-to-month contracts are strong predictors of churn.

* **Customer Risk Segmentation:** The model's predicted probabilities were used to segment customers into three risk tiers. This provides a clear, actionable output for the business:

| risk_tier   | number_of_customers | Recommended Action                                    |
|-------------|-----------------------|-------------------------------------------------------|
| High Risk   | 85        | Target with immediate retention offers (e.g., discounts, plan upgrades). |
| Medium Risk | 432      | Engage with proactive customer support and satisfaction surveys. |
| Low Risk    | 1243       | Monitor and nurture with standard marketing communications. |

This segmentation allows the retention team to focus its efforts and resources where they are most needed, maximizing their impact.

---

### Contact
* **Author:** [Your Name]
* **LinkedIn:** [Your LinkedIn Profile URL]
* **GitHub:** [Your GitHub Profile URL]
