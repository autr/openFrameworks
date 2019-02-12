#!/usr/bin/env bash

export TARGET=linuxarmv6l
export MAKEFLAGS="-j4"
export OF_ROOT=/home/pi/openFrameworks
export GCC_PREFIX=arm-linux-gnueabihf
export GST_VERSION=1.0
export RPI_ROOT=/home/pi/RPI_ROOT
export TOOLCHAIN_ROOT=${OF_ROOT}/scripts/ci/$TARGET/rpi_toolchain
export PLATFORM_OS=Linux
export PLATFORM_ARCH=armv6l
export PKG_CONFIG_LIBDIR=${RPI_ROOT}/usr/lib/pkgconfig:${RPI_ROOT}/usr/lib/${GCC_PREFIX}/pkgconfig:${RPI_ROOT}/usr/share/pkgconfig
export CXX="ccache ${TOOLCHAIN_ROOT}/bin/${GCC_PREFIX}-g++"
export CC="ccache ${TOOLCHAIN_ROOT}/bin/${GCC_PREFIX}-gcc"
export AR=${TOOLCHAIN_ROOT}/bin/${GCC_PREFIX}-ar
export LD=${TOOLCHAIN_ROOT}/bin/${GCC_PREFIX}-ld

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
PARENT_DIR="$(dirname "$DIR")" 
ROOT_DIR=${DIR}/../..
COMPILE_DIR=${ROOT_DIR}/of-rpi-examples
MAKEFILE_PATH=$PARENT_DIR/templates/linuxarmv6l/Makefile 
mkdir ${ROOT_DIR}/of-rpi-examples
cd ${DIR}/../../examples
success_list=()
error_list=()

# sudo chmod -R 777 ../../../../openFrameworks/

for category in $(ls -1d *)
do
    if [ $category != "addons" ] && [ $category != "ios" ] && [ $category != "android" ] && [ $category != "tvOS" ] && [ -d "$category" ]; then

        echo
        echo "Changed to Category >"+$category
        echo

        mkdir $COMPILE_DIR/$category
        cd $category
        for j in $(ls -1d *)
        do
            echo ">>$j"

            # Check if folder has /src folder

            if [ -d $j/src ]; then
                cd $j

#               read -p "Press any key to compile next example, $category $j :"
#               make clean -f $MAKEFILE_PATH

                TARGET="linuxarmv6l" make  -f $MAKEFILE_PATH
                ret=$?
                if [ $ret -ne 0 ];
                then
                    Add to fail if make failed
                    error_list+=($category/$j)
                    echo "Error compiling : " $category/$j
                else

                    # Copy linuxarmv6l Makefile

                    cp $ROOT_DIR/scripts/templates/linuxarmv6l/Makefile .
                    cp bin/$j $COMPILE_DIR/$category

                    # Add to fail or success array if binary can be copied

                    if [ $? -ne 0 ]
                    then
                        error_list+=($category/$j)
                        echo "Error copying : " $category/$j
                        echo

                    else
                        success_list+=($category/$j)
                        echo "Successfully compiled and copied : " $category/$j
                        echo
                    fi
                fi
                cd ../
            fi
        done
        cd ../
    fi
done

echo
echo "Successfully built" ${#success_list[@]}
echo
echo ${success_list[*]}

echo
echo "Failing builds" ${#error_list[@]}
echo
echo ${error_list[*]}
echo

# Retry cleaning and building all failed examples?

read -p "Try to clean and rebuild failing examples? (y/n) : " CONT
echo    # move to a new line

if [ "$CONT" = "y" ]; then

    # Sometimes get permissions errs so chmod

    chmod -R 777 $ROOT_DIR

    # Loop back over failing examples

    for path in ${error_list[@]}
    do
        cd $ROOT_DIR/examples/$path
        echo
        echo "Re-compiling : " $path
        pwd
        echo
        sleep 5
        make clean -f $MAKEFILE_PATH
        TARGET="linuxarmv6l" make  -f $MAKEFILE_PATH
    done

fi

echo
echo "Finished"
echo