export TARGET=linuxarmv6l

OF_ROOT=$( cd "$(dirname "$0")/../../.." ; pwd -P )
PROJECTS=$OF_ROOT/libs/openFrameworksCompiled/project

echo $OF_ROOT
echo $PROJECTS
# yes | ./install_dependencies.sh
# yes | ./install_codecs.sh
# yes | ../download_libs.sh --platform linuxarmv6l
# cd ../../ci/linuxarmv6l
# pwd
# # ./install.sh
# ../../linux/compileOF.sh
# pwd
# cd ../../linux/debian

cp $OF_ROOT/scripts/templates/linuxarmv6l/Makefile .
cp $OF_ROOT/scripts/templates/linuxarmv6l/config.make .