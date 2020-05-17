#!/bin/bash

# Tools required on the path:
#
# 1. BeebASM - https://github.com/stardot/beebasm/release/latest
# 2. MMB/SSD Utils in Perl - https://sweh.spuddy.org/Beeb/mmb_utils.tar

BUILD=$(date +"%Y%m%d_%H%M")
#BUILD=dev

NAME=beeb_fpga_life_$BUILD

DIR=releases/$NAME

echo "Release name: $NAME"

rm -rf $DIR
mkdir -p $DIR

build=build

rm -rf ${build}
mkdir -p ${build}

# Set the BEEBASM executable for the platform
BEEBASM=beebasm

ssd=fpgalife.ssd

# Create a blank SSD image
beeb blank_ssd build/${ssd}
echo

cd assembler
for top in loader.asm
do
    name=`echo ${top%.asm}`
    echo "Building $name..."

    # Assember the ROM
    $BEEBASM -i ${top} -o ../${build}/${name} -v >& ../${build}/${name}.log

    # Check if ROM has been build, otherwise fail early
    if [ ! -f ../${build}/${name} ]
    then
        cat ../${build}/${name}.log
        echo "build failed to create ${name}"
        exit
    fi

    # Create the .inf file
    echo -e "\$."${name}"\t1900\t1900" > ../${build}/${name}.inf

    # Add into the SSD
    beeb putfile ../${build}/${ssd} ../${build}/${name}

    # Report end of code
    grep "code ends at" ../${build}/${name}.log

    # Report build checksum
    echo "    mdsum is "`md5sum <../${build}/${name}`
done
cd ..

# Add the patterns
cd patterns
for pattern in `ls * | sort`
do
    # Copy the pattern into the R directory
    cp ${pattern} ../${build}/R.${pattern}

    # Create the .inf file
    echo -e "R."${pattern}"\t0000\t0000" > ../${build}/R.${pattern}.inf

    # Add into the SSD
    beeb putfile ../${build}/${ssd} ../${build}/R.${pattern}

done
cd ..

# Create the !boot file
echo -e -n "*RUN LOADER\r" > ${build}/\!BOOT

# Add into the SSD
beeb putfile ${build}/${ssd} ${build}/\!BOOT

# Add a title
beeb title ${build}/${ssd} "FPGA Life"

# Make bootable
beeb opt4 ${build}/${ssd} 3

# List the disk
beeb info ${build}/${ssd}

# Zip Everything Up
cp ${build}/${ssd} $DIR
cp ${build}/loader.log $DIR
cp working/life.bit $DIR
zip -qr $DIR.zip $DIR

echo
unzip -l $DIR.zip
