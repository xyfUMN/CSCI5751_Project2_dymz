# CSCI5751_Project2_dymz
team name: **dymz** <br/>
team member: **Maryam Forootaninia, Dengyuan Wang, Zhengyuan Shen, Abinash Sinha, Yifan Xu** <br/>
slack channel name: **dymz**

**Deployment RunBook section:**

To update library related to github In VM run:	sudo yum update -y nss curl libcurl<br/>
* Get source code: git clone https://github.com/xyfUMN/CSCI5751_Project2_dymz.git<br/>
* Open source folder: 					cd CSCI5751_Project2_dymz<br/>
* Make bash scripts executable run:  				chomd +x ./main.sh<br/>
* to see helps run:			 			./main.sh -h <br/>
* To run all deliverables<br/>
* Fetch raw data from internet and create hdfs files: 	./main.sh -l<br/>
* Run deliverable 2: 					./main.sh -d2<br/>
* Run deliverable 3: 					./main.sh -d3<br/>
* To delete all databases and hdfs files run: 			./main.sh -delete<br/>
* To run individual functions syntax ./main.sh -p[parameter] -[options]: <br/>
* run ./main.sh -p -[?]	(use ./main.sh -h to see detailed helps about how to run)<br/>
* To view tables and views, please use impala-shell and query as following:<br/>
	* Show databases;<br/>
	* Select * from [database_name].[Table_name/View_name];<br/>
	
**User Documentation section:**<br/>
* **1. Sales Data Model:**<br/>
![alt text](https://github.com/xyfUMN/CSCI5751_Project2_dymz/blob/master/sales_data_model.png)

* **2. List of Databases Created:**<br/>
  * dymz_sales_raw: This database is created from the raw data provided from 
  https://csci5751-2020sp.s3-us-west-2.amazonaws.com/sales-data/salesdata.tar.gz. (This raw data contains the csv files)<br/>
 
  * dymz_sales: This database includes managed tables in parquet format from the raw sales data and the views created from raw    data.<br/>
* **3. List of Tables Created:(syntax: [database_name].[table_name]):**<br/>
  * attributes for each table reffrence to sales data model figure listed above<br/>
  * External Tables:<br/>
   	* dymz_sales_raw.sales, dymz_sales_raw.employees, dymz_sales_raw.customers, dymz_sales_raw.products<br/>
   	* Created and loaded the table based on the structure and content of the given raw csv files.<br/>
  * Parquet Tables: <br/>
    	* dymz_sales.sales, dymz_sales.employees, dymz_sales.customers, dymz_sales.products<br/>
    	* dymz_sales.product_sales_partition, dymz_sales.product_region_sales_partition<br/>

* **4. List of Views:**<br/>
	* dymz_sales.customer_monthly_sales_2019_view:<br/>
		* This view contains the following attributes; customer id, customer last name, customer first name, year, 			month,aggregate total amount of all products purchased by month for 2019.<br/>
	* dymz_sales.top_ten_customers_amount_view:<br/>
		* This view has the following attributes, Customer id, customer last name, customer first name, customer 			middle initial and total lifetime purchased amount.<br/>
		* It returns the top ten customers sorted by total dollar amount in sales from highest to lowest.<br/>
	* dymz_sales.customer_monthly_sales_2019_partitioned_view:<br/>
     		* This view contains the following attributes Customerid, Lastname, Firstname, Salesyear, Salesmonth, Total<br/>
     		* Unpartitioned views: Fetched 6597 row(s) in 5.35s<br/>
     		* Partitioned views:Fetched 6597 row(s) in 6.96s<br/>
     		* In our case, sometimes we experience inconsistent performance due to network latency which results in the unpartitioned view to be faster than the partitioned view.<br/>

