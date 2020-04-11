\# CSCI5751\_Project2\_dymz

team name: \*\*dymz\*\* &lt;br/&gt;

team member: \*\*Maryam Forootaninia, Dengyuan Wang, Zhengyuan Shen,
Abinash Sinha, Yifan Xu\*\* &lt;br/&gt;

slack channel name: \*\*dymz\*\*

Deployment RunBook section:

1.  To update library related to github In VM run: sudo yum update -y
    > nss curl libcurl

2.  Get source code: git clone
    > [*https://github.com/xyfUMN/CSCI5751\_Project2\_dymz.git*](https://github.com/xyfUMN/CSCI5751_Project2_dymz.git)

3.  Open source folder: cd CSCI5751\_Project2\_dymz

4.  Make bash scripts executable run: chomd +x ./main.sh

5.  to see helps run: ./main.sh -h

6.  To run all deliverables

> Fetch raw data from internet and create hdfs files: ./main.sh -l
>
> Run deliverable 2: ./main.sh -d2
>
> Run deliverable 3: ./main.sh -d3

1.  To delete all databases and hdfs files run: ./main.sh -delete

2.  To run individual functions syntax ./main.sh -p\[parameter\]
    > -\[options\]:

> run ./main.sh -p -\[?\] (use ./main.sh -h to see detailed helps about
> how to run)

1.  To view tables and views, please use impala-shell and query as
    > following:

> Show databases;
>
> Select \* from \[database\_name\].\[Table\_name/View\_name\];

User Documentation section:

1.  Sales Data Model:

-   ![](media/image1.png){width="5.552083333333333in"
    > height="2.7083333333333335in"}

1.  List of Databases Created:

-   dymz\_sales\_raw: This database is created from the raw data
    > provided from
    > [*https://csci5751-2020sp.s3-us-west-2.amazonaws.com/sales-data/salesdata.tar.gz*](https://csci5751-2020sp.s3-us-west-2.amazonaws.com/sales-data/salesdata.tar.gz).
    > (This raw data contains the csv files)

<!-- -->

-   dymz\_sales: This database includes managed tables in parquet format
    > from the raw sales data and the views created from raw data.

1.  List of Tables Created:(syntax: \[database\_name\].\[table\_name\])

> attributes for each table ref to sales data model fig listed above

-   External Tables:

<!-- -->

-   dymz\_sales\_raw.sales, dymz\_sales\_raw.employees,
    > dymz\_sales\_raw.customers, dymz\_sales\_raw.products

-   Created and loaded the table based on the structure and content of
    > the given raw csv files.

<!-- -->

-   Parquet Tables:

<!-- -->

-   dymz\_sales.sales, dymz\_sales.employees, dymz\_sales.customers,
    > dymz\_sales.products

-   dymz\_sales.product\_sales\_partition,
    > dymz\_sales.product\_region\_sales\_partition

1.  List of Views:

-   dymz\_sales.customer\_monthly\_sales\_2019\_view:

    -   This view contains the following attributes; customer id,
        > customer last name, customer first name, year, month,
        > aggregate total amount of all products purchased by month
        > for 2019.

-   dymz\_sales.top\_ten\_customers\_amount\_view

    -   This view has the following attributes, Customer id, customer
        > last name, customer first name, customer middle initial and
        > total lifetime purchased amount.

    -   It returns the top ten customers sorted by total dollar amount
        > in sales from highest to lowest.

-   Dymz\_sales.customer\_monthly\_sales\_2019\_partitioned\_view

    -   This view contains the following attributes Customerid,
        > Lastname, Firstname, Salesyear, Salesmonth, Total

    -   Unpartitioned views: Fetched 6597 row(s) in 5.35s

    -   Partitioned views:Fetched 6597 row(s) in 6.96s

    -   In our case, sometimes we experience inconsistent performance
        > due to network latency which results in the unpartitioned view
        > to be faster than the partitioned view.


