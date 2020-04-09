#!/bin/bash

chmod +x ./loadraw/load2hdfs.sh

counter=0
option=$1

display_help(){
    echo "-h --help"
    echo "-l fetch raw data from internet and load into hdfs"
    echo "-d2 do deliverable 2"
    echo "-d3 do deliverable 3"
    
    echo "folowing are the individual functions to perform small steps in deliveables use -p -? to execute whatever function you want"
    ./loadraw/load2hdfs.sh "-h"
}

do_fetch_load_data() {

   echo "Fetch raw data from internet unzip and load into hdfs "
   ./loadraw/load2hdfs.sh "-l"
}

do_delieveable2() {
    echo "Removing raw sales data from HDFS"
    ./loadraw/load2hdfs.sh "-c"
    ./loadraw/load2hdfs.sh "-g"
    ./loadraw/load2hdfs.sh "-cv"
    ./loadraw/load2hdfs.sh "-cv2"
}

do_delieveable3() {
    echo "Removing raw sales data from HDFS"
    ./loadraw/load2hdfs.sh "-3a"
    ./loadraw/load2hdfs.sh "-3b"
    ./loadraw/load2hdfs.sh "-3c"
}

delete_all() {
    echo "Removing raw sales data from HDFS"
    ./loadraw/load2hdfs.sh "-dall"
}

###########################################
# Run Time Commands
###########################################
args=("$@") 

while [ $counter -eq 0 ]; do
    
    counter=$((counter+1))
    
    case $option in
      -h |  --help)
          display_help
          ;;
      -p |  --help)
          parameter=$((counter+1))
          ./loadraw/load2hdfs.sh "${args[${counter}]}"
          ;;

      -l | --load)
          load_rawdata
          ;;

      -d2 | --create)
          do_delieveable2
          ;;

      -d3 | --create)
          do_delieveable3
          ;;

      
      -delete | --distroy)
	  delete_all
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
