-- CREATING SCHEMA --

CREATE SCHEMA IF NOT EXISTS hris;
USE hris;

-- CREATING TABLES --

CREATE TABLE IF NOT EXISTS companies (
	company_id VARCHAR(15) PRIMARY KEY,
	company_name VARCHAR(255)
);

-- Información de empleados
CREATE TABLE IF NOT EXISTS employee_info (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    employee_surname VARCHAR(50),
    sex TINYINT,
    CHECK (sex IN (0, 1, 2, 9)),
	birth_date VARCHAR (100)
);

-- Información legal
CREATE TABLE IF NOT EXISTS legal_info (
	country_id VARCHAR(2) PRIMARY KEY, 
	country VARCHAR(50),
    yearly_working_days DECIMAL(5,2), 
    yearly_bank_holidays INT,
    yearly_annual_leave INT,
    weekly_working_hours DECIMAL(4,2) 
);

-- Información de contratos
CREATE TABLE IF NOT EXISTS contract_info (
	contract_id VARCHAR(15) PRIMARY KEY,
    employee_number INT,
    company_id_contract VARCHAR(15),
    country_id_contract VARCHAR(2),
    position INT,
    hierarchy_level INT,
    department VARCHAR(50),
    start_date VARCHAR (100),
    gross_salary DECIMAL(10,2),
    currency VARCHAR(3),
    CONSTRAINT fk_employee_id FOREIGN KEY (employee_number) REFERENCES employee_info(employee_id),
    CONSTRAINT fk_country_id_contract FOREIGN KEY (country_id_contract) REFERENCES legal_info(country_id),
    CONSTRAINT fk_company_id_contract FOREIGN KEY (company_id_contract) REFERENCES companies(company_id)
);

-- Ausencias por enfermedad
CREATE TABLE IF NOT EXISTS sick_leave (
	leave_id INT PRIMARY KEY,
    age_group_id VARCHAR(20),
    company_id_sick VARCHAR(15),
    leave_days DECIMAL(5,2),
    CONSTRAINT fk_company_sick_id FOREIGN KEY (company_id_sick) REFERENCES companies(company_id)
);

-- Iniciativas de bienestar 
CREATE TABLE IF NOT EXISTS wellbeing_initiatives (
	product_id VARCHAR(4) PRIMARY KEY,
    product_name VARCHAR(50),
    price_monthly DECIMAL(6,2),
    country_wellbeing_id VARCHAR(2),
    currency_product VARCHAR(3),
    reduction_leave DECIMAL(3,2),
    CHECK (reduction_leave >= 0 AND reduction_leave <= 1),
    CONSTRAINT fk_country_wellbeing_id FOREIGN KEY (country_wellbeing_id) REFERENCES legal_info(country_id)
);

-- IMPORTING DATA TO DATABASE --

SHOW VARIABLES LIKE 'secure_file_priv';
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv"
Into table hris.companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

Select*
From hris.companies;

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/employee_info.csv"
Into table hris.employee_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

Select*
From hris.employee_info;

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/legal_info.csv"
Into table hris.legal_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

Select*
From hris.legal_info;


Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/contract_info.csv"
Into table hris.contract_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

Select*
From hris.contract_info;

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sick_leave.csv"
Into table hris.sick_leave
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

Select*
From hris.sick_leave;

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/wellbeing_initiatives.csv"
Into table hris.wellbeing_initiatives
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

Select*
From hris.wellbeing_initiatives;

-- TWEAKING DATE TYPE ON TABLES --

SET SQL_SAFE_UPDATES = 0;
UPDATE hris.employee_info
SET birth_date = STR_TO_DATE(birth_date, '%d/%m/%Y');
ALTER TABLE hris.employee_info MODIFY COLUMN birth_date DATE;
SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;
UPDATE hris.contract_info
SET start_date = STR_TO_DATE(start_date, '%d/%m/%Y');
ALTER TABLE hris.contract_info MODIFY COLUMN start_date DATE;
SET SQL_SAFE_UPDATES = 1;

Select*
From hris.contract_info;


#CLUSTERING & PYTHON



CREATE TABLE IF NOT EXISTS clustering (
	employee_id VARCHAR(15) PRIMARY KEY,
    sex INT,
    age INT,
    expected_leave_days DEC (4,2),
    yearly_salary DEC(10,2),
    salary INT,
    position INT,
    working_days INT,
    hierarchy INT,
    clustering_company_id INT,
    clustering_grupo_edad INT,
    clustering_country_info INT,
    clustering_yearly_abscence_cost DEC (10,2),
    clustering_prorrated_daily_cost_abscence DEC (10,2)
    );



Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/k_means.csv"
Into table hris.clustering
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select*
From clustering