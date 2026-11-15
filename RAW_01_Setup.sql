-- 1. CRÉATION DU WAREHOUSE
CREATE WAREHOUSE IF NOT EXISTS ADW_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND   = 60
  AUTO_RESUME    = TRUE;

USE WAREHOUSE ADW_WH;

-- 2. CRÉATION DE LA DATABASE
CREATE DATABASE IF NOT EXISTS ADW_DB;

USE DATABASE ADW_DB;

-- 3. CRÉATION DES 3 SCHÉMAS
CREATE SCHEMA IF NOT EXISTS ADW_RAW;
CREATE SCHEMA IF NOT EXISTS ADW_COR;
CREATE SCHEMA IF NOT EXISTS ADW_PRS;

-- 4. STRUCTURE DE L'ETAPE RAW
USE SCHEMA ADW_RAW;

-- 4.1 Stage interne + FILE_FORMAT corrigé
CREATE OR REPLACE STAGE ADW_STAGE
  FILE_FORMAT = (
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    DATE_FORMAT = 'MM/DD/YYYY'
    ENCODING = 'UTF8'
    NULL_IF = ('', 'NULL', 'NA')
    EMPTY_FIELD_AS_NULL = TRUE
    TRIM_SPACE = FALSE
  );

-- 4.2 Tables de faits
CREATE OR REPLACE TABLE RAW_SALES_2015 (
    OrderDate DATE, 
    StockDate DATE, 
    OrderNumber VARCHAR,
    ProductKey NUMBER, 
    CustomerKey NUMBER, 
    TerritoryKey NUMBER,
    OrderLineItem NUMBER, 
    OrderQuantity NUMBER
);
CREATE OR REPLACE TABLE RAW_SALES_2016 LIKE RAW_SALES_2015;
CREATE OR REPLACE TABLE RAW_SALES_2017 LIKE RAW_SALES_2015;

-- 4.3 Tables de Dimensions
CREATE OR REPLACE TABLE RAW_CATEGORIES (
    ProductCategoryKey NUMBER,
    CategoryName       VARCHAR
);

CREATE OR REPLACE TABLE RAW_SUBCATEGORIES (
    ProductSubcategoryKey NUMBER,
    SubcategoryName       VARCHAR,
    ProductCategoryKey    NUMBER
);

CREATE OR REPLACE TABLE RAW_PRODUCTS (
    ProductKey            NUMBER,
    ProductSubcategoryKey NUMBER,
    ProductSKU            VARCHAR,
    ProductName           VARCHAR,
    ModelName             VARCHAR,
    ProductDescription    VARCHAR,
    ProductColor          VARCHAR,
    ProductSize           VARCHAR,
    ProductStyle          VARCHAR,
    ProductCost           NUMBER(10,4),
    ProductPrice          NUMBER(10,4)
);

CREATE OR REPLACE TABLE RAW_CUSTOMERS (
    CustomerKey    NUMBER,
    Prefix         VARCHAR,
    FirstName      VARCHAR,
    LastName       VARCHAR,
    BirthDate      DATE,
    MaritalStatus  VARCHAR,
    Gender         VARCHAR,
    EmailAddress   VARCHAR,
    AnnualIncome   VARCHAR,
    TotalChildren  NUMBER,
    EducationLevel VARCHAR,
    Occupation     VARCHAR,
    HomeOwner      VARCHAR
);

CREATE OR REPLACE TABLE RAW_TERRITORIES (
    SalesTerritoryKey NUMBER,
    Region            VARCHAR,
    Country           VARCHAR,
    Continent         VARCHAR
);

-- Verification 

-- 1. Contexte
SELECT CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

-- 2. Les 3 schémas
SHOW SCHEMAS IN DATABASE ADW_DB;

-- 3. Les 8 tables RAW
SHOW TABLES IN SCHEMA ADW_DB.ADW_RAW;

-- 4. Le stage
SHOW STAGES IN SCHEMA ADW_DB.ADW_RAW;
