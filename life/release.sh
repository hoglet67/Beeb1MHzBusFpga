#!/bin/bash

if [ -z "$1" ]; then
    RELEASE=$(date +"%Y%m%d_%H%M")
else
    RELEASE=$1
fi

NAME=beeb_fpga_life_$RELEASE

DIR=releases/$NAME

echo "Release name: $NAME"

rm -rf $DIR
mkdir -p $DIR

# Build the software
./build.sh

# Copy the softwate to the release directory
build=build
ssd=fpgalife
for i in 0 1 2 3
do
    # List the disk
    beeb info ${build}/${ssd}${i}.ssd
    cp ${build}/${ssd}${i}.ssd $DIR
done
cp ${build}/loader.log $DIR

# Build each of the Xilinx designs (different resolutions)

source /opt/Xilinx/14.7/ISE_DS/settings64.sh

for i in \
        800_600 \
        1024_768 \
        1280_720 \
        1280_768 \
        1280_1024 \
        1600_1200 \
        1920_1080 \
        1920_1200
do

echo "Building $i"

mkdir -p working/$i

if [[ "$i" == "1920_1080" || "$i" == "1920_1200" ]]; then
    s=6
else
    s=8
fi

cat life.xise | sed "s#working#working/$i#" | sed "s#VGA_XXX_XXX#VGA_$i STAGES=$s#" > life_tmp.xise

if [ ! -f working/$i/life.bit ]; then
xtclsh > working/$i.log 2>&1 <<EOF
project open life_tmp.xise
project clean
process run "Generate Programming File"
project close
exit
EOF
fi

promgen -u 0 working/$i/life.bit -o working/$i/life.mcs -p mcs -w -spi -s 512

# Copy the various bitstream files
cp working/$i/life.bit $DIR/life_$i.bit
cp working/$i/life.bin $DIR/life_$i.bin
cp working/$i/life.mcs $DIR/life_$i.mcs

# Cleanup
rm -f life_tmp.xise

done


echo "Building Multiboot loader"

# Build the multiboot loader
mkdir -p working/multiboot

if [ ! -f working/multiboot/MultiBootLoader.bit ]; then
xtclsh > working/multiboot.log 2>&1 <<EOF
project open multiboot.xise
project clean
process run "Generate Programming File"
project close
exit
EOF
fi

# multiboot loader - 0x000000 -
# design 1111      - 0x054000 - 1920 x 1080
# design 1110      - 0x0a8000 - 1600 x 1200
# design 1101      - 0x0fc000 - 1280 x 1024
# design 1100      - 0x150000 - 1280 x  768
# design 1011      - 0x1a4000 - 1280 x  720
# design 1010      - 0x1f8000 - 1024 x  768
# design 1001      - 0x24c000 -  800 x  600
# design 1000      - 0x2a0000 - spare
# design 0111      - 0x2f4000 - spare
# design 0110      - 0x348000 - spare
# design 0101      - 0x39c000 - spare

# -u 2A0000 working/spare/life.bit               \
# -u 2F4000 working/spare/life.bit               \
# -u 248000 working/spare/life.bit               \
# -u 39C000 working/spare/life.bit               \

for type in mcs bin
do

promgen                                          \
 -u      0 working/multiboot/MultiBootLoader.bit \
 -u  54000 working/1920_1080/life.bit            \
 -u  A8000 working/1600_1200/life.bit            \
 -u  FC000 working/1280_1024/life.bit            \
 -u 150000 working/1280_768/life.bit             \
 -u 1A4000 working/1280_720/life.bit             \
 -u 1F8000 working/1024_768/life.bit             \
 -u 24C000 working/800_600/life.bit              \
 -u 2A0000 working/1920_1200/life.bit            \
 -o working/multiboot/multiboot.mcs  -p ${type} -w -spi -s 4096

cp working/multiboot/multiboot.${type} $DIR

done

# Zip everything up
cd releases
zip -qr $NAME.zip `find $NAME -type f | sort`
echo
unzip -l $NAME.zip
cd ..
