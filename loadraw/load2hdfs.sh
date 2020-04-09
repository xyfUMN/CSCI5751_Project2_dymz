#!/bin/bash

counter=0
option=$1

sales_directory=~/salesdb
hdfs_directory=/hdfs_salesdb
path_to_files=$(pwd)

sql_DIR="$(cd ".." && cd "./sql_scripts" && pwd)"
if [ $? -ne 0 ]
then
    echo "running from main.sh"
    sql_DIR="$(cd "./sql_scripts" && pwd)"
else
    echo "running from /loadraw/load2hdfs.sh"
fi



display_help(){
    echo "-h display all options"
    echo "-l load raw data into HDFS"
    echo "-dall remove all files and tables and databases"  
  
    echo "-c create database_raw from the hdfs"
    echo "-g create database and parquet tables from database_raw"
    echo "-cv create view customer_monthly_sales_2019_view"    
    echo "-cv2 top_ten_customers_amount_view"    
    echo "-3a do job for deliveable 3a"
    echo "-3b do job for deliveable 3b"    
    echo "-3c do job for deliveable 3c"


    echo "-d3a undo deliveable 3a"
    echo "-d3b undo deliveable 3b"
    echo "-d3c undo deliveable 3c"

    echo "-dcv2 delete view top_ten_customers_amount_view"
    echo "-dcv delete view customer_monthly_sales_2019_view"
    echo "-dh delete hdfs files"
    echo "-dr delete database_raw"

    echo "root dir is ${path_to_files}"
    echo "sql scripts dir is ${sql_DIR}"
}

load_rawdata(){
    echo "prepare raw data"
    get_data
    echo "start load raw data into HDFS"
    do_hdfs
   
}

do_hdfs() {
  echo creating hdfs directory $hdfs_directory
  sudo -u hdfs hdfs dfs -mkdir $hdfs_directory

  for file in "$sales_directory"/*
     do
     echo processing "$file"
     filename=$(basename -- "$file")
     echo creating hdfs directory: $hdfs_directory/"${filename%.*}"
     sudo -u hdfs hdfs dfs -mkdir $hdfs_directory/"${filename%.*}"
     echo puting file $sales_directory/$filename to hdfs directory: $hdfs_directory/"${filename%.*}"
     sudo -u hdfs hdfs dfs -put $sales_directory/$filename $hdfs_directory/"${filename%.*}"/

#     echo "$filename"

   done
   echo Changing owner of hdfs directory to hive
   sudo -u hdfs hdfs dfs -chown -R hive:hive $hdfs_directory
}

delete_hdfs_raw() {
    echo "Removing raw sales data from HDFS"
    sudo -u hdfs hdfs dfs -rm -r $hdfs_directory
}

get_data() {

    
    if [ -d "$sales_directory" ]; then
        echo "$sales_directory exist"

    else 
        echo "$sales_directory does not exist"

        FILE="$path_to_files/salesdata.tar.gz"
	echo "check if $FILE exits"
        if [ -f "$FILE" ]; then
            echo "$FILE exist"
        else 
            echo "getting data from https://csci5751-2020sp.s3-us-west-2.amazonaws.com/sales-data/salesdata.tar.gz"
            wget https://csci5751-2020sp.s3-us-west-2.amazonaws.com/sales-data/salesdata.tar.gz
        fi
	echo "unzipping sales data"
        tar -xvzf salesdata.tar.gz
        mv salesdb $sales_directory
    fi

}

create_raw() {
   echo creating raw tables on csv files
   impala-shell -f "$sql_DIR"/ddl_create_sales_raw.sql

}

drop_raw_database() {
   echo Dropping databse and cascade tables
   impala-shell -q "DROP DATABASE IF EXISTS dymz_sales_raw CASCADE;"

}

create_database_from_raw() {
   echo creating tables from raw database
   sudo hdfs dfs chown -R impala:impala hdfs://Server:8020/desarrollo/data/des/log/log_wf 
   impala-shell -f "$sql_DIR"/ddl_create_sales_from_raw.sql

}

drop_sales_database() {
   echo Dropping databse and cascade tables
   impala-shell -q "DROP DATABASE IF EXISTS dymz_sales CASCADE;"

}

create_views(){
    echo Create views1 from dymz_sales database
    impala-shell -f "$sql_DIR"/step2a.sql
}

drop_views(){
    echo Removing sales views 2
    impala-shell -q "Drop VIEW IF EXISTS dymz_sales.customer_monthly_sales_2019_view;"
}

create_views2(){
    echo Create views2 from dymz_sales database
    impala-shell -f "$sql_DIR"/top_ten_customers.sql
}

drop_views2(){
    echo Removing sales views 2
    impala-shell -q "Drop VIEW IF EXISTS dymz_sales.top_ten_customers_amount_view;"
}

create_product_sales_partition(){
    echo Create product_sales partition from dymz_sales database
    impala-shell -f "$sql_DIR"/Step3a.sql
}

drop_product_sales_partition(){
    echo drop product_sales partition from dymz_sales database
    impala-shell -q "DROP TABLE IF EXISTS dymz_sales.product_sales_partition;"
}

create_views3b(){
    echo Create views3b from dymz_sales database
    impala-shell -f "$sql_DIR"/Step3b.sql
}

drop_views3b(){
    echo Removing sales views 3b
    impala-shell -q "Drop VIEW IF EXISTS dymz_sales.customer_monthly_sales_2019_partitioned_view;"
}

create_product_region_sales_partition(){
    echo Create product_sales partition from dymz_sales database
    impala-shell -f "$sql_DIR"/Step3c.sql
}

drop_product_region_sales_partition(){
    echo drop product_sales partition from dymz_sales database
    impala-shell -q "DROP TABLE IF EXISTS dymz_sales.product_region_sales_partition;"
}

###########################################
# Run Time Commands
###########################################

while [ $counter -eq 0 ]; do
    counter=$((counter+1))
    
    case $option in
      -h |  --help)
          display_help
          ;;

      -l | --load)
          load_rawdata
          ;;

      -c | --create)
          create_raw
          ;;

      -g | --create)
          create_database_from_raw
          ;;

      -3a | --create)
          create_product_sales_partition
          ;;

      -3b | --create)
          create_views3b
          ;;

      -3c | --create)
          create_product_region_sales_partition
          ;;

      -cv | --createviews)
          create_views
          ;;
      -cv2 | --createviews)
          create_views2
          ;;

      -dg | --create)
          drop_sales_database
          ;;

      -dcv | --create)
          drop_views
          ;;
      -dcv2 | --create)
          drop_views2
          ;;

      -d3a | --create)
          drop_product_sales_partition
          ;;
      -d3b | --create)
          drop_views3b
          ;;
      -d3c | --create)
          drop_product_region_sales_partition
          ;;

      -dh | --distroy)
          delete_hdfs_raw
          ;;
      -dr | --distroy)
	  drop_raw_database
          ;;
      -dall | --distroy)
	drop_product_region_sales_partition
        drop_views3b
        drop_product_sales_partition
	drop_views
 	drop_views2
	drop_sales_database
	drop_raw_database
	delete_hdfs_raw
          ;;
      --)
        shift
        break
        ;;

      -*)
          echo "Error: Unknown option: $1" >&2
          exit 1
          ;;

       *) # no more options
          break
          ;;
    esac
done
