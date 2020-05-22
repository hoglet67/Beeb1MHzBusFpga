#!/bin/bash

rm -f a.out
rm -f dump.vcd

# Create initial memory file
# (use /dev/zero or /dev/urandom)
dd if=/dev/zero bs=1024 count=512 | od -An -tx1 -w1 -v | tr -d ' ' > life.mem

SRCS="life_tb.v ../life.v oddr2.v dcm.v"

iverilog $SRCS
./a.out
gtkwave -g -a signals.gtkw dump.vcd
