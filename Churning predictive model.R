
# 1. SETUP: Load all necessary packages

library(tidyverse) 
library(tidymodels) 
library(scales)     

# 2. DATA LOADING & CLEANING
churn_data <- read.csv("C:/Users/vyngu/Documents/Telcom-Customer-Churn.csv")
head(churn_data) 

#Data Cleaning 
#remove The TotalCharges column has missing values (NAs) for customers with 0 tenure (new customers who haven't been charged yet).
churn_data <- churn_data %>%
  drop_na(TotalCharges)


# 3. EXPLORATORY DATA ANALYSIS (EDA)
mis_val <- (colSums(is.na(churn_data)))
print("Missing Values in All columns")
print(mis_val)

print("Dimesnions of the dataset")
print(dim(churn_data))

summary(churn_data)

# Churn Distribution (Pie Chart)
churn_counts <- churn_data %>%
  count(Churn, name = "Count")

ggplot(churn_counts, aes(x = "", y = Count, fill = Churn)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") + 
  geom_text(aes(label = percent(Count / sum(Count))),
            position = position_stack(vjust = 0.5)) +
  ggtitle("Overall Churn Distribution") +
  theme_void() 

# Churn Rate by Contract Type 
ggplot(churn_data, aes(x = Contract, fill = Churn)) +
  geom_bar(position = "fill") +
  labs(
    title = "Churn Rate by Contract Type",
    y = "Proportion of Customers",
    x = "Contract Type"
  ) +
  theme_minimal()

# Churn Distribution by Customer Tenure 
ggplot(churn_data, aes(x = Churn, y = tenure, fill = Churn)) +
  geom_boxplot() +
  labs(
    title = "Customer Tenure for Churned vs. Non-Churned Customers",
    x = "Churn Status",
    y = "Tenure (in months)"
  ) +
  theme_minimal()

# Churn rate by Senior Citizen Status
senior_data <- data.frame(
  SeniorCitizen = c("No", "Yes"),
  Count = c(6932, 1539)
)

ggplot(senior_data, aes(x = SeniorCitizen, y = Count, fill = SeniorCitizen)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Senior Citizen Status", x = "Senior Citizen", y = "Count") +
  scale_fill_manual(values = c("No" = "#66B3FF", "Yes" = "#FF9999"))

# Churn rate by Payment Method
payment_data <- data.frame(
  PaymentMethod = c("Bank transfer (automatic)", "Credit card (automatic)",
                    "Electronic check", "Mailed check"),
  Count = c(1542, 1521, 2365, 1604)
)

ggplot(payment_data, aes(x = PaymentMethod, y = Count, fill = PaymentMethod)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Payment Method Distribution", x = "Payment Method", y = "Count") +
  scale_fill_brewer(palette = "Set3")


# 4. PREDICTIVE MODELING

# Convert Churn to a factor
churn_data$Churn <- as.factor(churn_data$Churn)

# Split data into training (75%) and testing (25%) sets
set.seed(123) # For reproducibility
data_split <- initial_split(churn_data, prop = 0.75, strata = Churn)
train_data <- training(data_split)
test_data  <- testing(data_split)

# Define the model specification 
log_spec <- logistic_reg() %>%
  set_engine("glm") %>%
  set_mode("classification")

# Create a recipe to define our predictor variables and target
churn_recipe <- recipe(Churn ~ tenure + Contract + MonthlyCharges + PaymentMethod + SeniorCitizen, data = train_data) %>%
  step_dummy(all_nominal_predictors())

# Create a workflow that bundles the recipe and model
log_workflow <- workflow() %>%
  add_recipe(churn_recipe) %>%
  add_model(log_spec)

# Train the model using the training data
log_fit <- fit(log_workflow, data = train_data)

# Print the model coefficients to see what's important
tidy(log_fit)


# 5. MODEL EVALUATION

# Make predictions on the test data 
predictions <- predict(log_fit, new_data = test_data)

# Bind the predictions with the actual results
results <- bind_cols(test_data, predictions) %>%
  select(Churn, .pred_class)

# Calculate the accuracy
print("Model Accuracy:")
accuracy(results, truth = Churn, estimate = .pred_class)

# Create a confusion matrix to see the details of correct/incorrect predictions
print("Confusion Matrix:")
conf_mat(results, truth = Churn, estimate = .pred_class)



# 6. CREATE ACTIONABLE OUTPUT (RISK SEGMENTATION)

# Predict the churn probabilities for customers 
predictions_with_prob <- predict(log_fit, new_data = test_data, type = "prob")

# Combine probabilities with the original test data 
results_with_prob <- bind_cols(test_data, predictions_with_prob)

# Create the risk tiers and the summary table 
risk_summary_table <- results_with_prob %>%
  mutate(
    risk_tier = case_when(
      .pred_Yes > 0.70 ~ "High Risk",
      .pred_Yes > 0.40 ~ "Medium Risk",
      TRUE             ~ "Low Risk"
    )
  ) %>%
  count(risk_tier, name = "number_of_customers") %>%
  # Arrange the table in a logical order of risk
  arrange(factor(risk_tier, levels = c("High Risk", "Medium Risk", "Low Risk")))

# Display your final summary table 
print("Customer Risk Segmentation:")
print(risk_summary_table)
