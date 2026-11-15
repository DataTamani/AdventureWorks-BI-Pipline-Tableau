USE WAREHOUSE ADW_WH;
USE DATABASE  ADW_DB;
USE SCHEMA    ADW_COR;

-- 1. On crée la table cible (vide)
CREATE OR REPLACE TABLE COR_SALES_ENRICHED (
    SALES_KEY         VARCHAR, -- On le passe en VARCHAR car on va faire une clé composée
    ORDER_DATE        DATE,
    PRODUCT_NAME      VARCHAR,
    SUBCATEGORY_NAME  VARCHAR,
    CATEGORY_NAME     VARCHAR,
    CUSTOMER_NAME     VARCHAR,
    TERRITORY_REGION  VARCHAR,
    ORDER_QTY         NUMBER,
    UNIT_PRICE        NUMBER,
    SALES_AMOUNT      NUMBER
);

-- 2. On crée la vue unifiée des 3 années
CREATE OR REPLACE VIEW V_SALES_ALL AS
SELECT * FROM ADW_RAW.RAW_SALES_2015
UNION ALL SELECT * FROM ADW_RAW.RAW_SALES_2016
UNION ALL SELECT * FROM ADW_RAW.RAW_SALES_2017;

-- 3. On crée le Stream sur la vue
CREATE OR REPLACE STREAM STRM_SALES ON VIEW V_SALES_ALL;

-- 4. On crée la Task 
CREATE OR REPLACE TASK TASK_COR_LOAD
  WAREHOUSE = ADW_WH
  SCHEDULE  = '1 MINUTE'
WHEN
  SYSTEM$STREAM_HAS_DATA('ADW_COR.STRM_SALES')
AS
INSERT INTO ADW_COR.COR_SALES_ENRICHED
SELECT
    s.OrderNumber || '-' || s.OrderLineItem AS SALES_KEY, 
    s.OrderDate::DATE                  AS ORDER_DATE,
    p.ProductName                      AS PRODUCT_NAME,
    sc.SubcategoryName                 AS SUBCATEGORY_NAME,
    c.CategoryName                     AS CATEGORY_NAME,
    cu.FirstName || ' ' || cu.LastName AS CUSTOMER_NAME,
    t.Region                           AS TERRITORY_REGION, 
    s.OrderQuantity                    AS ORDER_QTY,
    p.ProductPrice                     AS UNIT_PRICE,
    (s.OrderQuantity * p.ProductPrice) AS SALES_AMOUNT
FROM ADW_COR.STRM_SALES s
LEFT JOIN ADW_RAW.RAW_PRODUCTS       p  ON s.ProductKey            = p.ProductKey
LEFT JOIN ADW_RAW.RAW_SUBCATEGORIES  sc ON p.ProductSubcategoryKey = sc.ProductSubcategoryKey
LEFT JOIN ADW_RAW.RAW_CATEGORIES     c  ON sc.ProductCategoryKey   = c.ProductCategoryKey
LEFT JOIN ADW_RAW.RAW_CUSTOMERS      cu ON s.CustomerKey           = cu.CustomerKey
LEFT JOIN ADW_RAW.RAW_TERRITORIES    t  ON s.TerritoryKey          = t.SalesTerritoryKey
WHERE s.METADATA$ACTION = 'INSERT'; 


-- 5. On active la Task (comme dans le script de ton prof)
ALTER TASK TASK_COR_LOAD RESUME;

-- 6. On vérifie son état
SHOW TASKS LIKE 'TASK_COR_LOAD';



-- Vérification de la table finale
SELECT COUNT(*) AS TOTAL_LIGNES 
FROM ADW_COR.COR_SALES_ENRICHED;
-- Vide car le stream est venu après (correction en dessous)

-- 1. On vide la table finale (au cas où)
TRUNCATE TABLE ADW_COR.COR_SALES_ENRICHED;

-- 2. On charge toutes les données historiques d'un coup
INSERT INTO ADW_COR.COR_SALES_ENRICHED
SELECT
    s.OrderNumber || '-' || s.OrderLineItem AS SALES_KEY, 
    s.OrderDate::DATE                  AS ORDER_DATE,
    p.ProductName                      AS PRODUCT_NAME,
    sc.SubcategoryName                 AS SUBCATEGORY_NAME,
    c.CategoryName                     AS CATEGORY_NAME,
    cu.FirstName || ' ' || cu.LastName AS CUSTOMER_NAME,
    t.Region                           AS TERRITORY_REGION, 
    s.OrderQuantity                    AS ORDER_QTY,
    p.ProductPrice                     AS UNIT_PRICE,
    (s.OrderQuantity * p.ProductPrice) AS SALES_AMOUNT
FROM ADW_COR.V_SALES_ALL s
LEFT JOIN ADW_RAW.RAW_PRODUCTS       p  ON s.ProductKey            = p.ProductKey
LEFT JOIN ADW_RAW.RAW_SUBCATEGORIES  sc ON p.ProductSubcategoryKey = sc.ProductSubcategoryKey
LEFT JOIN ADW_RAW.RAW_CATEGORIES     c  ON sc.ProductCategoryKey   = c.ProductCategoryKey
LEFT JOIN ADW_RAW.RAW_CUSTOMERS      cu ON s.CustomerKey           = cu.CustomerKey
LEFT JOIN ADW_RAW.RAW_TERRITORIES    t  ON s.TerritoryKey          = t.SalesTerritoryKey;


-- On vérifie les 10 premières lignes de la table finale (enrichie)

SELECT * 
FROM COR_SALES_ENRICHED 
LIMIT 10;


USE WAREHOUSE ADW_WH;
USE DATABASE  ADW_DB;
USE SCHEMA    ADW_COR;


-- On recrée la table avec la colonne Country en plus qui était manquante dans la vue finale du PRS
CREATE OR REPLACE TABLE COR_SALES_ENRICHED (
    SALES_KEY         VARCHAR, 
    ORDER_DATE        DATE,
    PRODUCT_NAME      VARCHAR,
    SUBCATEGORY_NAME  VARCHAR,
    CATEGORY_NAME     VARCHAR,
    CUSTOMER_NAME     VARCHAR,
    TERRITORY_REGION  VARCHAR,
    TERRITORY_COUNTRY VARCHAR,  --  LA NOUVELLE LIGNE
    ORDER_QTY         NUMBER,
    UNIT_PRICE        NUMBER,
    SALES_AMOUNT      NUMBER
);


INSERT INTO ADW_COR.COR_SALES_ENRICHED
SELECT
    s.OrderNumber || '-' || s.OrderLineItem AS SALES_KEY, 
    s.OrderDate::DATE                  AS ORDER_DATE,
    p.ProductName                      AS PRODUCT_NAME,
    sc.SubcategoryName                 AS SUBCATEGORY_NAME,
    c.CategoryName                     AS CATEGORY_NAME,
    cu.FirstName || ' ' || cu.LastName AS CUSTOMER_NAME,
    t.Region                           AS TERRITORY_REGION, 
    t.Country                          AS TERRITORY_COUNTRY, -- LA NOUVELLE LIGNE 
    s.OrderQuantity                    AS ORDER_QTY,
    p.ProductPrice                     AS UNIT_PRICE,
    (s.OrderQuantity * p.ProductPrice) AS SALES_AMOUNT
FROM ADW_COR.V_SALES_ALL s
LEFT JOIN ADW_RAW.RAW_PRODUCTS       p  ON s.ProductKey            = p.ProductKey
LEFT JOIN ADW_RAW.RAW_SUBCATEGORIES  sc ON p.ProductSubcategoryKey = sc.ProductSubcategoryKey
LEFT JOIN ADW_RAW.RAW_CATEGORIES     c  ON sc.ProductCategoryKey   = c.ProductCategoryKey
LEFT JOIN ADW_RAW.RAW_CUSTOMERS      cu ON s.CustomerKey           = cu.CustomerKey
LEFT JOIN ADW_RAW.RAW_TERRITORIES    t  ON s.TerritoryKey          = t.SalesTerritoryKey;