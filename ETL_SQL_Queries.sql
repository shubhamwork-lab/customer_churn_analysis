-- Create a new database for churn data
CREATE DATABASE db_churn;

-- Select the database to use
USE db_churn;

-- Create the staging table with all columns as VARCHAR to match imported CSV structure
CREATE TABLE stg_churn (
    CustomerID VARCHAR(50),
    Gender VARCHAR(50),
    Age VARCHAR(50),
    Married VARCHAR(50),
    State VARCHAR(50),
    Number_of_Referrals VARCHAR(50),
    Tenure_in_Months VARCHAR(50),
    Value_Deal VARCHAR(50),
    Phone_Service VARCHAR(50),
    Multiple_Lines VARCHAR(50),
    Internet_Service VARCHAR(50),
    Internet_Type VARCHAR(50),
    Online_Security VARCHAR(50),
    Online_Backup VARCHAR(50),
    Device_Protection_Plan VARCHAR(50),
    Premium_Support VARCHAR(50),
    Streaming_TV VARCHAR(50),
    Streaming_Movies VARCHAR(50),
    Streaming_Music VARCHAR(50),
    Unlimited_Data VARCHAR(50),
    Contract VARCHAR(50),
    Paperless_Billing VARCHAR(50),
    Payment_Method VARCHAR(50),
    Monthly_Charge VARCHAR(50),
    Total_Charges VARCHAR(50),
    Total_Refunds VARCHAR(50),
    Total_Extra_Data_Charges VARCHAR(50),
    Total_Long_Distance_Charges VARCHAR(50),
    Total_Revenue VARCHAR(50),
    Customer_Status VARCHAR(50),
    Churn_Category VARCHAR(50),
    Churn_Reason VARCHAR(50)
);

-- Data import into 'stg_churn' done externally via Table Data Import Wizard

-- Preview some rows from the production table (assumed to be created later)
SELECT * FROM prod_churn limit 30;

-- Count rows in staging table to validate import
SELECT COUNT(*) from stg_churn;

-- Show structure of staging table
DESCRIBE stg_churn;

-- ------------------------------------------------------------------------------
-- Create production table with proper data types, casting where needed
CREATE TABLE prod_churn AS
SELECT
    Customer_ID,
    Gender,
    CAST(NULLIF(Age,'') AS UNSIGNED) AS Age,
    Married,
    State,
    CAST(NULLIF(Number_of_Referrals,'') AS UNSIGNED) AS Number_of_Referrals,
    CAST(NULLIF(Tenure_in_Months,'') AS UNSIGNED) AS Tenure_in_Months,
    Value_Deal,
    Phone_Service,
    Multiple_Lines,
    Internet_Service,
    Internet_Type,
    Online_Security,
    Online_Backup,
    Device_Protection_Plan,
    Premium_Support,
    Streaming_TV,
    Streaming_Movies,
    Unlimited_Data,
    Contract,
    Paperless_Billing,
    Payment_Method,
    CAST(NULLIF(Monthly_Charge,'') AS DECIMAL(10,2)) AS Monthly_Charge,
    CAST(NULLIF(Total_Charges,'') AS DECIMAL(10,2)) AS Total_Charges,
    CAST(NULLIF(Total_Refunds,'') AS DECIMAL(10,2)) AS Total_Refunds,
    CAST(NULLIF(Total_Extra_Data_Charges,'') AS DECIMAL(10,2)) AS Total_Extra_Data_Charges,
    CAST(NULLIF(Total_Long_Distance_Charges,'') AS DECIMAL(10,2)) AS Total_Long_Distance_Charges,
    CAST(NULLIF(Total_Revenue,'') AS DECIMAL(10,2)) AS Total_Revenue,
    Customer_Status,
    Churn_Category,
    Churn_Reason
FROM stg_churn;

-- Add primary key constraint to production table
ALTER TABLE prod_churn
ADD PRIMARY KEY (Customer_ID);

-- Describe production table structure to verify data types and keys
DESCRIBE prod_churn;

-- Sample data preview from staging table with casting
SELECT
    Customer_ID,
    Gender,
    CAST(NULLIF(Age,'') AS UNSIGNED) AS Age,
    Married,
    State,
    CAST(NULLIF(Number_of_Referrals,'') AS UNSIGNED) AS Number_of_Referrals,
    CAST(NULLIF(Tenure_in_Months,'') AS UNSIGNED) AS Tenure_in_Months,
    Value_Deal,
    Phone_Service,
    Multiple_Lines,
    Internet_Service,
    Internet_Type,
    Online_Security,
    Online_Backup,
    Device_Protection_Plan,
    Premium_Support,
    Streaming_TV,
    Streaming_Movies,
    Unlimited_Data,
    Contract,
    Paperless_Billing,
    Payment_Method,
    CAST(NULLIF(Monthly_Charge,'') AS DECIMAL(10,2)) AS Monthly_Charge,
    CAST(NULLIF(Total_Charges,'') AS DECIMAL(10,2)) AS Total_Charges,
    CAST(NULLIF(Total_Refunds,'') AS DECIMAL(10,2)) AS Total_Refunds,
    CAST(NULLIF(Total_Extra_Data_Charges,'') AS DECIMAL(10,2)) AS Total_Extra_Data_Charges,
    CAST(NULLIF(Total_Long_Distance_Charges,'') AS DECIMAL(10,2)) AS Total_Long_Distance_Charges,
    CAST(NULLIF(Total_Revenue,'') AS DECIMAL(10,2)) AS Total_Revenue,
    Customer_Status,
    Churn_Category,
    Churn_Reason
FROM stg_churn
LIMIT 10;

-- ------------------------------------------------------------------------------
-- Validation Queries

-- Check for NULL or empty Customer_IDs
SELECT * FROM prod_churn WHERE Customer_ID IS NULL OR Customer_ID = '';

-- Check for duplicate Customer_IDs   
SELECT Customer_ID, COUNT(*)
FROM prod_churn
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

-- Validate Age values (expect 0–100)
SELECT * FROM prod_churn WHERE Age < 0 OR Age > 100;

-- List distinct values for Customer_Status and Churn_Category
SELECT DISTINCT Customer_Status FROM prod_churn;
SELECT DISTINCT Churn_Category FROM prod_churn;

-- ------------------------------------------------------------------------------
-- Data Exploration Queries

-- Gender distribution with percentages
SELECT Gender, COUNT(Gender) AS TotalCount,
ROUND(COUNT(Gender) * 100/ (SELECT COUNT(*) FROM prod_churn),2) AS Percentage
FROM prod_churn
GROUP BY Gender;

-- Contract type distribution with percentages
SELECT Contract, COUNT(Contract) AS TotalCount,
ROUND(COUNT(Contract) * 100/ (SELECT COUNT(*) FROM prod_churn),2) AS Percentage
FROM prod_churn
GROUP BY Contract;

-- Customer_Status revenue summary with percentages
SELECT Customer_Status, COUNT(Customer_Status) AS TotalCount,
SUM(Total_Revenue) AS TotalRev,
ROUND(SUM(Total_Revenue) * 100/ (SELECT SUM(Total_Revenue) FROM prod_churn),2) AS RevPercentage
FROM prod_churn
GROUP BY Customer_Status;

-- State distribution ordered by percentage descending
SELECT State, COUNT(State) AS TotalCount,
ROUND(COUNT(State) * 100/ (SELECT COUNT(*) FROM prod_churn),2) AS Percentage
FROM prod_churn
GROUP BY State
ORDER BY Percentage DESC;

-- ------------------------------------------------------------------------------
-- Check for NULL values across columns
SELECT 
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Customer_ID_Null_Count,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_Null_Count,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_Null_Count,
    SUM(CASE WHEN Married IS NULL THEN 1 ELSE 0 END) AS Married_Null_Count,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS State_Null_Count,
    SUM(CASE WHEN Number_of_Referrals IS NULL THEN 1 ELSE 0 END) AS Number_of_Referrals_Null_Count,
    SUM(CASE WHEN Tenure_in_Months IS NULL THEN 1 ELSE 0 END) AS Tenure_in_Months_Null_Count,
    SUM(CASE WHEN Value_Deal IS NULL THEN 1 ELSE 0 END) AS Value_Deal_Null_Count,
    SUM(CASE WHEN Phone_Service IS NULL THEN 1 ELSE 0 END) AS Phone_Service_Null_Count,
    SUM(CASE WHEN Multiple_Lines IS NULL THEN 1 ELSE 0 END) AS Multiple_Lines_Null_Count,
    SUM(CASE WHEN Internet_Service IS NULL THEN 1 ELSE 0 END) AS Internet_Service_Null_Count,
    SUM(CASE WHEN Internet_Type IS NULL THEN 1 ELSE 0 END) AS Internet_Type_Null_Count,
    SUM(CASE WHEN Online_Security IS NULL THEN 1 ELSE 0 END) AS Online_Security_Null_Count,
    SUM(CASE WHEN Online_Backup IS NULL THEN 1 ELSE 0 END) AS Online_Backup_Null_Count,
    SUM(CASE WHEN Device_Protection_Plan IS NULL THEN 1 ELSE 0 END) AS Device_Protection_Plan_Null_Count,
    SUM(CASE WHEN Premium_Support IS NULL THEN 1 ELSE 0 END) AS Premium_Support_Null_Count,
    SUM(CASE WHEN Streaming_TV IS NULL THEN 1 ELSE 0 END) AS Streaming_TV_Null_Count,
    SUM(CASE WHEN Streaming_Movies IS NULL THEN 1 ELSE 0 END) AS Streaming_Movies_Null_Count,
    SUM(CASE WHEN Streaming_Music IS NULL THEN 1 ELSE 0 END) AS Streaming_Music_Null_Count,
    SUM(CASE WHEN Unlimited_Data IS NULL THEN 1 ELSE 0 END) AS Unlimited_Data_Null_Count,
    SUM(CASE WHEN Contract IS NULL THEN 1 ELSE 0 END) AS Contract_Null_Count,
    SUM(CASE WHEN Paperless_Billing IS NULL THEN 1 ELSE 0 END) AS Paperless_Billing_Null_Count,
    SUM(CASE WHEN Payment_Method IS NULL THEN 1 ELSE 0 END) AS Payment_Method_Null_Count,
    SUM(CASE WHEN Monthly_Charge IS NULL THEN 1 ELSE 0 END) AS Monthly_Charge_Null_Count,
    SUM(CASE WHEN Total_Charges IS NULL THEN 1 ELSE 0 END) AS Total_Charges_Null_Count,
    SUM(CASE WHEN Total_Refunds IS NULL THEN 1 ELSE 0 END) AS Total_Refunds_Null_Count,
    SUM(CASE WHEN Total_Extra_Data_Charges IS NULL THEN 1 ELSE 0 END) AS Total_Extra_Data_Charges_Null_Count,
    SUM(CASE WHEN Total_Long_Distance_Charges IS NULL THEN 1 ELSE 0 END) AS Total_Long_Distance_Charges_Null_Count,
    SUM(CASE WHEN Total_Revenue IS NULL THEN 1 ELSE 0 END) AS Total_Revenue_Null_Count,
    SUM(CASE WHEN Customer_Status IS NULL THEN 1 ELSE 0 END) AS Customer_Status_Null_Count,
    SUM(CASE WHEN Churn_Category IS NULL THEN 1 ELSE 0 END) AS Churn_Category_Null_Count,
    SUM(CASE WHEN Churn_Reason IS NULL THEN 1 ELSE 0 END) AS Churn_Reason_Null_Count
FROM prod_churn;

-- Check for empty string values across text columns
SELECT 
    SUM(CASE WHEN Customer_ID = '' THEN 1 ELSE 0 END) AS Customer_ID_Empty_Count,
    SUM(CASE WHEN Gender = '' THEN 1 ELSE 0 END) AS Gender_Empty_Count,
    SUM(CASE WHEN Married = '' THEN 1 ELSE 0 END) AS Married_Empty_Count,
    SUM(CASE WHEN State = '' THEN 1 ELSE 0 END) AS State_Empty_Count,
    SUM(CASE WHEN Value_Deal = '' THEN 1 ELSE 0 END) AS Value_Deal_Empty_Count,
    SUM(CASE WHEN Phone_Service = '' THEN 1 ELSE 0 END) AS Phone_Service_Empty_Count,
    SUM(CASE WHEN Multiple_Lines = '' THEN 1 ELSE 0 END) AS Multiple_Lines_Empty_Count,
    SUM(CASE WHEN Internet_Service = '' THEN 1 ELSE 0 END) AS Internet_Service_Empty_Count,
    SUM(CASE WHEN Internet_Type = '' THEN 1 ELSE 0 END) AS Internet_Type_Empty_Count,
    SUM(CASE WHEN Online_Security = '' THEN 1 ELSE 0 END) AS Online_Security_Empty_Count,
    SUM(CASE WHEN Online_Backup = '' THEN 1 ELSE 0 END) AS Online_Backup_Empty_Count,
    SUM(CASE WHEN Device_Protection_Plan = '' THEN 1 ELSE 0 END) AS Device_Protection_Plan_Empty_Count,
    SUM(CASE WHEN Premium_Support = '' THEN 1 ELSE 0 END) AS Premium_Support_Empty_Count,
    SUM(CASE WHEN Streaming_TV = '' THEN 1 ELSE 0 END) AS Streaming_TV_Empty_Count,
    SUM(CASE WHEN Streaming_Movies = '' THEN 1 ELSE 0 END) AS Streaming_Movies_Empty_Count,
    SUM(CASE WHEN Streaming_Music = '' THEN 1 ELSE 0 END) AS Streaming_Music_Empty_Count,
    SUM(CASE WHEN Unlimited_Data = '' THEN 1 ELSE 0 END) AS Unlimited_Data_Empty_Count,
    SUM(CASE WHEN Contract = '' THEN 1 ELSE 0 END) AS Contract_Empty_Count,
    SUM(CASE WHEN Paperless_Billing = '' THEN 1 ELSE 0 END) AS Paperless_Billing_Empty_Count,
    SUM(CASE WHEN Payment_Method = '' THEN 1 ELSE 0 END) AS Payment_Method_Empty_Count,
    SUM(CASE WHEN Customer_Status = '' THEN 1 ELSE 0 END) AS Customer_Status_Empty_Count,
    SUM(CASE WHEN Churn_Category = '' THEN 1 ELSE 0 END) AS Churn_Category_Empty_Count,
    SUM(CASE WHEN Churn_Reason = '' THEN 1 ELSE 0 END) AS Churn_Reason_Empty_Count
FROM prod_churn;

-- Update statement to replace NULL or empty strings with default values for categorical columns
UPDATE prod_churn
SET
    Value_Deal = IFNULL(NULLIF(Value_Deal,''), 'None'),
    Multiple_Lines = IFNULL(NULLIF(Multiple_Lines,''), 'No'),
    Internet_Type = IFNULL(NULLIF(Internet_Type,''), 'None'),
    Online_Security = IFNULL(NULLIF(Online_Security,''), 'No'),
    Online_Backup = IFNULL(NULLIF(Online_Backup,''), 'No'),
    Device_Protection_Plan = IFNULL(NULLIF(Device_Protection_Plan,''), 'No'),
    Premium_Support = IFNULL(NULLIF(Premium_Support,''), 'No'),
    Streaming_TV = IFNULL(NULLIF(Streaming_TV,''), 'No'),
    Streaming_Movies = IFNULL(NULLIF(Streaming_Movies,''), 'No'),
    Streaming_Music = IFNULL(NULLIF(Streaming_Music,''), 'No'),
    Unlimited_Data = IFNULL(NULLIF(Unlimited_Data,''), 'No'),
    Churn_Category = IFNULL(NULLIF(Churn_Category,''), 'Others'),
    Churn_Reason = IFNULL(NULLIF(Churn_Reason,''), 'Others');

-- Re-validate updates
SELECT * FROM prod_churn;

-- Check for any remaining NULL Customer_IDs after update
SELECT * FROM prod_churn WHERE Customer_ID IS NULL;

-- Total record count in production table
SELECT COUNT(*) FROM prod_churn;

-- ------------------------------------------------------------------------------
-- Create views for Power BI consumption
Create View vw_ChurnData AS
	SELECT * FROM prod_Churn WHERE Customer_Status IN ('Churned', 'Stayed');


Create View vw_JoinData AS
	SELECT * FROM prod_Churn WHERE Customer_Status = 'Joined';