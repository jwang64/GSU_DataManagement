#Q1. Write a query to display the SKU (stock keeping unit), description, type, base, category,  and  price  for  all  products  that  have  a  PROD_BASE  of  Water  and  a 
#PROD_CATEGORY  of  Sealer.  And,  use  aliases  to  each attribute.  For  instance, PROD_DESCRIPT à‘product description’.(Logical/Comparison Operator)(5%
SELECT PROD_SKU as sku, PROD_DESCRIPT as description, PROD_TYPE as type, PROD_BASE as base, PROD_CATEGORY as category, PROD_PRICE as price  
FROM largeco.LGPRODUCT 
WHERE PROD_BASE = 'Water' AND PROD_CATEGORY = 'Sealer';

#Q2. Write a query to display the employee number, last name, first name, salary “from” date, salary enddate, and salary amount for employees 83731, 83745, and 84039.  
#Sort  the  output  by  employee  number  and  salary "from" date
SELECT LGEMPLOYEE.EMP_NUM, LGEMPLOYEE.EMP_LNAME, LGEMPLOYEE.EMP_FNAME, LGSALARY_HISTORY.SAL_FROM, LGSALARY_HISTORY.SAL_END, LGSALARY_HISTORY.SAL_AMOUNT 
FROM largeco.LGEMPLOYEE 
LEFT JOIN largeco.LGSALARY_HISTORY ON LGEMPLOYEE.EMP_NUM = LGSALARY_HISTORY.EMP_NUM 
WHERE(LGEMPLOYEE.EMP_NUM = '83731') or (LGEMPLOYEE.EMP_NUM = '83745') or (LGEMPLOYEE.EMP_NUM = '84039') 
ORDER BY LGEMPLOYEE.EMP_NUM AND LGSALARY_HISTORY.SAL_FROM	;

#Q3. Write a query to display the first name, last name, street, city, state, and zip code of any customer who purchased a Foresters Best brand top coat between July 15, 2017,
#  and  July  31,  2017.  If  a  customer  purchased  more  than  one  such  product, display the customer’s information only once in the output. 
#Sort the output by sate, last name, and then first name.(JOIN, Logical/Comparison Operator)(5%)
SELECT CUST_FNAME, CUST_LNAME, CUST_STREET, CUST_CITY, CUST_STATE, CUST_ZIP 
FROM LGCUSTOMER 
WHERE (CUST_CODE IN 
	(SELECT CUST_CODE FROM LGINVOICE WHERE (INV_NUM IN 
		(SELECT INV_NUM FROM LGLINE WHERE PROD_SKU IN
			(SELECT PROD_SKU FROM LGPRODUCT WHERE (BRAND_ID = '23') AND (PROD_CATEGORY = 'Top Coat'))
        ))
        AND ((INV_DATE >= '2017-07-15') AND (INV_DATE <= '2017-07-30'))
	))
ORDER BY CUST_STATE, CUST_LNAME, CUST_FNAME;

#Q4. Write a query to display the employee number, last name, email address, title, and  department  name  of each  employee  whose  job  title  ends  in  the  word 
#“ASSOCIATE”. Sort the output by department name and employee title.(JOIN, Logical/Comparison Operator)(5%)
SELECT LGEMPLOYEE.EMP_NUM, LGEMPLOYEE.EMP_LNAME, LGEMPLOYEE.EMP_EMAIL, LGEMPLOYEE.EMP_TITLE, LGDEPARTMENT.DEPT_NAME 
FROM LGEMPLOYEE 
LEFT JOIN LGDEPARTMENT ON LGEMPLOYEE.DEPT_NUM = LGDEPARTMENT.DEPT_NUM 
WHERE EMP_TITLE LIKE '%ASSOCIATE'
ORDER BY LGDEPARTMENT.DEPT_NAME, LGEMPLOYEE.EMP_TITLE;

#Q5 Write a query to display the number of products within each base and type combination, sorted by base and then by type.(Aggregation functions, group by
SELECT PROD_BASE, PROD_TYPE, COUNT(PROD_BASE) AS NUMPRODUCT
FROM LGPRODUCT
GROUP BY PROD_BASE, PROD_TYPE
ORDER BY PROD_BASE, PROD_TYPE;

#Q6. Write a query to display the brand ID, brand name, and average price of products of each brand. Sort the output by brand name. 
#Results are shown with the average price rounded to two decimal places.(join, aggregation)(5%)
SELECT LGPRODUCT.BRAND_ID, LGBRAND.BRAND_NAME, CAST(AVG(LGPRODUCT.PROD_PRICE) AS DECIMAL(10,2)) AS AVGPRICE
FROM LGPRODUCT 
LEFT JOIN LGBRAND ON LGPRODUCT.BRAND_ID = LGBRAND.BRAND_ID
GROUP BY LGPRODUCT.BRAND_ID
ORDER BY BRAND_NAME;

#Q7. Write a query to display the department number, department name, department phone number, employee number, and last name of each department manager. 
#Sort the output by department name.(Join)(5%)
SELECT LGDEPARTMENT.DEPT_NUM, LGDEPARTMENT.DEPT_NAME, LGDEPARTMENT.DEPT_PHONE, LGDEPARTMENT.EMP_NUM, LGEMPLOYEE.EMP_LNAME
FROM LGDEPARTMENT
LEFT JOIN LGEMPLOYEE ON LGDEPARTMENT.EMP_NUM = LGEMPLOYEE.EMP_NUM
ORDER BY LGDEPARTMENT.DEPT_NAME;

#Q8. Write a query to display the brand ID, brand name, brand type, and average price(round to 2decimal places)of products
#for the brand that has the largest average product price.Results are shown with the average price rounded to two decimal places. (having)(7%)
SELECT LGPRODUCT.BRAND_ID, LGBRAND.BRAND_NAME, LGBRAND.BRAND_TYPE, AVG(LGPRODUCT.PROD_PRICE) AS AVGPRICE
FROM LGPRODUCT
LEFT JOIN LGBRAND ON LGPRODUCT.BRAND_ID = LGBRAND.BRAND_ID
GROUP BY BRAND_ID
ORDER BY AVGPRICE DESC
LIMIT 1;

#Q9. Write a query to display the manager name, department name, department phone number,  employee,  customer  name,  invoice  date,  and  invoice  total  
#for  the department manager of the employee who made a sale to a customer whose last name is Hagan on May 18, 2017.(Join)(7%)
SELECT  LGDEPARTMENT.EMP_NUM AS MANAGER_EMP_NUM, LGDEPARTMENT.DEPT_NAME, LGDEPARTMENT.DEPT_PHONE, LGEMPLOYEE.EMP_FNAME, LGEMPLOYEE.EMP_LNAME, LGCUSTOMER.CUST_FNAME, LGCUSTOMER.CUST_LNAME, LGINVOICE.INV_DATE, LGINVOICE.INV_TOTAL
FROM LGINVOICE
LEFT JOIN LGCUSTOMER ON LGINVOICE.CUST_CODE = LGCUSTOMER.CUST_CODE
LEFT JOIN LGEMPLOYEE ON LGEMPLOYEE.EMP_NUM = LGINVOICE.EMPLOYEE_ID
LEFT JOIN LGDEPARTMENT ON LGEMPLOYEE.DEPT_NUM = LGDEPARTMENT.DEPT_NUM
WHERE (LGCUSTOMER.CUST_CODE IN 
	(SELECT LGINVOICE.CUST_CODE FROM LGINVOICE WHERE (CUST_LNAME = 'Hagan')))
    AND (INV_DATE = '2017-05-18');
    
#Q10. The Binder Prime Company wants to recognize the employee who sold the most of its products during a specified period. 
#Write a query to display the employee number, employee first name, employee last name, email address, and total units sold for the employee who sold the most 
#Binder Prime brand products between November 1, 2017, and December 5, 2017. If there is a tie for most units, sort the output by employee last name.(nested query)(7%)
SELECT LGEMPLOYEE.EMP_NUM, LGEMPLOYEE.EMP_FNAME, LGEMPLOYEE.EMP_LNAME, LGEMPLOYEE.EMP_EMAIL, SUM(LGLINE.LINE_QTY) AS TOTAL
FROM LGINVOICE 
LEFT JOIN LGLINE ON LGLINE.INV_NUM = LGINVOICE.INV_NUM
LEFT JOIN LGEMPLOYEE ON LGINVOICE.EMPLOYEE_ID = LGEMPLOYEE.EMP_NUM
WHERE (LGINVOICE.INV_NUM IN 
	(SELECT INV_NUM FROM LGLINE WHERE PROD_SKU IN 
		(SELECT PROD_SKU FROM LGPRODUCT WHERE BRAND_ID = '33')
	))
    AND ((LGINVOICE.INV_DATE >= '2017-11-01') AND (LGINVOICE.INV_DATE <= '2017-12-05'))
GROUP BY EMPLOYEE_ID
ORDER BY TOTAL DESC
LIMIT 1;

#Q11. LargeCo is planning a new promotion in Alabama (AL) and wants to know about the largest purchases made by the customer in that state. Write a query to display the 
# customer code, customer first name, customer last name, full address, invoice date, and invoice total of the largest purchase made by each customer in AL. Be certain to
# include any customers in AL who have never made a purchase; their invoice date should be null and invoice totals should be 0.
# Sort by Customer last name, then first name
SELECT LGCUSTOMER.CUST_CODE, LGCUSTOMER.CUST_FNAME, LGCUSTOMER.CUST_LNAME, LGCUSTOMER.CUST_STREET, LGCUSTOMER.CUST_CITY, LGCUSTOMER.CUST_STATE, LGCUSTOMER.CUST_ZIP, LGINVOICE.INV_DATE, IFNULL(MAX(LGINVOICE.INV_TOTAL),0) AS LARGEST_INVOICE
FROM LGCUSTOMER
LEFT JOIN LGINVOICE ON LGCUSTOMER.CUST_CODE = LGINVOICE.CUST_CODE
WHERE CUST_STATE = 'AL'
GROUP BY CUST_CODE
ORDER BY CUST_LNAME, CUST_FNAME;

#Q12.The purchasing manager is still concerned about the impact of price on sales. Write  a  query  to  display  the  brand  name,  brand  type,  product  SKU,  
#product description, and price of any products that are not a premium brand, but that cost more than the most expensive premium brand products.(subqueries)(7%)
SELECT LGBRAND.BRAND_NAME, LGBRAND.BRAND_TYPE, LGPRODUCT.PROD_SKU, LGPRODUCT.PROD_DESCRIPT, MAX(LGPRODUCT.PROD_PRICE)
FROM LGPRODUCT
LEFT JOIN LGBRAND ON LGPRODUCT.BRAND_ID = LGBRAND.BRAND_ID
WHERE LGBRAND.BRAND_TYPE = 'PREMIUM';
SELECT LGBRAND.BRAND_NAME, LGBRAND.BRAND_TYPE, LGPRODUCT.PROD_SKU, LGPRODUCT.PROD_DESCRIPT, LGPRODUCT.PROD_PRICE 
FROM LGPRODUCT
LEFT JOIN LGBRAND ON LGPRODUCT.BRAND_ID = LGBRAND.BRAND_ID
WHERE ((BRAND_TYPE != 'PREMIUM') AND PROD_PRICE > 
	(SELECT MAX(LGPRODUCT.PROD_PRICE)
	FROM LGPRODUCT
	LEFT JOIN LGBRAND ON LGPRODUCT.BRAND_ID = LGBRAND.BRAND_ID
	WHERE LGBRAND.BRAND_TYPE = 'PREMIUM')
    );

#Q13
DELIMITER $$

CREATE TRIGGER late_fee_updater
AFTER UPDATE
ON DETAILRENTAL FOR EACH ROW
BEGIN
	DECLARE updateLateFee DECIMAL(10,2);
    DECLARE deltaLateFee DECIMAL(10,2);

	IF ((OLD.DETAIL_DUEDATE != NEW.DETAIL_DUEDATE) OR (OLD.DETAIL_RETURNDATE != NEW.DETAIL_RETURNDATE))
    THEN
		SET updateLateFee := DATEDIFF(NEW.DETAIL_DUEDATE,NEW.DETAIL_RETURNDATE) * IFNULL(NEW.DETAIL_DAILYLATEFEE,0);
        SET updateLateFee := IFNULL(updateLateFee,0);
        SET deltaLateFee := updateLateFee - NEW.DETAIL_DAILYLATEFEE;
        IF deltaLateFee > 0 
        THEN
			UPDATE MEMBERSHIP
				SET MEM_BALANCE = MEM_BALANCE + deltaLateFee
                WHERE ((MEMBERSHIP.MEM_NUM = RENTAL.MEM_NUM) AND RENTAL.RENT_NUM = NEW.RENT_NUM);
		END IF ;
	END IF;
END$$

DELIMITER ;

#Q14
DELIMITER $$
CREATE PROCEDURE prc_new_rental(input_membership_num integer)
BEGIN
    DECLARE currentMembershipBalance DECIMAL(10,2);
    IF (SELECT COUNT(*) FROM MEMBERSHIP WHERE MEMBERSHIP.MEM_NUM = input_membership_num) > 0 
		THEN
        SET currentMembershipBalance := MEMBERSHIP.MEM_BALANCE;
        SELECT CONCAT('Previous Balance: ', currentMembershipBalance);
        INSERT INTO RENTAL(rent_id, RENT_NUM, RENT_DATE,MEM_NUM) VALUES (0, NOW(),input_membership_num);
    ELSE
		SELECT CONCAT( 'Membership number does not exist, data will not be affected') ; 
	END IF ;
END$$

DELIMITER ;