#!/bin/bash

counter=0
option=$1

sales_directory=~/salesdb
hdfs_directory=/hdfs_salesdb
path_to_files=$(pwd)
sql_DIR="$(cd ".." && cd "./sql_scripts" && pwd)"

display_help(){
    echo "-h display all options"
    echo "-l load raw data into HDFS"
    echo "-d load remove raw data in HDFS"
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
      -cv | --createviews)
          create_views
          ;;
      -cv2 | --createviews)
          create_views2
          ;;

      -dg | --create)
          drop_sales_database
          ;;

      -dh | --distroy)
          delete_hdfs_raw
          ;;
      -dr | --distroy)
	  drop_raw_database
          ;;
      -dall | --distroy)
	
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
