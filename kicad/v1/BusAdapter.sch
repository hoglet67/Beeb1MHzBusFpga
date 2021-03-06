EESchema Schematic File Version 4
LIBS:BusAdapter-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J2
U 1 1 5C7514A2
P 6300 2050
F 0 "J2" H 6350 3167 50  0000 C CNN
F 1 "Conn_02x20_Odd_Even" H 6350 3076 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x20_P2.54mm_Vertical" H 6300 2050 50  0001 C CNN
F 3 "~" H 6300 2050 50  0001 C CNN
	1    6300 2050
	-1   0    0    -1
$EndComp
$Comp
L 74xx:74LS245 U1
U 1 1 5C7518B6
P 4500 1750
F 0 "U1" H 4850 2550 50  0000 C CNN
F 1 "74LVC245" H 4850 2450 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket" H 4500 1750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS245" H 4500 1750 50  0001 C CNN
	1    4500 1750
	-1   0    0    -1
$EndComp
$Comp
L 74xx:74LS245 U2
U 1 1 5C75192C
P 4500 4050
F 0 "U2" H 4800 4850 50  0000 C CNN
F 1 "74LVC245" H 4800 4750 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket" H 4500 4050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS245" H 4500 4050 50  0001 C CNN
	1    4500 4050
	-1   0    0    -1
$EndComp
Wire Wire Line
	1800 2750 1800 2650
Wire Wire Line
	1800 1950 1700 1950
Wire Wire Line
	1800 2750 1700 2750
Wire Wire Line
	1700 2650 1800 2650
Connection ~ 1800 2650
Wire Wire Line
	1800 2650 1800 2550
Wire Wire Line
	1700 2550 1800 2550
Connection ~ 1800 2550
Wire Wire Line
	1800 2550 1800 2450
Wire Wire Line
	1700 2450 1800 2450
Connection ~ 1800 2450
Wire Wire Line
	1800 2450 1800 2350
Wire Wire Line
	1700 2350 1800 2350
Connection ~ 1800 2350
Wire Wire Line
	1800 2350 1800 2250
Wire Wire Line
	1700 2250 1800 2250
Connection ~ 1800 2250
Wire Wire Line
	1800 2250 1800 2150
Wire Wire Line
	1700 2150 1800 2150
Connection ~ 1800 2150
Wire Wire Line
	1800 2150 1800 2050
Wire Wire Line
	1700 2050 1800 2050
Connection ~ 1800 2050
Wire Wire Line
	1800 2050 1800 1950
Text Label 1700 1850 0    50   ~ 0
D1
Text Label 1700 1750 0    50   ~ 0
D3
Text Label 1700 1650 0    50   ~ 0
D5
Text Label 1700 1550 0    50   ~ 0
D7
Text Label 1700 1450 0    50   ~ 0
A0
Text Label 1700 1350 0    50   ~ 0
A2
Text Label 1700 1250 0    50   ~ 0
A4
Text Label 1700 1150 0    50   ~ 0
A6
$Comp
L Connector_Generic:Conn_02x17_Odd_Even J1
U 1 1 5C751EFF
P 1500 1950
F 0 "J1" H 1550 900 50  0000 C CNN
F 1 "Conn_02x17_Odd_Even" H 1550 1000 50  0000 C CNN
F 2 "Connector_IDC:IDC-Header_2x17_P2.54mm_Horizontal_Lock" H 1500 1950 50  0001 C CNN
F 3 "~" H 1500 1950 50  0001 C CNN
	1    1500 1950
	-1   0    0    1
$EndComp
Text Label 1200 2750 2    50   ~ 0
RnW
Text Label 1200 2650 2    50   ~ 0
1MHZE
Text Label 1200 2550 2    50   ~ 0
NNMI
Text Label 1200 2450 2    50   ~ 0
NIRQ
Text Label 1200 2350 2    50   ~ 0
NPGFC
Text Label 1200 2250 2    50   ~ 0
NPGFD
Text Label 1200 2150 2    50   ~ 0
NRST
Text Label 1200 1950 2    50   ~ 0
D0
Text Label 1200 1850 2    50   ~ 0
D2
Text Label 1200 1750 2    50   ~ 0
D4
Text Label 1200 1650 2    50   ~ 0
D6
Text Label 1200 1450 2    50   ~ 0
A1
Text Label 1200 1350 2    50   ~ 0
A3
Text Label 1200 1250 2    50   ~ 0
A5
Text Label 1200 1150 2    50   ~ 0
A7
$Comp
L 74xx:74LS245 U3
U 1 1 5C75207C
P 4500 6400
F 0 "U3" H 4800 7200 50  0000 C CNN
F 1 "74LVC245" H 4800 7100 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket" H 4500 6400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS245" H 4500 6400 50  0001 C CNN
	1    4500 6400
	-1   0    0    -1
$EndComp
Text Label 4000 1950 2    50   ~ 0
A7
Text Label 4000 1850 2    50   ~ 0
A6
Text Label 4000 1750 2    50   ~ 0
A5
Text Label 4000 1650 2    50   ~ 0
A4
Text Label 4000 1550 2    50   ~ 0
A3
Text Label 4000 1450 2    50   ~ 0
A2
Text Label 4000 1350 2    50   ~ 0
A1
Text Label 4000 1250 2    50   ~ 0
A0
Text Label 5000 1250 0    50   ~ 0
LV_A0
Text Label 5000 1350 0    50   ~ 0
LV_A1
Text Label 5000 1450 0    50   ~ 0
LV_A2
Text Label 5000 1550 0    50   ~ 0
LV_A3
Text Label 5000 1650 0    50   ~ 0
LV_A4
Text Label 5000 1750 0    50   ~ 0
LV_A5
Text Label 5000 1850 0    50   ~ 0
LV_A6
Text Label 5000 1950 0    50   ~ 0
LV_A7
Text Label 5000 3550 0    50   ~ 0
LV_D0
Text Label 5000 3650 0    50   ~ 0
LV_D1
Text Label 5000 3750 0    50   ~ 0
LV_D2
Text Label 5000 3850 0    50   ~ 0
LV_D3
Text Label 5000 3950 0    50   ~ 0
LV_D4
Text Label 5000 4050 0    50   ~ 0
LV_D5
Text Label 5000 4150 0    50   ~ 0
LV_D6
Text Label 5000 4250 0    50   ~ 0
LV_D7
Text Label 4000 3550 2    50   ~ 0
D0
Text Label 4000 3650 2    50   ~ 0
D1
Text Label 4000 3750 2    50   ~ 0
D2
Text Label 4000 3850 2    50   ~ 0
D3
Text Label 4000 3950 2    50   ~ 0
D4
Text Label 4000 4050 2    50   ~ 0
D5
Text Label 4000 4150 2    50   ~ 0
D6
Text Label 4000 4250 2    50   ~ 0
D7
Text Label 5000 4450 0    50   ~ 0
LV_DIR
Text Label 5000 4550 0    50   ~ 0
LV_OEL
Text Label 5000 5900 0    50   ~ 0
LV_RnW
Text Label 5000 6000 0    50   ~ 0
LV_1MHZE
Text Label 5000 6300 0    50   ~ 0
LV_NPGFC
Text Label 5000 6400 0    50   ~ 0
LV_NPGFD
Text Label 5000 6500 0    50   ~ 0
LV_NRST
Text Label 4000 5900 2    50   ~ 0
RnW
Text Label 4000 6000 2    50   ~ 0
1MHZE
Text Label 4000 6300 2    50   ~ 0
NPGFC
Text Label 4000 6400 2    50   ~ 0
NPGFD
NoConn ~ 5000 6100
NoConn ~ 5000 6600
NoConn ~ 5000 6200
$Comp
L Transistor_BJT:2N3904 Q2
U 1 1 5C7536E9
P 1450 7050
F 0 "Q2" H 1641 7096 50  0000 L CNN
F 1 "2N3904" H 1641 7005 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_HandSolder" H 1650 6975 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N3904.pdf" H 1450 7050 50  0001 L CNN
	1    1450 7050
	1    0    0    -1
$EndComp
Text Label 1550 6450 0    50   ~ 0
NNMI
$Comp
L Device:R R4
U 1 1 5C753A2A
P 1200 7250
F 0 "R4" H 1270 7296 50  0000 L CNN
F 1 "1K0" H 1270 7205 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 1130 7250 50  0001 C CNN
F 3 "~" H 1200 7250 50  0001 C CNN
	1    1200 7250
	1    0    0    -1
$EndComp
$Comp
L Device:R R2
U 1 1 5C753AB4
P 1000 7050
F 0 "R2" V 793 7050 50  0000 C CNN
F 1 "1K0" V 884 7050 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 930 7050 50  0001 C CNN
F 3 "~" H 1000 7050 50  0001 C CNN
	1    1000 7050
	0    1    1    0
$EndComp
Wire Wire Line
	1150 7050 1200 7050
Wire Wire Line
	1200 7100 1200 7050
Connection ~ 1200 7050
Wire Wire Line
	1200 7050 1250 7050
Wire Wire Line
	1200 7400 1200 7500
Wire Wire Line
	1200 7500 1550 7500
Wire Wire Line
	1550 7500 1550 7250
$Comp
L power:GND #PWR09
U 1 1 5C754305
P 4500 7200
F 0 "#PWR09" H 4500 6950 50  0001 C CNN
F 1 "GND" H 4505 7027 50  0000 C CNN
F 2 "" H 4500 7200 50  0001 C CNN
F 3 "" H 4500 7200 50  0001 C CNN
	1    4500 7200
	1    0    0    -1
$EndComp
$Comp
L power:GND #PWR05
U 1 1 5C754F09
P 4500 2550
F 0 "#PWR05" H 4500 2300 50  0001 C CNN
F 1 "GND" H 4505 2377 50  0000 C CNN
F 2 "" H 4500 2550 50  0001 C CNN
F 3 "" H 4500 2550 50  0001 C CNN
	1    4500 2550
	1    0    0    -1
$EndComp
$Comp
L power:GND #PWR07
U 1 1 5C754F58
P 4500 4850
F 0 "#PWR07" H 4500 4600 50  0001 C CNN
F 1 "GND" H 4505 4677 50  0000 C CNN
F 2 "" H 4500 4850 50  0001 C CNN
F 3 "" H 4500 4850 50  0001 C CNN
	1    4500 4850
	1    0    0    -1
$EndComp
Wire Wire Line
	1800 2750 2050 2750
Wire Wire Line
	2050 2750 2050 2850
Connection ~ 1800 2750
$Comp
L power:GND #PWR03
U 1 1 5C7558CF
P 2050 2850
F 0 "#PWR03" H 2050 2600 50  0001 C CNN
F 1 "GND" H 2055 2677 50  0000 C CNN
F 2 "" H 2050 2850 50  0001 C CNN
F 3 "" H 2050 2850 50  0001 C CNN
	1    2050 2850
	1    0    0    -1
$EndComp
$Comp
L power:GND #PWR02
U 1 1 5C755942
P 1550 7500
F 0 "#PWR02" H 1550 7250 50  0001 C CNN
F 1 "GND" H 1555 7327 50  0000 C CNN
F 2 "" H 1550 7500 50  0001 C CNN
F 3 "" H 1550 7500 50  0001 C CNN
	1    1550 7500
	1    0    0    -1
$EndComp
Connection ~ 1550 7500
Text Label 850  7050 2    50   ~ 0
LV_NMI
$Comp
L Transistor_BJT:2N3904 Q1
U 1 1 5C756046
P 1450 4650
F 0 "Q1" H 1641 4696 50  0000 L CNN
F 1 "2N3904" H 1641 4605 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_HandSolder" H 1650 4575 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N3904.pdf" H 1450 4650 50  0001 L CNN
	1    1450 4650
	1    0    0    -1
$EndComp
Wire Wire Line
	1550 4450 1550 4300
Text Label 1550 4050 0    50   ~ 0
NIRQ
$Comp
L Device:R R3
U 1 1 5C75604F
P 1200 4850
F 0 "R3" H 1270 4896 50  0000 L CNN
F 1 "1K0" H 1270 4805 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 1130 4850 50  0001 C CNN
F 3 "~" H 1200 4850 50  0001 C CNN
	1    1200 4850
	1    0    0    -1
$EndComp
$Comp
L Device:R R1
U 1 1 5C756055
P 1000 4650
F 0 "R1" V 793 4650 50  0000 C CNN
F 1 "1K0" V 884 4650 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 930 4650 50  0001 C CNN
F 3 "~" H 1000 4650 50  0001 C CNN
	1    1000 4650
	0    1    1    0
$EndComp
Wire Wire Line
	1150 4650 1200 4650
Wire Wire Line
	1200 4700 1200 4650
Connection ~ 1200 4650
Wire Wire Line
	1200 4650 1250 4650
Wire Wire Line
	1200 5000 1200 5100
Wire Wire Line
	1200 5100 1550 5100
Wire Wire Line
	1550 5100 1550 4850
$Comp
L power:GND #PWR01
U 1 1 5C756062
P 1550 5100
F 0 "#PWR01" H 1550 4850 50  0001 C CNN
F 1 "GND" H 1555 4927 50  0000 C CNN
F 2 "" H 1550 5100 50  0001 C CNN
F 3 "" H 1550 5100 50  0001 C CNN
	1    1550 5100
	1    0    0    -1
$EndComp
Connection ~ 1550 5100
Text Label 850  4650 2    50   ~ 0
LV_IRQ
Text Label 4000 6500 2    50   ~ 0
NRST
$Comp
L power:+3.3V #PWR08
U 1 1 5C75891B
P 4500 5600
F 0 "#PWR08" H 4500 5450 50  0001 C CNN
F 1 "+3.3V" H 4515 5773 50  0000 C CNN
F 2 "" H 4500 5600 50  0001 C CNN
F 3 "" H 4500 5600 50  0001 C CNN
	1    4500 5600
	1    0    0    -1
$EndComp
$Comp
L power:+3.3V #PWR06
U 1 1 5C7589C1
P 4500 3250
F 0 "#PWR06" H 4500 3100 50  0001 C CNN
F 1 "+3.3V" H 4515 3423 50  0000 C CNN
F 2 "" H 4500 3250 50  0001 C CNN
F 3 "" H 4500 3250 50  0001 C CNN
	1    4500 3250
	1    0    0    -1
$EndComp
$Comp
L power:+3.3V #PWR04
U 1 1 5C758A97
P 4500 950
F 0 "#PWR04" H 4500 800 50  0001 C CNN
F 1 "+3.3V" H 4515 1123 50  0000 C CNN
F 2 "" H 4500 950 50  0001 C CNN
F 3 "" H 4500 950 50  0001 C CNN
	1    4500 950
	1    0    0    -1
$EndComp
Text Label 8050 1650 0    50   ~ 0
GND
Text Label 8050 2550 0    50   ~ 0
GND
Text Label 7550 1650 2    50   ~ 0
+3V3
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J3
U 1 1 5C768704
P 7750 2150
F 0 "J3" H 7800 3267 50  0000 C CNN
F 1 "Conn_02x20_Odd_Even" H 7800 3176 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x20_P2.54mm_Vertical" H 7750 2150 50  0001 C CNN
F 3 "~" H 7750 2150 50  0001 C CNN
	1    7750 2150
	1    0    0    1
$EndComp
Text Label 6000 2550 2    50   ~ 0
GND
Text Label 6000 1650 2    50   ~ 0
GND
Text Label 6500 2550 0    50   ~ 0
+3V3
Text Label 7300 3850 0    50   ~ 0
RAMD0
Text Label 7300 3950 0    50   ~ 0
RAMD1
Text Label 7300 4050 0    50   ~ 0
RAMD2
Text Label 7300 4150 0    50   ~ 0
RAMD3
Text Label 7300 4250 0    50   ~ 0
RAMD4
Text Label 7300 4350 0    50   ~ 0
RAMD5
Text Label 7300 4450 0    50   ~ 0
RAMD6
Text Label 7300 4550 0    50   ~ 0
RAMD7
Text Label 6100 3850 2    50   ~ 0
RAMA0
Text Label 6100 3950 2    50   ~ 0
RAMA1
Text Label 6100 4050 2    50   ~ 0
RAMA2
Text Label 6100 4150 2    50   ~ 0
RAMA3
Text Label 6100 4250 2    50   ~ 0
RAMA4
Text Label 6100 4350 2    50   ~ 0
RAMA5
Text Label 6100 4450 2    50   ~ 0
RAMA6
Text Label 6100 4550 2    50   ~ 0
RAMA7
Text Label 6100 4650 2    50   ~ 0
RAMA8
Text Label 6100 4750 2    50   ~ 0
RAMA9
Text Label 6100 4850 2    50   ~ 0
RAMA10
Text Label 6100 4950 2    50   ~ 0
RAMA11
Text Label 6100 5050 2    50   ~ 0
RAMA12
Text Label 6100 5150 2    50   ~ 0
RAMA13
Text Label 6100 5250 2    50   ~ 0
RAMA14
Text Label 6100 5350 2    50   ~ 0
RAMA15
Text Label 6100 5450 2    50   ~ 0
RAMA16
Text Label 6100 5550 2    50   ~ 0
RAMA17
Text Label 6100 5650 2    50   ~ 0
RAMA18
Text Label 6100 5850 2    50   ~ 0
RAMCEL
Text Label 6100 5950 2    50   ~ 0
RAMOEL
Text Label 6100 6050 2    50   ~ 0
RAMWEL
$Comp
L power:+3.3V #PWR012
U 1 1 5C76D99B
P 6700 3650
F 0 "#PWR012" H 6700 3500 50  0001 C CNN
F 1 "+3.3V" H 6715 3823 50  0000 C CNN
F 2 "" H 6700 3650 50  0001 C CNN
F 3 "" H 6700 3650 50  0001 C CNN
	1    6700 3650
	1    0    0    -1
$EndComp
$Comp
L power:GND #PWR013
U 1 1 5C76DA9D
P 6700 6250
F 0 "#PWR013" H 6700 6000 50  0001 C CNN
F 1 "GND" H 6705 6077 50  0000 C CNN
F 2 "" H 6700 6250 50  0001 C CNN
F 3 "" H 6700 6250 50  0001 C CNN
	1    6700 6250
	1    0    0    -1
$EndComp
Text Label 6000 1150 2    50   ~ 0
LV_A7
Text Label 6000 1250 2    50   ~ 0
LV_A6
Text Label 6000 1350 2    50   ~ 0
LV_A5
Text Label 6000 1450 2    50   ~ 0
LV_A4
Text Label 6000 1550 2    50   ~ 0
LV_A3
Text Label 6000 1750 2    50   ~ 0
LV_A2
Text Label 6000 1850 2    50   ~ 0
LV_A1
Text Label 6000 1950 2    50   ~ 0
LV_A0
$Comp
L Memory_RAM:IS64C5128AL-12KLA3 U4
U 1 1 5C76DE2E
P 6700 4950
F 0 "U4" H 6200 6350 50  0000 C CNN
F 1 "IDT 71V424S12" H 6200 6250 50  0000 C CNN
F 2 "Package_SO:SOJ-36_10.16x23.49mm_P1.27mm" H 6200 6100 50  0001 C CNN
F 3 "http://www.issi.com/WW/pdf/61-64C5128AL.pdf" H 6700 4950 50  0001 C CNN
	1    6700 4950
	1    0    0    -1
$EndComp
Text Label 6000 2050 2    50   ~ 0
LV_D7
Text Label 6000 2150 2    50   ~ 0
LV_D6
Text Label 6000 2250 2    50   ~ 0
LV_D5
Text Label 6000 2350 2    50   ~ 0
LV_D4
Text Label 6000 2450 2    50   ~ 0
LV_D3
Text Label 6000 2650 2    50   ~ 0
LV_D2
Text Label 6000 2750 2    50   ~ 0
LV_D1
Text Label 6000 2850 2    50   ~ 0
LV_D0
Text Label 6000 3050 2    50   ~ 0
LV_DIR
Text Label 6000 2950 2    50   ~ 0
LV_OEL
Text Label 6500 1150 0    50   ~ 0
RAMA10
Text Label 6500 1250 0    50   ~ 0
RAMA11
Text Label 6500 1350 0    50   ~ 0
RAMA12
Text Label 6500 1450 0    50   ~ 0
RAMA13
Text Label 6500 1550 0    50   ~ 0
RAMA14
Text Label 6500 1750 0    50   ~ 0
RAMD4
Text Label 6500 1850 0    50   ~ 0
RAMD5
Text Label 6500 1950 0    50   ~ 0
RAMD6
Text Label 6500 2050 0    50   ~ 0
RAMD7
Text Label 7550 2950 2    50   ~ 0
LV_1MHZE
Text Label 6500 2250 0    50   ~ 0
RAMA15
Text Label 6500 2350 0    50   ~ 0
RAMA16
Text Label 6500 2450 0    50   ~ 0
RAMA17
Text Label 6500 2650 0    50   ~ 0
RAMA18
Text Label 6500 2150 0    50   ~ 0
RAMOEL
Text Label 7550 1150 2    50   ~ 0
RAMA9
Text Label 7550 1250 2    50   ~ 0
RAMA8
Text Label 7550 1350 2    50   ~ 0
RAMA7
Text Label 7550 1450 2    50   ~ 0
RAMA6
Text Label 7550 1550 2    50   ~ 0
RAMA5
Text Label 7550 1750 2    50   ~ 0
RAMWEL
Text Label 7550 1850 2    50   ~ 0
RAMD3
Text Label 7550 1950 2    50   ~ 0
RAMD2
Text Label 7550 2050 2    50   ~ 0
RAMD1
Text Label 7550 2150 2    50   ~ 0
RAMD0
Text Label 7550 2250 2    50   ~ 0
RAMCEL
Text Label 7550 2350 2    50   ~ 0
RAMA4
Text Label 7550 2450 2    50   ~ 0
RAMA3
Text Label 7550 2650 2    50   ~ 0
RAMA2
Text Label 7550 2750 2    50   ~ 0
RAMA1
Text Label 7550 2850 2    50   ~ 0
RAMA0
Text Label 6500 2750 0    50   ~ 0
LV_RnW
Text Label 6500 3050 0    50   ~ 0
LV_NPGFD
Text Label 6500 2850 0    50   ~ 0
LV_NPGFC
Text Label 6500 2950 0    50   ~ 0
LV_NRST
Text Label 7550 3050 2    50   ~ 0
LV_IRQ
Text Label 8050 3050 0    50   ~ 0
LV_NMI
Text Label 10000 1400 2    50   ~ 0
GND
Text Label 10000 1500 2    50   ~ 0
+3V3
Text Label 10500 1400 0    50   ~ 0
GND
Text Label 10500 1500 0    50   ~ 0
+3V3
Text Label 10500 1000 0    50   ~ 0
PMOD0_4
Text Label 10500 1100 0    50   ~ 0
PMOD0_5
Text Label 10500 1200 0    50   ~ 0
PMOD0_6
Text Label 10500 1300 0    50   ~ 0
PMOD0_7
Text Label 10000 1000 2    50   ~ 0
PMOD0_0
Text Label 10000 1100 2    50   ~ 0
PMOD0_1
Text Label 10000 1200 2    50   ~ 0
PMOD0_2
Text Label 10000 1300 2    50   ~ 0
PMOD0_3
Text Label 8050 1250 0    50   ~ 0
PMOD0_0
Text Label 8050 1350 0    50   ~ 0
PMOD0_4
Text Label 8050 1450 0    50   ~ 0
PMOD0_1
Text Label 8050 1550 0    50   ~ 0
PMOD0_5
Text Label 8050 1750 0    50   ~ 0
PMOD0_2
Text Label 8050 1850 0    50   ~ 0
PMOD0_6
Text Label 8050 1950 0    50   ~ 0
PMOD0_3
Text Label 8050 2050 0    50   ~ 0
PMOD0_7
Text Label 10000 2900 2    50   ~ 0
GND
Text Label 10000 3000 2    50   ~ 0
+3V3
Text Label 10500 2900 0    50   ~ 0
GND
Text Label 10500 3000 0    50   ~ 0
+3V3
Text Label 10500 2500 0    50   ~ 0
PMOD1_4
Text Label 10500 2600 0    50   ~ 0
PMOD1_5
Text Label 10500 2700 0    50   ~ 0
PMOD1_6
Text Label 10500 2800 0    50   ~ 0
PMOD1_7
Text Label 10000 2600 2    50   ~ 0
PMOD1_1
Text Label 10000 2700 2    50   ~ 0
PMOD1_2
Text Label 10000 2800 2    50   ~ 0
PMOD1_3
Text Label 8050 2150 0    50   ~ 0
PMOD1_0
Text Label 8050 2250 0    50   ~ 0
PMOD1_4
Text Label 8050 2350 0    50   ~ 0
PMOD1_1
Text Label 8050 2450 0    50   ~ 0
PMOD1_5
Text Label 8050 2650 0    50   ~ 0
PMOD1_2
Text Label 8050 2750 0    50   ~ 0
PMOD1_6
Text Label 8050 2850 0    50   ~ 0
PMOD1_3
Text Label 8050 2950 0    50   ~ 0
PMOD1_7
$Comp
L Device:C_Small C2
U 1 1 5C77110B
P 8600 5950
F 0 "C2" H 8692 5996 50  0000 L CNN
F 1 "100n" H 8692 5905 50  0000 L CNN
F 2 "Capacitor_THT:C_Axial_L5.1mm_D3.1mm_P10.00mm_Horizontal" H 8600 5950 50  0001 C CNN
F 3 "~" H 8600 5950 50  0001 C CNN
	1    8600 5950
	1    0    0    -1
$EndComp
$Comp
L Device:C_Small C3
U 1 1 5C771D25
P 9000 5950
F 0 "C3" H 9092 5996 50  0000 L CNN
F 1 "100n" H 9092 5905 50  0000 L CNN
F 2 "Capacitor_THT:C_Axial_L5.1mm_D3.1mm_P10.00mm_Horizontal" H 9000 5950 50  0001 C CNN
F 3 "~" H 9000 5950 50  0001 C CNN
	1    9000 5950
	1    0    0    -1
$EndComp
$Comp
L Device:C_Small C4
U 1 1 5C771D63
P 9400 5950
F 0 "C4" H 9492 5996 50  0000 L CNN
F 1 "100n" H 9492 5905 50  0000 L CNN
F 2 "Capacitor_THT:C_Axial_L5.1mm_D3.1mm_P10.00mm_Horizontal" H 9400 5950 50  0001 C CNN
F 3 "~" H 9400 5950 50  0001 C CNN
	1    9400 5950
	1    0    0    -1
$EndComp
$Comp
L Device:C_Small C5
U 1 1 5C771DA7
P 9800 5950
F 0 "C5" H 9892 5996 50  0000 L CNN
F 1 "100n" H 9892 5905 50  0000 L CNN
F 2 "Capacitor_THT:C_Axial_L5.1mm_D3.1mm_P10.00mm_Horizontal" H 9800 5950 50  0001 C CNN
F 3 "~" H 9800 5950 50  0001 C CNN
	1    9800 5950
	1    0    0    -1
$EndComp
Wire Wire Line
	8600 6050 8600 6100
Wire Wire Line
	8600 6100 9000 6100
Wire Wire Line
	9800 6100 9800 6050
Wire Wire Line
	9000 6050 9000 6100
Connection ~ 9000 6100
Wire Wire Line
	9400 6050 9400 6100
Wire Wire Line
	8600 5850 8600 5800
Wire Wire Line
	8600 5800 9000 5800
Wire Wire Line
	9800 5800 9800 5850
Wire Wire Line
	9400 5850 9400 5800
Wire Wire Line
	9000 5850 9000 5800
Wire Wire Line
	9000 5800 9400 5800
Wire Wire Line
	9400 6100 9800 6100
Wire Wire Line
	9400 5800 9400 5750
Connection ~ 9400 5800
$Comp
L power:+3.3V #PWR010
U 1 1 5C7804D2
P 9400 5750
F 0 "#PWR010" H 9400 5600 50  0001 C CNN
F 1 "+3.3V" H 9415 5923 50  0000 C CNN
F 2 "" H 9400 5750 50  0001 C CNN
F 3 "" H 9400 5750 50  0001 C CNN
	1    9400 5750
	1    0    0    -1
$EndComp
$Comp
L power:GND #PWR011
U 1 1 5C780534
P 9400 6150
F 0 "#PWR011" H 9400 5900 50  0001 C CNN
F 1 "GND" H 9405 5977 50  0000 C CNN
F 2 "" H 9400 6150 50  0001 C CNN
F 3 "" H 9400 6150 50  0001 C CNN
	1    9400 6150
	1    0    0    -1
$EndComp
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5C785A91
P 8600 5800
F 0 "#FLG01" H 8600 5875 50  0001 C CNN
F 1 "PWR_FLAG" H 8600 5974 50  0000 C CNN
F 2 "" H 8600 5800 50  0001 C CNN
F 3 "~" H 8600 5800 50  0001 C CNN
	1    8600 5800
	1    0    0    -1
$EndComp
Connection ~ 8600 5800
$Comp
L power:PWR_FLAG #FLG02
U 1 1 5C785B38
P 8600 6100
F 0 "#FLG02" H 8600 6175 50  0001 C CNN
F 1 "PWR_FLAG" H 8600 6273 50  0000 C CNN
F 2 "" H 8600 6100 50  0001 C CNN
F 3 "~" H 8600 6100 50  0001 C CNN
	1    8600 6100
	1    0    0    1
$EndComp
Connection ~ 8600 6100
Text Label 4000 6100 2    50   ~ 0
GND
Text Label 4000 6200 2    50   ~ 0
GND
Text Label 4000 6600 2    50   ~ 0
GND
Text Label 5000 6800 0    50   ~ 0
GND
Text Label 5000 6900 0    50   ~ 0
GND
Text Label 5000 2150 0    50   ~ 0
GND
Text Label 5000 2250 0    50   ~ 0
GND
Wire Wire Line
	1200 1550 750  1550
Wire Wire Line
	750  1550 750  2950
Wire Wire Line
	750  2950 1800 2950
Wire Wire Line
	1800 2950 1800 2750
$Comp
L Analog_DAC:MCP4822 U5
U 1 1 5C78B962
P 8550 4500
F 0 "U5" H 8150 5000 50  0000 C CNN
F 1 "MCP4822" H 8150 4900 50  0000 C CNN
F 2 "Package_DIP:DIP-8_W7.62mm_Socket" H 9350 4200 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/20002249B.pdf" H 9350 4200 50  0001 C CNN
	1    8550 4500
	1    0    0    -1
$EndComp
$Comp
L power:+3.3V #PWR014
U 1 1 5C78BC0F
P 8550 4100
F 0 "#PWR014" H 8550 3950 50  0001 C CNN
F 1 "+3.3V" H 8565 4273 50  0000 C CNN
F 2 "" H 8550 4100 50  0001 C CNN
F 3 "" H 8550 4100 50  0001 C CNN
	1    8550 4100
	1    0    0    -1
$EndComp
$Comp
L power:GND #PWR015
U 1 1 5C78BC88
P 8550 5000
F 0 "#PWR015" H 8550 4750 50  0001 C CNN
F 1 "GND" H 8555 4827 50  0000 C CNN
F 2 "" H 8550 5000 50  0001 C CNN
F 3 "" H 8550 5000 50  0001 C CNN
	1    8550 5000
	1    0    0    -1
$EndComp
Text Label 8050 4500 2    50   ~ 0
PMOD1_0
Text Label 8050 4600 2    50   ~ 0
PMOD1_1
Text Label 8050 4400 2    50   ~ 0
PMOD1_2
Text Label 8050 4700 2    50   ~ 0
PMOD1_3
$Comp
L Connector:Conn_Coaxial J6
U 1 1 5C78C10F
P 10150 4200
F 0 "J6" H 10249 4176 50  0000 L CNN
F 1 "Conn_Coaxial" H 10249 4085 50  0000 L CNN
F 2 "footprints:phono" H 10150 4200 50  0001 C CNN
F 3 " ~" H 10150 4200 50  0001 C CNN
	1    10150 4200
	1    0    0    -1
$EndComp
$Comp
L Connector:Conn_Coaxial J7
U 1 1 5C78C1DA
P 10150 4900
F 0 "J7" H 10249 4876 50  0000 L CNN
F 1 "Conn_Coaxial" H 10249 4785 50  0000 L CNN
F 2 "footprints:phono" H 10150 4900 50  0001 C CNN
F 3 " ~" H 10150 4900 50  0001 C CNN
	1    10150 4900
	1    0    0    -1
$EndComp
$Comp
L power:GND #PWR016
U 1 1 5C78C31A
P 10150 4400
F 0 "#PWR016" H 10150 4150 50  0001 C CNN
F 1 "GND" H 10155 4227 50  0000 C CNN
F 2 "" H 10150 4400 50  0001 C CNN
F 3 "" H 10150 4400 50  0001 C CNN
	1    10150 4400
	1    0    0    -1
$EndComp
$Comp
L power:GND #PWR017
U 1 1 5C78C351
P 10150 5100
F 0 "#PWR017" H 10150 4850 50  0001 C CNN
F 1 "GND" H 10155 4927 50  0000 C CNN
F 2 "" H 10150 5100 50  0001 C CNN
F 3 "" H 10150 5100 50  0001 C CNN
	1    10150 5100
	1    0    0    -1
$EndComp
$Comp
L Device:C_Small C7
U 1 1 5C78C6F9
P 9750 4200
F 0 "C7" V 9521 4200 50  0000 C CNN
F 1 "1u" V 9612 4200 50  0000 C CNN
F 2 "Capacitor_THT:C_Rect_L7.2mm_W5.5mm_P5.00mm_FKS2_FKP2_MKS2_MKP2" H 9750 4200 50  0001 C CNN
F 3 "~" H 9750 4200 50  0001 C CNN
	1    9750 4200
	0    1    1    0
$EndComp
$Comp
L Device:C_Small C8
U 1 1 5C78C83C
P 9750 4900
F 0 "C8" V 9521 4900 50  0000 C CNN
F 1 "1u" V 9612 4900 50  0000 C CNN
F 2 "Capacitor_THT:C_Rect_L7.2mm_W5.5mm_P5.00mm_FKS2_FKP2_MKS2_MKP2" H 9750 4900 50  0001 C CNN
F 3 "~" H 9750 4900 50  0001 C CNN
	1    9750 4900
	0    1    1    0
$EndComp
Wire Wire Line
	9850 4200 9950 4200
Wire Wire Line
	9850 4900 9950 4900
Wire Wire Line
	9050 4400 9350 4400
Wire Wire Line
	9350 4400 9350 4200
Wire Wire Line
	9350 4200 9650 4200
Wire Wire Line
	9050 4700 9350 4700
Wire Wire Line
	9350 4700 9350 4900
Wire Wire Line
	9350 4900 9650 4900
Connection ~ 9400 6100
$Comp
L Device:C_Small C1
U 1 1 5C798365
P 8150 5950
F 0 "C1" H 8242 5996 50  0000 L CNN
F 1 "100n" H 8242 5905 50  0000 L CNN
F 2 "Capacitor_THT:C_Axial_L5.1mm_D3.1mm_P10.00mm_Horizontal" H 8150 5950 50  0001 C CNN
F 3 "~" H 8150 5950 50  0001 C CNN
	1    8150 5950
	1    0    0    -1
$EndComp
Wire Wire Line
	10200 6100 10200 6050
Wire Wire Line
	10200 5800 10200 5850
Wire Wire Line
	9800 5800 10200 5800
Wire Wire Line
	9800 6100 10200 6100
Connection ~ 9800 5800
Connection ~ 9800 6100
Wire Wire Line
	9400 5800 9800 5800
Connection ~ 9000 5800
Wire Wire Line
	9400 6150 9400 6100
Wire Wire Line
	9000 6100 9400 6100
NoConn ~ 1200 2050
$Comp
L Device:CP_Small C6
U 1 1 5C7A0AD1
P 10200 5950
F 0 "C6" H 10288 5996 50  0000 L CNN
F 1 "10u" H 10288 5905 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.50mm" H 10200 5950 50  0001 C CNN
F 3 "~" H 10200 5950 50  0001 C CNN
	1    10200 5950
	1    0    0    -1
$EndComp
Wire Wire Line
	8600 5800 8150 5800
Wire Wire Line
	8150 5800 8150 5850
Wire Wire Line
	8600 6100 8150 6100
Wire Wire Line
	8150 6100 8150 6050
$Comp
L Device:R_Network08 RN6
U 1 1 5C7B918C
P 3400 1650
F 0 "RN6" V 2783 1650 50  0000 C CNN
F 1 "R_Network08" V 2874 1650 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP9" V 3875 1650 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 3400 1650 50  0001 C CNN
	1    3400 1650
	0    1    1    0
$EndComp
$Comp
L Device:R_Network08 RN3
U 1 1 5C7D5DAA
P 2800 1650
F 0 "RN3" V 2183 1650 50  0000 C CNN
F 1 "R_Network08" V 2274 1650 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP9" V 3275 1650 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 2800 1650 50  0001 C CNN
	1    2800 1650
	0    -1   1    0
$EndComp
Wire Wire Line
	3000 1250 3200 1250
Wire Wire Line
	3000 1350 3200 1350
Wire Wire Line
	3000 1450 3200 1450
Wire Wire Line
	3000 1550 3200 1550
Wire Wire Line
	3000 1650 3200 1650
Wire Wire Line
	3000 1750 3200 1750
Wire Wire Line
	3000 1850 3200 1850
Wire Wire Line
	3000 1950 3200 1950
Text Label 2600 1250 2    50   ~ 0
GND
Text Label 3600 1250 0    50   ~ 0
+3V3
Text Label 3150 1250 2    50   ~ 0
A0
Text Label 3150 1350 2    50   ~ 0
A1
Text Label 3150 1450 2    50   ~ 0
A2
Text Label 3150 1550 2    50   ~ 0
A3
Text Label 3150 1650 2    50   ~ 0
A4
Text Label 3150 1750 2    50   ~ 0
A5
Text Label 3150 1850 2    50   ~ 0
A6
Text Label 3150 1950 2    50   ~ 0
A7
$Comp
L Device:R_Network08 RN5
U 1 1 5C7EC7D7
P 3350 3950
F 0 "RN5" V 2733 3950 50  0000 C CNN
F 1 "R_Network08" V 2824 3950 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP9" V 3825 3950 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 3350 3950 50  0001 C CNN
	1    3350 3950
	0    1    1    0
$EndComp
$Comp
L Device:R_Network08 RN2
U 1 1 5C7EC7DD
P 2750 3950
F 0 "RN2" V 2133 3950 50  0000 C CNN
F 1 "R_Network08" V 2224 3950 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP9" V 3225 3950 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 2750 3950 50  0001 C CNN
	1    2750 3950
	0    -1   1    0
$EndComp
Wire Wire Line
	2950 3550 3150 3550
Wire Wire Line
	2950 3650 3150 3650
Wire Wire Line
	2950 3750 3150 3750
Wire Wire Line
	2950 3850 3150 3850
Wire Wire Line
	2950 3950 3150 3950
Wire Wire Line
	2950 4050 3150 4050
Wire Wire Line
	2950 4150 3150 4150
Wire Wire Line
	2950 4250 3150 4250
Text Label 2550 3550 2    50   ~ 0
GND
Text Label 3550 3550 0    50   ~ 0
+3V3
Text Label 3100 3550 2    50   ~ 0
D0
Text Label 3100 3650 2    50   ~ 0
D1
Text Label 3100 3750 2    50   ~ 0
D2
Text Label 3100 3850 2    50   ~ 0
D3
Text Label 3100 3950 2    50   ~ 0
D4
Text Label 3100 4050 2    50   ~ 0
D5
Text Label 3100 4150 2    50   ~ 0
D6
Text Label 3100 4250 2    50   ~ 0
D7
$Comp
L Device:R_Network08 RN4
U 1 1 5C7F9A02
P 3250 6250
F 0 "RN4" V 2633 6250 50  0000 C CNN
F 1 "R_Network08" V 2724 6250 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP9" V 3725 6250 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 3250 6250 50  0001 C CNN
	1    3250 6250
	0    1    1    0
$EndComp
$Comp
L Device:R_Network08 RN1
U 1 1 5C7F9A08
P 2650 6250
F 0 "RN1" V 2033 6250 50  0000 C CNN
F 1 "R_Network08" V 2124 6250 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP9" V 3125 6250 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 2650 6250 50  0001 C CNN
	1    2650 6250
	0    -1   1    0
$EndComp
Text Label 2450 5850 2    50   ~ 0
GND
Text Label 3450 5850 0    50   ~ 0
+3V3
Wire Wire Line
	2850 5850 3050 5850
Wire Wire Line
	2850 5950 3050 5950
Wire Wire Line
	2850 6250 3050 6250
Wire Wire Line
	2850 6350 3050 6350
NoConn ~ 2850 6050
NoConn ~ 2850 6150
NoConn ~ 2850 6450
NoConn ~ 2850 6550
NoConn ~ 3050 6550
NoConn ~ 3050 6450
NoConn ~ 3050 6150
NoConn ~ 3050 6050
Text Label 3050 5850 2    50   ~ 0
RnW
Text Label 3050 5950 2    50   ~ 0
1MHZE
Text Label 3050 6250 2    50   ~ 0
NPGFC
Text Label 3050 6350 2    50   ~ 0
NPGFD
NoConn ~ 7550 2550
NoConn ~ 6500 1650
$Comp
L Device:R R5
U 1 1 5C7810FB
P 8950 1150
F 0 "R5" V 8743 1150 50  0000 C CNN
F 1 "330" V 8834 1150 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 8880 1150 50  0001 C CNN
F 3 "~" H 8950 1150 50  0001 C CNN
	1    8950 1150
	0    1    1    0
$EndComp
$Comp
L Device:LED D1
U 1 1 5C785A83
P 9150 1350
F 0 "D1" V 9188 1233 50  0000 R CNN
F 1 "LED" V 9097 1233 50  0000 R CNN
F 2 "LED_THT:LED_D3.0mm" H 9150 1350 50  0001 C CNN
F 3 "~" H 9150 1350 50  0001 C CNN
	1    9150 1350
	0    -1   -1   0
$EndComp
$Comp
L power:GND #PWR018
U 1 1 5C785B84
P 9150 1550
F 0 "#PWR018" H 9150 1300 50  0001 C CNN
F 1 "GND" H 9155 1377 50  0000 C CNN
F 2 "" H 9150 1550 50  0001 C CNN
F 3 "" H 9150 1550 50  0001 C CNN
	1    9150 1550
	1    0    0    -1
$EndComp
Wire Wire Line
	9100 1150 9150 1150
Wire Wire Line
	9150 1150 9150 1200
Wire Wire Line
	9150 1500 9150 1550
Wire Wire Line
	8050 1150 8800 1150
Text Label 10000 2500 2    50   ~ 0
PMOD1_0
$Comp
L power:GND #PWR019
U 1 1 5C7C283A
P 9150 2300
F 0 "#PWR019" H 9150 2050 50  0001 C CNN
F 1 "GND" H 9155 2127 50  0000 C CNN
F 2 "" H 9150 2300 50  0001 C CNN
F 3 "" H 9150 2300 50  0001 C CNN
	1    9150 2300
	1    0    0    -1
$EndComp
$Comp
L Device:LED D2
U 1 1 5C7C2891
P 9150 2100
F 0 "D2" V 9188 1983 50  0000 R CNN
F 1 "LED" V 9097 1983 50  0000 R CNN
F 2 "LED_THT:LED_D3.0mm" H 9150 2100 50  0001 C CNN
F 3 "~" H 9150 2100 50  0001 C CNN
	1    9150 2100
	0    -1   -1   0
$EndComp
$Comp
L Device:R R6
U 1 1 5C7C2992
P 8950 1900
F 0 "R6" V 8743 1900 50  0000 C CNN
F 1 "330" V 8834 1900 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 8880 1900 50  0001 C CNN
F 3 "~" H 8950 1900 50  0001 C CNN
	1    8950 1900
	0    1    1    0
$EndComp
Wire Wire Line
	9100 1900 9150 1900
Wire Wire Line
	9150 1900 9150 1950
Wire Wire Line
	9150 2250 9150 2300
Text Label 8800 1900 2    50   ~ 0
+3V3
$Comp
L Connector_Generic:Conn_02x06_Top_Bottom J4
U 1 1 5C7D2E02
P 10200 1200
F 0 "J4" H 10250 1617 50  0000 C CNN
F 1 "Conn_02x06_Top_Bottom" H 10250 1526 50  0000 C CNN
F 2 "footprints:PinSocket_2x06_P2.54mm_Horizontal" H 10200 1200 50  0001 C CNN
F 3 "~" H 10200 1200 50  0001 C CNN
	1    10200 1200
	1    0    0    -1
$EndComp
$Comp
L Connector_Generic:Conn_02x06_Top_Bottom J5
U 1 1 5C7DA814
P 10200 2700
F 0 "J5" H 10250 3117 50  0000 C CNN
F 1 "Conn_02x06_Top_Bottom" H 10250 3026 50  0000 C CNN
F 2 "footprints:PinSocket_2x06_P2.54mm_Horizontal" H 10200 2700 50  0001 C CNN
F 3 "~" H 10200 2700 50  0001 C CNN
	1    10200 2700
	1    0    0    -1
$EndComp
$Comp
L Mechanical:MountingHole_Pad H1
U 1 1 5C7E0D89
P 6050 6650
F 0 "H1" H 6150 6701 50  0000 L CNN
F 1 "MountingHole_Pad" H 6150 6610 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_Pad" H 6050 6650 50  0001 C CNN
F 3 "~" H 6050 6650 50  0001 C CNN
	1    6050 6650
	1    0    0    -1
$EndComp
$Comp
L Mechanical:MountingHole_Pad H2
U 1 1 5C7E0E55
P 6050 6950
F 0 "H2" H 6150 7001 50  0000 L CNN
F 1 "MountingHole_Pad" H 6150 6910 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_Pad" H 6050 6950 50  0001 C CNN
F 3 "~" H 6050 6950 50  0001 C CNN
	1    6050 6950
	1    0    0    -1
$EndComp
$Comp
L Mechanical:MountingHole_Pad H3
U 1 1 5C7E0EBD
P 6050 7250
F 0 "H3" H 6150 7301 50  0000 L CNN
F 1 "MountingHole_Pad" H 6150 7210 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_Pad" H 6050 7250 50  0001 C CNN
F 3 "~" H 6050 7250 50  0001 C CNN
	1    6050 7250
	1    0    0    -1
$EndComp
$Comp
L Mechanical:MountingHole_Pad H4
U 1 1 5C7E0F27
P 6050 7550
F 0 "H4" H 6150 7601 50  0000 L CNN
F 1 "MountingHole_Pad" H 6150 7510 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_Pad" H 6050 7550 50  0001 C CNN
F 3 "~" H 6050 7550 50  0001 C CNN
	1    6050 7550
	1    0    0    -1
$EndComp
NoConn ~ 6050 6750
NoConn ~ 6050 7050
NoConn ~ 6050 7350
NoConn ~ 6050 7650
$Comp
L Device:R R7
U 1 1 5C793D39
P 5400 4350
F 0 "R7" H 5470 4396 50  0000 L CNN
F 1 "10K" H 5470 4305 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 5330 4350 50  0001 C CNN
F 3 "~" H 5400 4350 50  0001 C CNN
	1    5400 4350
	1    0    0    -1
$EndComp
$Comp
L power:+3.3V #PWR020
U 1 1 5C793DF9
P 5400 4150
F 0 "#PWR020" H 5400 4000 50  0001 C CNN
F 1 "+3.3V" H 5415 4323 50  0000 C CNN
F 2 "" H 5400 4150 50  0001 C CNN
F 3 "" H 5400 4150 50  0001 C CNN
	1    5400 4150
	1    0    0    -1
$EndComp
Wire Wire Line
	5000 4550 5400 4550
Wire Wire Line
	5400 4550 5400 4500
Wire Wire Line
	5400 4200 5400 4150
$Comp
L Connector:Conn_01x02_Male J8
U 1 1 5C7994A0
P 1750 4200
F 0 "J8" H 1600 4200 50  0000 C CNN
F 1 "Conn_01x02_Male" H 1400 4100 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 1750 4200 50  0001 C CNN
F 3 "~" H 1750 4200 50  0001 C CNN
	1    1750 4200
	-1   0    0    -1
$EndComp
Wire Wire Line
	1550 4050 1550 4200
Wire Wire Line
	1550 6850 1550 6700
$Comp
L Connector:Conn_01x02_Male J9
U 1 1 5C7A1AAB
P 1750 6600
F 0 "J9" H 1600 6600 50  0000 C CNN
F 1 "Conn_01x02_Male" H 1400 6500 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 1750 6600 50  0001 C CNN
F 3 "~" H 1750 6600 50  0001 C CNN
	1    1750 6600
	-1   0    0    -1
$EndComp
Wire Wire Line
	1550 6450 1550 6600
$Comp
L Switch:SW_Push SW1
U 1 1 5C7C4C64
P 9250 3100
F 0 "SW1" H 9250 3385 50  0000 C CNN
F 1 "SW_Push" H 9250 3294 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm_H5mm" H 9250 3300 50  0001 C CNN
F 3 "" H 9250 3300 50  0001 C CNN
	1    9250 3100
	1    0    0    -1
$EndComp
$Comp
L Switch:SW_Push SW2
U 1 1 5C7C4D3E
P 9250 3600
F 0 "SW2" H 9250 3885 50  0000 C CNN
F 1 "SW_Push" H 9250 3794 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm_H5mm" H 9250 3800 50  0001 C CNN
F 3 "" H 9250 3800 50  0001 C CNN
	1    9250 3600
	1    0    0    -1
$EndComp
Text Label 8750 3100 2    50   ~ 0
PMOD1_6
Text Label 8750 3600 2    50   ~ 0
PMOD1_7
Wire Wire Line
	9450 3100 9450 3600
$Comp
L power:GND #PWR021
U 1 1 5C7C7AF9
P 9450 3700
F 0 "#PWR021" H 9450 3450 50  0001 C CNN
F 1 "GND" H 9455 3527 50  0000 C CNN
F 2 "" H 9450 3700 50  0001 C CNN
F 3 "" H 9450 3700 50  0001 C CNN
	1    9450 3700
	1    0    0    -1
$EndComp
Wire Wire Line
	9450 3600 9450 3700
Connection ~ 9450 3600
$Comp
L Device:R R8
U 1 1 5C7D1F77
P 8900 3100
F 0 "R8" V 9100 3100 50  0000 L CNN
F 1 "1K0" V 9000 3050 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 8830 3100 50  0001 C CNN
F 3 "~" H 8900 3100 50  0001 C CNN
	1    8900 3100
	0    -1   -1   0
$EndComp
$Comp
L Device:R R9
U 1 1 5C7D51EB
P 8900 3600
F 0 "R9" V 9100 3600 50  0000 L CNN
F 1 "1K0" V 9000 3550 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 8830 3600 50  0001 C CNN
F 3 "~" H 8900 3600 50  0001 C CNN
	1    8900 3600
	0    -1   -1   0
$EndComp
$EndSCHEMATC
