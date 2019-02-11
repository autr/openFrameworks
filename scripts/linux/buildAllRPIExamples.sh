#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
PARENT_DIR="$(dirname "$DIR")" 
ROOT_DIR=${DIR}/../..
COMPILE_DIR=${ROOT_DIR}/of-rpi-examples
MAKEFILE_PATH=$PARENT_DIR/templates/linuxarmv6l/Makefile 
mkdir ${ROOT_DIR}/of-rpi-examples
cd ${DIR}/../../examples
success_list=()
error_list=()
for category in $(ls -1d *)
do
        if [ $category != "addons" ] && [ $category != "ios" ] && [ $category != "android" ] && [ -d "$category" ]; then

                echo "CHANGED TO CATEGORY >"+$category
				mkdir $COMPILE_DIR/$category
                cd $category
                for j in $(ls -1d *)
                do
                        echo ">>$j"
			if [ -d $j ]; then
                        	cd $j
#							read -p "Press any key to compile next example, $category $j :"
#                        	make clean -f $MAKEFILE_PATH
                        	make -f $MAKEFILE_PATH 
                        	ret=$?
                        	if [ $ret -ne 0 ];
                        	then
					error_list+=($j)
                                	echo "error compiling: " + $j
                        	else
					success_list+=($j)
                                	echo "successfully compiled :" + $j
					cp bin/$j $COMPILE_DIR/$category
                        	fi
                        	cd ../
			fi
                done
                cd ../
        fi
done

echo "Failing builds"
echo ${error_list[*]}
echo "Successfully built"
echo ${success_list[*]}
