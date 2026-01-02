CREATE DATABASE IF NOT EXISTS opticshop;
USE opticshop;

CREATE TABLE customer(
id_customer INT NOT NULL AUTO_INCREMENT,
first_name VARCHAR (30) NOT NULL,
last_name VARCHAR (50) NOT NULL,
postal_adress VARCHAR (50),
phone VARCHAR (15),
email VARCHAR (50),
register_date DATE NOT NULL,
recommended_by INT,
PRIMARY KEY (id_customer),
FOREIGN KEY (recommended_by) REFERENCES customer(id_customer)
ON DELETE SET NULL
ON UPDATE CASCADE);

CREATE TABLE employee(
id_employee INT NOT NULL AUTO_INCREMENT,
first_name VARCHAR (30) NOT NULL,
last_name VARCHAR (50) NOT NULL,
phone VARCHAR (15) NOT NULL,
email VARCHAR (50) NOT NULL,
PRIMARY KEY(id_employee));

CREATE TABLE supplier(
id_supplier INT NOT NULL AUTO_INCREMENT,
name VARCHAR (30) NOT NULL,
street VARCHAR (30) NOT NULL,
street_number INT,
floor INT,
door VARCHAR (10),
city VARCHAR (30) NOT NULL,
zip_code INT NOT NULL,
country VARCHAR (30) NOT NULL,
phone VARCHAR (15) NOT NULL,
fax VARCHAR (15),
nif VARCHAR (11) NOT NULL,
PRIMARY KEY (id_supplier));

CREATE TABLE glasses(
id_glasses INT NOT NULL AUTO_INCREMENT,
brand VARCHAR(30) NOT NULL,
right_graduation DOUBLE NOT NULL,
left_graduation DOUBLE NOT NULL,
frame_type ENUM ('floating', 'plastic', 'metal') NOT NULL,
frame_color VARCHAR (30) NOT NULL,
color_crystals VARCHAR (30) NOT NULL,
price DECIMAL (10,2) NOT NULL,
id_supplier INT,
PRIMARY KEY (id_glasses),
FOREIGN KEY (id_supplier) REFERENCES supplier(id_supplier)
ON DELETE NO ACTION
ON UPDATE NO ACTION);

CREATE TABLE sale(
id_sale INT NOT NULL AUTO_INCREMENT,
id_employee INT NOT NULL,
id_customer INT NOT NULL,
id_glasses INT NOT NULL,
sale_date DATE NOT NULL,
PRIMARY KEY (id_sale),
FOREIGN KEY (id_employee) REFERENCES employee(id_employee) ON DELETE NO ACTION ON UPDATE NO ACTION,
FOREIGN KEY (id_customer) REFERENCES customer(id_customer) ON DELETE NO ACTION ON UPDATE NO ACTION,
FOREIGN KEY (id_glasses) REFERENCES glasses(id_glasses) ON DELETE NO ACTION ON UPDATE NO ACTION);

-- Customer
INSERT INTO customer (first_name, last_name, postal_adress, phone, email, register_date) 
VALUES ('Miguel', 'Montaño', NULL, NULL, 'miguel@gmail.com', CURDATE());

INSERT INTO customer (first_name, last_name, postal_adress, phone, email, register_date, recommended_by) 
VALUES ('Maria', 'Lopez', 'Carrer Congost - 18', '459857645', 'marialo@gmail.com', CURDATE(), 1);

-- Employee 
INSERT INTO employee (first_name, last_name, phone, email) 
VALUES ('Joan', 'Vallet', '348876112', 'joanvalletj@gmail.com');

-- Supplier
INSERT INTO supplier 
(name, street, street_number, floor, door, city, zip_code, country, phone, fax, nif)
VALUES
('PJ LOBSTER', 'Verdi', 123, 2, 'A', 'Barcelona', 08010, 'Spain', '934567890', '934567891', 'B12345678');

-- Glasses
INSERT INTO glasses
(brand, right_graduation, left_graduation, frame_type, frame_color, color_crystals, price, id_supplier)
VALUES
('Papa Berlin', -1.25, -1.00, 'plastic', 'champagne', 'transparent', 129.90, 1);

-- Sales
INSERT INTO sale (id_employee, id_customer, id_glasses, sale_date)
VALUES (1, 1, 1, '2025-01-10');

INSERT INTO sale (id_employee, id_customer, id_glasses, sale_date)
VALUES (1, 2, 1, '2024-06-15');

INSERT INTO sale (id_employee, id_customer, id_glasses, sale_date)
VALUES (1, 2, 1, '2025-02-20');

-- Sales/Client
SELECT c.first_name, c.last_name, COUNT(s.id_sale) AS total_sales
FROM customer c
JOIN sale s ON c.id_customer = s.id_customer
WHERE c.id_customer = 2
GROUP BY c.id_customer;

-- Sales Employee/year
SELECT DISTINCT g.id_glasses, g.brand, g.frame_type, g.price
FROM sale s
JOIN glasses g ON s.id_glasses = g.id_glasses
WHERE s.id_employee = 1
AND YEAR(s.sale_date) = 2025;

-- Supplier/Sales
SELECT DISTINCT sp.id_supplier, sp.name, sp.city, sp.phone
FROM sale s
JOIN glasses g ON s.id_glasses = g.id_glasses
JOIN supplier sp ON g.id_supplier = sp.id_supplier;
