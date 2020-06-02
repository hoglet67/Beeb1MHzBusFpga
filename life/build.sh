#!/bin/bash

# Tools required on the path:
#
# 1. BeebASM - https://github.com/stardot/beebasm
# 2. MMB/SSD Utils in Perl - https://github.com/sweharris/MMB_Utils

# Set the BEEBASM executable for the platform
BEEBASM=beebasm

##############################################################
## Build the Atom Version
##############################################################

build=build/atom

rm -rf ${build}
mkdir -p ${build}


cd assembler
for top in atom_top.asm
do
    name=HDLIFE
    echo "Building $build/$name..."

    # Assember the program
    $BEEBASM -i ${top} -o ../${build}/${name} -v >& ../${build}/${name}.log

    # Check if program has been built, otherwise fail early
    if [ ! -f ../${build}/${name} ]
    then
        cat ../${build}/${name}.log
        echo "build failed to create ${name}"
        exit
    fi

done
cd ..

# Add the patterns
for i in 0 1 2 3
do
    mkdir ${build}/${i}
    cp patterns${i}/* ${build}/${i}
done

##############################################################
## Build the Beeb Version
##############################################################

build=build/beeb

rm -rf ${build}
mkdir -p ${build}

ssd=fpgalife

# Create a blank SSD images
for i in 0 1 2 3
do
    beeb blank_ssd ${build}/${ssd}${i}.ssd
done
echo

cd assembler
for top in beeb_top.asm
do
    name=HDLIFE
    echo "Building $build/$name..."

    # Assember the program
    $BEEBASM -i ${top} -o ../${build}/${name} -v >& ../${build}/${name}.log

    # Check if program has been built, otherwise fail early
    if [ ! -f ../${build}/${name} ]
    then
        cat ../${build}/${name}.log
        echo "build failed to create ${name}"
        exit
    fi

    # Create the .inf file
    echo -e "\$."${name}"\t1900\t1900" > ../${build}/${name}.inf

    # Add into SSD 0
    beeb putfile ../${build}/${ssd}0.ssd ../${build}/${name}

done
cd ..

# Add the patterns
for i in 0 1 2 3
do
    cd patterns${i}
    for pattern in `ls * | sort`
    do
        # Copy the pattern into the R directory
        cp ${pattern} ../${build}/R.${pattern}

        # Create the .inf file
        echo -e "R."${pattern}"\t0000\t0000" > ../${build}/R.${pattern}.inf

        # Add into the SSD
        beeb putfile ../${build}/${ssd}${i}.ssd ../${build}/R.${pattern}
    done
    cd ..
    # Add a title
    beeb title ${build}/${ssd}${i}.ssd "FPGA Life $i"
done

# Create the !boot file
echo -e -n "*RUN HDLIFE\r" > ${build}/\!BOOT

# Add into the SSD
beeb putfile ${build}/${ssd}0.ssd ${build}/\!BOOT

# Make bootable
beeb opt4 ${build}/${ssd}0.ssd 3

# Show the names of the .ssd files
ls -l ${build}/*.ssd ${build}/*.log
