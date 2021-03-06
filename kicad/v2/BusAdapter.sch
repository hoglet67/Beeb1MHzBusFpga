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
P 4500 1600
F 0 "U1" H 4850 2400 50  0000 C CNN
F 1 "74LVC245" H 4850 2300 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket" H 4500 1600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS245" H 4500 1600 50  0001 C CNN
	1    4500 1600
	-1   0    0    -1  
$EndComp
$Comp
L 74xx:74LS245 U2
U 1 1 5C75192C
P 4500 3700
F 0 "U2" H 4800 4500 50  0000 C CNN
F 1 "74LVC245" H 4800 4400 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket" H 4500 3700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS245" H 4500 3700 50  0001 C CNN
	1    4500 3700
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
F 2 "footprints:IDC-Header_2x17_P2.54mm_Horizontal_Lock" H 1500 1950 50  0001 C CNN
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
P 4500 5800
F 0 "U3" H 4800 6600 50  0000 C CNN
F 1 "74LVC245" H 4800 6500 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket" H 4500 5800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS245" H 4500 5800 50  0001 C CNN
	1    4500 5800
	-1   0    0    -1  
$EndComp
Text Label 4000 1800 2    50   ~ 0
A7
Text Label 4000 1700 2    50   ~ 0
A6
Text Label 4000 1600 2    50   ~ 0
A5
Text Label 4000 1500 2    50   ~ 0
A4
Text Label 4000 1400 2    50   ~ 0
A3
Text Label 4000 1300 2    50   ~ 0
A2
Text Label 4000 1200 2    50   ~ 0
A1
Text Label 4000 1100 2    50   ~ 0
A0
Text Label 5000 1100 0    50   ~ 0
LV_A0
Text Label 5000 1200 0    50   ~ 0
LV_A1
Text Label 5000 1300 0    50   ~ 0
LV_A2
Text Label 5000 1400 0    50   ~ 0
LV_A3
Text Label 5000 1500 0    50   ~ 0
LV_A4
Text Label 5000 1600 0    50   ~ 0
LV_A5
Text Label 5000 1700 0    50   ~ 0
LV_A6
Text Label 5000 1800 0    50   ~ 0
LV_A7
Text Label 5000 3200 0    50   ~ 0
LV_D0
Text Label 5000 3300 0    50   ~ 0
LV_D1
Text Label 5000 3400 0    50   ~ 0
LV_D2
Text Label 5000 3500 0    50   ~ 0
LV_D3
Text Label 5000 3600 0    50   ~ 0
LV_D4
Text Label 5000 3700 0    50   ~ 0
LV_D5
Text Label 5000 3800 0    50   ~ 0
LV_D6
Text Label 5000 3900 0    50   ~ 0
LV_D7
Text Label 4000 3200 2    50   ~ 0
D0
Text Label 4000 3300 2    50   ~ 0
D1
Text Label 4000 3400 2    50   ~ 0
D2
Text Label 4000 3500 2    50   ~ 0
D3
Text Label 4000 3600 2    50   ~ 0
D4
Text Label 4000 3700 2    50   ~ 0
D5
Text Label 4000 3800 2    50   ~ 0
D6
Text Label 4000 3900 2    50   ~ 0
D7
Text Label 5000 4100 0    50   ~ 0
LV_DIR
Text Label 5000 4200 0    50   ~ 0
LV_OEL
Text Label 5000 5300 0    50   ~ 0
LV_RnW
Text Label 5000 5400 0    50   ~ 0
LV_1MHZE
Text Label 5000 5700 0    50   ~ 0
LV_NPGFC
Text Label 5000 5800 0    50   ~ 0
LV_NPGFD
Text Label 5000 5900 0    50   ~ 0
LV_NRST
Text Label 4000 5300 2    50   ~ 0
RnW
Text Label 4000 5400 2    50   ~ 0
1MHZE
Text Label 4000 5700 2    50   ~ 0
NPGFC
Text Label 4000 5800 2    50   ~ 0
NPGFD
NoConn ~ 5000 5500
NoConn ~ 5000 6000
NoConn ~ 5000 5600
$Comp
L Transistor_BJT:2N3904 Q2
U 1 1 5C7536E9
P 1350 5700
F 0 "Q2" H 1541 5746 50  0000 L CNN
F 1 "2N3904" H 1541 5655 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_HandSolder" H 1550 5625 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N3904.pdf" H 1350 5700 50  0001 L CNN
	1    1350 5700
	1    0    0    -1  
$EndComp
Text Label 1450 5100 0    50   ~ 0
NNMI
$Comp
L Device:R R4
U 1 1 5C753A2A
P 1100 5900
F 0 "R4" H 1170 5946 50  0000 L CNN
F 1 "1K0" H 1170 5855 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 1030 5900 50  0001 C CNN
F 3 "~" H 1100 5900 50  0001 C CNN
	1    1100 5900
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5C753AB4
P 900 5700
F 0 "R2" V 693 5700 50  0000 C CNN
F 1 "1K0" V 784 5700 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 830 5700 50  0001 C CNN
F 3 "~" H 900 5700 50  0001 C CNN
	1    900  5700
	0    1    1    0   
$EndComp
Wire Wire Line
	1050 5700 1100 5700
Wire Wire Line
	1100 5750 1100 5700
Connection ~ 1100 5700
Wire Wire Line
	1100 5700 1150 5700
Wire Wire Line
	1100 6050 1100 6150
Wire Wire Line
	1100 6150 1450 6150
Wire Wire Line
	1450 6150 1450 5900
$Comp
L power:GND #PWR09
U 1 1 5C754305
P 4500 6600
F 0 "#PWR09" H 4500 6350 50  0001 C CNN
F 1 "GND" H 4505 6427 50  0000 C CNN
F 2 "" H 4500 6600 50  0001 C CNN
F 3 "" H 4500 6600 50  0001 C CNN
	1    4500 6600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR05
U 1 1 5C754F09
P 4500 2400
F 0 "#PWR05" H 4500 2150 50  0001 C CNN
F 1 "GND" H 4505 2227 50  0000 C CNN
F 2 "" H 4500 2400 50  0001 C CNN
F 3 "" H 4500 2400 50  0001 C CNN
	1    4500 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR07
U 1 1 5C754F58
P 4500 4500
F 0 "#PWR07" H 4500 4250 50  0001 C CNN
F 1 "GND" H 4505 4327 50  0000 C CNN
F 2 "" H 4500 4500 50  0001 C CNN
F 3 "" H 4500 4500 50  0001 C CNN
	1    4500 4500
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
P 1450 6150
F 0 "#PWR02" H 1450 5900 50  0001 C CNN
F 1 "GND" H 1455 5977 50  0000 C CNN
F 2 "" H 1450 6150 50  0001 C CNN
F 3 "" H 1450 6150 50  0001 C CNN
	1    1450 6150
	1    0    0    -1  
$EndComp
Connection ~ 1450 6150
Text Label 750  5700 2    50   ~ 0
LV_NMI
$Comp
L Transistor_BJT:2N3904 Q1
U 1 1 5C756046
P 1400 4050
F 0 "Q1" H 1591 4096 50  0000 L CNN
F 1 "2N3904" H 1591 4005 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_HandSolder" H 1600 3975 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N3904.pdf" H 1400 4050 50  0001 L CNN
	1    1400 4050
	1    0    0    -1  
$EndComp
Wire Wire Line
	1500 3850 1500 3700
Text Label 1500 3450 0    50   ~ 0
NIRQ
$Comp
L Device:R R3
U 1 1 5C75604F
P 1150 4250
F 0 "R3" H 1220 4296 50  0000 L CNN
F 1 "1K0" H 1220 4205 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 1080 4250 50  0001 C CNN
F 3 "~" H 1150 4250 50  0001 C CNN
	1    1150 4250
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 5C756055
P 950 4050
F 0 "R1" V 743 4050 50  0000 C CNN
F 1 "1K0" V 834 4050 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 880 4050 50  0001 C CNN
F 3 "~" H 950 4050 50  0001 C CNN
	1    950  4050
	0    1    1    0   
$EndComp
Wire Wire Line
	1100 4050 1150 4050
Wire Wire Line
	1150 4100 1150 4050
Connection ~ 1150 4050
Wire Wire Line
	1150 4050 1200 4050
Wire Wire Line
	1150 4400 1150 4500
Wire Wire Line
	1150 4500 1500 4500
Wire Wire Line
	1500 4500 1500 4250
$Comp
L power:GND #PWR01
U 1 1 5C756062
P 1500 4500
F 0 "#PWR01" H 1500 4250 50  0001 C CNN
F 1 "GND" H 1505 4327 50  0000 C CNN
F 2 "" H 1500 4500 50  0001 C CNN
F 3 "" H 1500 4500 50  0001 C CNN
	1    1500 4500
	1    0    0    -1  
$EndComp
Connection ~ 1500 4500
Text Label 800  4050 2    50   ~ 0
LV_IRQ
Text Label 4000 5900 2    50   ~ 0
NRST
$Comp
L power:+3.3V #PWR08
U 1 1 5C75891B
P 4500 5000
F 0 "#PWR08" H 4500 4850 50  0001 C CNN
F 1 "+3.3V" H 4515 5173 50  0000 C CNN
F 2 "" H 4500 5000 50  0001 C CNN
F 3 "" H 4500 5000 50  0001 C CNN
	1    4500 5000
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR06
U 1 1 5C7589C1
P 4500 2900
F 0 "#PWR06" H 4500 2750 50  0001 C CNN
F 1 "+3.3V" H 4515 3073 50  0000 C CNN
F 2 "" H 4500 2900 50  0001 C CNN
F 3 "" H 4500 2900 50  0001 C CNN
	1    4500 2900
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR04
U 1 1 5C758A97
P 4500 800
F 0 "#PWR04" H 4500 650 50  0001 C CNN
F 1 "+3.3V" H 4515 973 50  0000 C CNN
F 2 "" H 4500 800 50  0001 C CNN
F 3 "" H 4500 800 50  0001 C CNN
	1    4500 800 
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
RAMA18
Text Label 6500 1250 0    50   ~ 0
RAMA17
Text Label 6500 1350 0    50   ~ 0
RAMA16
Text Label 6500 1450 0    50   ~ 0
RAMA15
Text Label 6500 1550 0    50   ~ 0
RAMOEL
Text Label 6500 1750 0    50   ~ 0
RAMD7
Text Label 6500 1850 0    50   ~ 0
RAMD6
Text Label 6500 1950 0    50   ~ 0
RAMD5
Text Label 6500 2050 0    50   ~ 0
RAMD4
Text Label 7550 2950 2    50   ~ 0
LV_1MHZE
Text Label 6500 2250 0    50   ~ 0
RAMA13
Text Label 6500 2350 0    50   ~ 0
RAMA12
Text Label 6500 2450 0    50   ~ 0
RAMA11
Text Label 6500 2650 0    50   ~ 0
RAMA10
Text Label 6500 2150 0    50   ~ 0
RAMA14
Text Label 7550 1150 2    50   ~ 0
RAMA0
Text Label 7550 1250 2    50   ~ 0
RAMA1
Text Label 7550 1350 2    50   ~ 0
RAMA2
Text Label 7550 1450 2    50   ~ 0
RAMA3
Text Label 7550 1550 2    50   ~ 0
RAMA4
Text Label 7550 1750 2    50   ~ 0
RAMCEL
Text Label 7550 1850 2    50   ~ 0
RAMD0
Text Label 7550 1950 2    50   ~ 0
RAMD1
Text Label 7550 2050 2    50   ~ 0
RAMD2
Text Label 7550 2150 2    50   ~ 0
RAMD3
Text Label 7550 2250 2    50   ~ 0
RAMWEL
Text Label 7550 2350 2    50   ~ 0
RAMA5
Text Label 7550 2450 2    50   ~ 0
RAMA6
Text Label 7550 2650 2    50   ~ 0
RAMA7
Text Label 7550 2750 2    50   ~ 0
RAMA8
Text Label 7550 2850 2    50   ~ 0
RAMA9
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
Text Label 10000 2300 2    50   ~ 0
GND
Text Label 10000 2400 2    50   ~ 0
+3V3
Text Label 10500 2300 0    50   ~ 0
GND
Text Label 10500 2400 0    50   ~ 0
+3V3
Text Label 10500 1900 0    50   ~ 0
PMOD1_4
Text Label 10500 2000 0    50   ~ 0
PMOD1_5
Text Label 10500 2100 0    50   ~ 0
PMOD1_6
Text Label 10500 2200 0    50   ~ 0
PMOD1_7
Text Label 10000 2000 2    50   ~ 0
PMOD1_1
Text Label 10000 2100 2    50   ~ 0
PMOD1_2
Text Label 10000 2200 2    50   ~ 0
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
P 1250 7300
F 0 "C2" H 1342 7346 50  0000 L CNN
F 1 "100n" H 1342 7255 50  0000 L CNN
F 2 "Capacitor_THT:C_Axial_L3.8mm_D2.6mm_P10.00mm_Horizontal" H 1250 7300 50  0001 C CNN
F 3 "~" H 1250 7300 50  0001 C CNN
	1    1250 7300
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C3
U 1 1 5C771D25
P 1650 7300
F 0 "C3" H 1742 7346 50  0000 L CNN
F 1 "100n" H 1742 7255 50  0000 L CNN
F 2 "Capacitor_THT:C_Axial_L3.8mm_D2.6mm_P10.00mm_Horizontal" H 1650 7300 50  0001 C CNN
F 3 "~" H 1650 7300 50  0001 C CNN
	1    1650 7300
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C4
U 1 1 5C771D63
P 2050 7300
F 0 "C4" H 2142 7346 50  0000 L CNN
F 1 "100n" H 2142 7255 50  0000 L CNN
F 2 "Capacitor_THT:C_Axial_L3.8mm_D2.6mm_P10.00mm_Horizontal" H 2050 7300 50  0001 C CNN
F 3 "~" H 2050 7300 50  0001 C CNN
	1    2050 7300
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C5
U 1 1 5C771DA7
P 2450 7300
F 0 "C5" H 2542 7346 50  0000 L CNN
F 1 "100n" H 2542 7255 50  0000 L CNN
F 2 "Capacitor_THT:C_Axial_L3.8mm_D2.6mm_P7.50mm_Horizontal" H 2450 7300 50  0001 C CNN
F 3 "~" H 2450 7300 50  0001 C CNN
	1    2450 7300
	1    0    0    -1  
$EndComp
Wire Wire Line
	1250 7400 1250 7450
Wire Wire Line
	1250 7450 1650 7450
Wire Wire Line
	2450 7450 2450 7400
Wire Wire Line
	1650 7400 1650 7450
Connection ~ 1650 7450
Wire Wire Line
	2050 7400 2050 7450
Wire Wire Line
	1250 7200 1250 7150
Wire Wire Line
	1250 7150 1650 7150
Wire Wire Line
	2450 7150 2450 7200
Wire Wire Line
	2050 7200 2050 7150
Wire Wire Line
	1650 7200 1650 7150
Wire Wire Line
	1650 7150 2050 7150
Wire Wire Line
	2050 7450 2450 7450
Wire Wire Line
	2050 7150 2050 7100
Connection ~ 2050 7150
$Comp
L power:+3.3V #PWR010
U 1 1 5C7804D2
P 2050 7100
F 0 "#PWR010" H 2050 6950 50  0001 C CNN
F 1 "+3.3V" H 2065 7273 50  0000 C CNN
F 2 "" H 2050 7100 50  0001 C CNN
F 3 "" H 2050 7100 50  0001 C CNN
	1    2050 7100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR011
U 1 1 5C780534
P 2050 7500
F 0 "#PWR011" H 2050 7250 50  0001 C CNN
F 1 "GND" H 2055 7327 50  0000 C CNN
F 2 "" H 2050 7500 50  0001 C CNN
F 3 "" H 2050 7500 50  0001 C CNN
	1    2050 7500
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5C785A91
P 1250 7150
F 0 "#FLG01" H 1250 7225 50  0001 C CNN
F 1 "PWR_FLAG" H 1250 7324 50  0000 C CNN
F 2 "" H 1250 7150 50  0001 C CNN
F 3 "~" H 1250 7150 50  0001 C CNN
	1    1250 7150
	1    0    0    -1  
$EndComp
Connection ~ 1250 7150
$Comp
L power:PWR_FLAG #FLG02
U 1 1 5C785B38
P 1250 7450
F 0 "#FLG02" H 1250 7525 50  0001 C CNN
F 1 "PWR_FLAG" H 1250 7623 50  0000 C CNN
F 2 "" H 1250 7450 50  0001 C CNN
F 3 "~" H 1250 7450 50  0001 C CNN
	1    1250 7450
	1    0    0    1   
$EndComp
Connection ~ 1250 7450
Text Label 4000 5500 2    50   ~ 0
GND
Text Label 4000 5600 2    50   ~ 0
GND
Text Label 4000 6000 2    50   ~ 0
GND
Text Label 5000 6200 0    50   ~ 0
GND
Text Label 5000 6300 0    50   ~ 0
GND
Text Label 5000 2000 0    50   ~ 0
GND
Text Label 5000 2100 0    50   ~ 0
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
P 9350 5400
F 0 "U5" H 8950 5900 50  0000 C CNN
F 1 "MCP4822" H 8950 5800 50  0000 C CNN
F 2 "Package_DIP:DIP-8_W7.62mm_Socket" H 10150 5100 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/20002249B.pdf" H 10150 5100 50  0001 C CNN
	1    9350 5400
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR014
U 1 1 5C78BC0F
P 9350 5000
F 0 "#PWR014" H 9350 4850 50  0001 C CNN
F 1 "+3.3V" H 9365 5173 50  0000 C CNN
F 2 "" H 9350 5000 50  0001 C CNN
F 3 "" H 9350 5000 50  0001 C CNN
	1    9350 5000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR015
U 1 1 5C78BC88
P 9350 5900
F 0 "#PWR015" H 9350 5650 50  0001 C CNN
F 1 "GND" H 9355 5727 50  0000 C CNN
F 2 "" H 9350 5900 50  0001 C CNN
F 3 "" H 9350 5900 50  0001 C CNN
	1    9350 5900
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_Coaxial J6
U 1 1 5C78C10F
P 10400 5100
F 0 "J6" H 10499 5076 50  0000 L CNN
F 1 "Conn_Coaxial" H 10499 4985 50  0000 L CNN
F 2 "footprints:phono" H 10400 5100 50  0001 C CNN
F 3 " ~" H 10400 5100 50  0001 C CNN
	1    10400 5100
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_Coaxial J7
U 1 1 5C78C1DA
P 10400 5800
F 0 "J7" H 10499 5776 50  0000 L CNN
F 1 "Conn_Coaxial" H 10499 5685 50  0000 L CNN
F 2 "footprints:phono" H 10400 5800 50  0001 C CNN
F 3 " ~" H 10400 5800 50  0001 C CNN
	1    10400 5800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR016
U 1 1 5C78C31A
P 10400 5300
F 0 "#PWR016" H 10400 5050 50  0001 C CNN
F 1 "GND" H 10405 5127 50  0000 C CNN
F 2 "" H 10400 5300 50  0001 C CNN
F 3 "" H 10400 5300 50  0001 C CNN
	1    10400 5300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR017
U 1 1 5C78C351
P 10400 6000
F 0 "#PWR017" H 10400 5750 50  0001 C CNN
F 1 "GND" H 10405 5827 50  0000 C CNN
F 2 "" H 10400 6000 50  0001 C CNN
F 3 "" H 10400 6000 50  0001 C CNN
	1    10400 6000
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C7
U 1 1 5C78C6F9
P 10000 5100
F 0 "C7" V 9771 5100 50  0000 C CNN
F 1 "1u" V 9862 5100 50  0000 C CNN
F 2 "Capacitor_THT:C_Rect_L7.2mm_W5.5mm_P5.00mm_FKS2_FKP2_MKS2_MKP2" H 10000 5100 50  0001 C CNN
F 3 "~" H 10000 5100 50  0001 C CNN
	1    10000 5100
	0    1    1    0   
$EndComp
$Comp
L Device:C_Small C8
U 1 1 5C78C83C
P 10000 5800
F 0 "C8" V 9771 5800 50  0000 C CNN
F 1 "1u" V 9862 5800 50  0000 C CNN
F 2 "Capacitor_THT:C_Rect_L7.2mm_W5.5mm_P5.00mm_FKS2_FKP2_MKS2_MKP2" H 10000 5800 50  0001 C CNN
F 3 "~" H 10000 5800 50  0001 C CNN
	1    10000 5800
	0    1    1    0   
$EndComp
Wire Wire Line
	10100 5100 10200 5100
Wire Wire Line
	10100 5800 10200 5800
Wire Wire Line
	9850 5300 9850 5100
Wire Wire Line
	9850 5100 9900 5100
Wire Wire Line
	9850 5600 9850 5800
Wire Wire Line
	9850 5800 9900 5800
Connection ~ 2050 7450
$Comp
L Device:C_Small C1
U 1 1 5C798365
P 800 7300
F 0 "C1" H 892 7346 50  0000 L CNN
F 1 "100n" H 892 7255 50  0000 L CNN
F 2 "Capacitor_THT:C_Axial_L3.8mm_D2.6mm_P10.00mm_Horizontal" H 800 7300 50  0001 C CNN
F 3 "~" H 800 7300 50  0001 C CNN
	1    800  7300
	1    0    0    -1  
$EndComp
Wire Wire Line
	2850 7450 2850 7400
Wire Wire Line
	2450 7450 2850 7450
Connection ~ 2450 7150
Connection ~ 2450 7450
Wire Wire Line
	2050 7150 2450 7150
Connection ~ 1650 7150
Wire Wire Line
	2050 7500 2050 7450
Wire Wire Line
	1650 7450 2050 7450
NoConn ~ 1200 2050
$Comp
L Device:CP_Small C9
U 1 1 5C7A0AD1
P 3250 7300
F 0 "C9" H 3338 7346 50  0000 L CNN
F 1 "10u" H 3338 7255 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.50mm" H 3250 7300 50  0001 C CNN
F 3 "~" H 3250 7300 50  0001 C CNN
	1    3250 7300
	1    0    0    -1  
$EndComp
Wire Wire Line
	1250 7150 800  7150
Wire Wire Line
	800  7150 800  7200
Wire Wire Line
	1250 7450 800  7450
Wire Wire Line
	800  7450 800  7400
$Comp
L Device:R_Network08 RN6
U 1 1 5C7B918C
P 3400 1500
F 0 "RN6" V 2783 1500 50  0000 C CNN
F 1 "2K2" V 2874 1500 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP9" V 3875 1500 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 3400 1500 50  0001 C CNN
	1    3400 1500
	0    1    1    0   
$EndComp
$Comp
L Device:R_Network08 RN3
U 1 1 5C7D5DAA
P 2800 1500
F 0 "RN3" V 2183 1500 50  0000 C CNN
F 1 "2K2" V 2274 1500 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP9" V 3275 1500 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 2800 1500 50  0001 C CNN
	1    2800 1500
	0    -1   1    0   
$EndComp
Wire Wire Line
	3000 1100 3200 1100
Wire Wire Line
	3000 1200 3200 1200
Wire Wire Line
	3000 1300 3200 1300
Wire Wire Line
	3000 1400 3200 1400
Wire Wire Line
	3000 1500 3200 1500
Wire Wire Line
	3000 1600 3200 1600
Wire Wire Line
	3000 1700 3200 1700
Wire Wire Line
	3000 1800 3200 1800
Text Label 2600 1100 2    50   ~ 0
GND
Text Label 3600 1100 0    50   ~ 0
+3V3
Text Label 3150 1100 2    50   ~ 0
A0
Text Label 3150 1200 2    50   ~ 0
A1
Text Label 3150 1300 2    50   ~ 0
A2
Text Label 3150 1400 2    50   ~ 0
A3
Text Label 3150 1500 2    50   ~ 0
A4
Text Label 3150 1600 2    50   ~ 0
A5
Text Label 3150 1700 2    50   ~ 0
A6
Text Label 3150 1800 2    50   ~ 0
A7
$Comp
L Device:R_Network08 RN5
U 1 1 5C7EC7D7
P 3350 3600
F 0 "RN5" V 2733 3600 50  0000 C CNN
F 1 "2K2" V 2824 3600 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP9" V 3825 3600 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 3350 3600 50  0001 C CNN
	1    3350 3600
	0    1    1    0   
$EndComp
$Comp
L Device:R_Network08 RN2
U 1 1 5C7EC7DD
P 2750 3600
F 0 "RN2" V 2133 3600 50  0000 C CNN
F 1 "2K2" V 2224 3600 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP9" V 3225 3600 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 2750 3600 50  0001 C CNN
	1    2750 3600
	0    -1   1    0   
$EndComp
Wire Wire Line
	2950 3200 3150 3200
Wire Wire Line
	2950 3300 3150 3300
Wire Wire Line
	2950 3400 3150 3400
Wire Wire Line
	2950 3500 3150 3500
Wire Wire Line
	2950 3600 3150 3600
Wire Wire Line
	2950 3700 3150 3700
Wire Wire Line
	2950 3800 3150 3800
Wire Wire Line
	2950 3900 3150 3900
Text Label 2550 3200 2    50   ~ 0
GND
Text Label 3550 3200 0    50   ~ 0
+3V3
Text Label 3100 3200 2    50   ~ 0
D0
Text Label 3100 3300 2    50   ~ 0
D1
Text Label 3100 3400 2    50   ~ 0
D2
Text Label 3100 3500 2    50   ~ 0
D3
Text Label 3100 3600 2    50   ~ 0
D4
Text Label 3100 3700 2    50   ~ 0
D5
Text Label 3100 3800 2    50   ~ 0
D6
Text Label 3100 3900 2    50   ~ 0
D7
$Comp
L Device:R_Network08 RN4
U 1 1 5C7F9A02
P 3350 5700
F 0 "RN4" V 2733 5700 50  0000 C CNN
F 1 "2K2" V 2824 5700 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP9" V 3825 5700 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 3350 5700 50  0001 C CNN
	1    3350 5700
	0    1    1    0   
$EndComp
$Comp
L Device:R_Network08 RN1
U 1 1 5C7F9A08
P 2750 5700
F 0 "RN1" V 2133 5700 50  0000 C CNN
F 1 "2K2" V 2224 5700 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP9" V 3225 5700 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 2750 5700 50  0001 C CNN
	1    2750 5700
	0    -1   1    0   
$EndComp
Text Label 2550 5300 2    50   ~ 0
GND
Text Label 3550 5300 0    50   ~ 0
+3V3
Wire Wire Line
	2950 5300 3150 5300
Wire Wire Line
	2950 5400 3150 5400
Wire Wire Line
	2950 5700 3150 5700
Wire Wire Line
	2950 5800 3150 5800
NoConn ~ 2950 5500
NoConn ~ 2950 5600
NoConn ~ 2950 5900
NoConn ~ 2950 6000
NoConn ~ 3150 6000
NoConn ~ 3150 5900
NoConn ~ 3150 5600
NoConn ~ 3150 5500
Text Label 3150 5300 2    50   ~ 0
RnW
Text Label 3150 5400 2    50   ~ 0
1MHZE
Text Label 3150 5700 2    50   ~ 0
NPGFC
Text Label 3150 5800 2    50   ~ 0
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
F 1 "Green LED" V 9097 1233 50  0000 R CNN
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
Text Label 10000 1900 2    50   ~ 0
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
F 1 "Red LED" V 9097 1983 50  0000 R CNN
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
P 10200 2100
F 0 "J5" H 10250 2517 50  0000 C CNN
F 1 "Conn_02x06_Top_Bottom" H 10250 2426 50  0000 C CNN
F 2 "footprints:PinSocket_2x06_P2.54mm_Horizontal" H 10200 2100 50  0001 C CNN
F 3 "~" H 10200 2100 50  0001 C CNN
	1    10200 2100
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
P 5400 4000
F 0 "R7" H 5470 4046 50  0000 L CNN
F 1 "10K" H 5470 3955 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 5330 4000 50  0001 C CNN
F 3 "~" H 5400 4000 50  0001 C CNN
	1    5400 4000
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR020
U 1 1 5C793DF9
P 5400 3800
F 0 "#PWR020" H 5400 3650 50  0001 C CNN
F 1 "+3.3V" H 5415 3973 50  0000 C CNN
F 2 "" H 5400 3800 50  0001 C CNN
F 3 "" H 5400 3800 50  0001 C CNN
	1    5400 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 4200 5400 4200
Wire Wire Line
	5400 4200 5400 4150
Wire Wire Line
	5400 3850 5400 3800
$Comp
L Connector:Conn_01x02_Male J8
U 1 1 5C7994A0
P 1700 3600
F 0 "J8" H 1550 3600 50  0000 C CNN
F 1 "Conn_01x02_Male" H 1350 3500 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 1700 3600 50  0001 C CNN
F 3 "~" H 1700 3600 50  0001 C CNN
	1    1700 3600
	-1   0    0    -1  
$EndComp
Wire Wire Line
	1500 3450 1500 3600
Wire Wire Line
	1450 5500 1450 5350
$Comp
L Connector:Conn_01x02_Male J9
U 1 1 5C7A1AAB
P 1650 5250
F 0 "J9" H 1500 5250 50  0000 C CNN
F 1 "Conn_01x02_Male" H 1300 5150 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 1650 5250 50  0001 C CNN
F 3 "~" H 1650 5250 50  0001 C CNN
	1    1650 5250
	-1   0    0    -1  
$EndComp
Wire Wire Line
	1450 5100 1450 5250
$Comp
L Switch:SW_Push SW1
U 1 1 5C7C4C64
P 7700 4950
F 0 "SW1" H 7700 5235 50  0000 C CNN
F 1 "SW_Push" H 7700 5144 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm_H5mm" H 7700 5150 50  0001 C CNN
F 3 "" H 7700 5150 50  0001 C CNN
	1    7700 4950
	0    -1   -1   0   
$EndComp
$Comp
L Switch:SW_Push SW2
U 1 1 5C7C4D3E
P 8100 4950
F 0 "SW2" H 8100 5235 50  0000 C CNN
F 1 "SW_Push" H 8100 5144 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm_H5mm" H 8100 5150 50  0001 C CNN
F 3 "" H 8100 5150 50  0001 C CNN
	1    8100 4950
	0    -1   -1   0   
$EndComp
Text Label 8100 5600 0    50   ~ 0
SW2
$Comp
L Device:R R8
U 1 1 5C7D1F77
P 7700 5400
F 0 "R8" V 7900 5400 50  0000 L CNN
F 1 "100R" V 7800 5350 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 7630 5400 50  0001 C CNN
F 3 "~" H 7700 5400 50  0001 C CNN
	1    7700 5400
	1    0    0    -1  
$EndComp
$Comp
L Device:R R9
U 1 1 5C7D51EB
P 8100 5400
F 0 "R9" V 8300 5400 50  0000 L CNN
F 1 "100R" V 8200 5350 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 8030 5400 50  0001 C CNN
F 3 "~" H 8100 5400 50  0001 C CNN
	1    8100 5400
	1    0    0    -1  
$EndComp
$Comp
L Memory_RAM:IS61C5128AL-10TLI U4
U 1 1 5CA12889
P 6700 4950
F 0 "U4" H 6200 6350 50  0000 C CNN
F 1 "IS61WV5128BLL-10TLI" H 6200 6250 50  0000 C CNN
F 2 "footprints:TSOP-II-44_10.16x18.41mm_P0.8mm" H 6200 6100 50  0001 C CNN
F 3 "http://www.issi.com/WW/pdf/61-64C5128AL.pdf" H 6700 4950 50  0001 C CNN
	1    6700 4950
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x06_Odd_Even J10
U 1 1 5CA1784D
P 8500 3950
F 0 "J10" H 8550 4367 50  0000 C CNN
F 1 "Conn_02x06_Odd_Even" H 8550 4276 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x06_P2.54mm_Vertical" H 8500 3950 50  0001 C CNN
F 3 "~" H 8500 3950 50  0001 C CNN
	1    8500 3950
	-1   0    0    -1  
$EndComp
Text Label 8200 4250 2    50   ~ 0
GND
Text Label 8700 4250 0    50   ~ 0
+3V3
Text Label 8200 4150 2    50   ~ 0
SW1
Text Label 8700 4150 0    50   ~ 0
SW2
$Comp
L Connector_Generic:Conn_02x02_Odd_Even J11
U 1 1 5CA3DF80
P 10150 4400
F 0 "J11" H 10200 4617 50  0000 C CNN
F 1 "Conn_02x02_Odd_Even" H 10200 4526 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x02_P2.54mm_Vertical" H 10150 4400 50  0001 C CNN
F 3 "~" H 10150 4400 50  0001 C CNN
	1    10150 4400
	-1   0    0    -1  
$EndComp
Text Label 9850 4500 2    50   ~ 0
PMOD1_6
Text Label 9850 4400 2    50   ~ 0
PMOD1_7
$Comp
L power:GND #PWR023
U 1 1 5CA3E395
P 10400 4700
F 0 "#PWR023" H 10400 4450 50  0001 C CNN
F 1 "GND" H 10405 4527 50  0000 C CNN
F 2 "" H 10400 4700 50  0001 C CNN
F 3 "" H 10400 4700 50  0001 C CNN
	1    10400 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	10400 4700 10400 4500
Wire Wire Line
	10400 4400 10350 4400
Wire Wire Line
	10350 4500 10400 4500
Connection ~ 10400 4500
Wire Wire Line
	10400 4500 10400 4400
Text Label 10000 3350 2    50   ~ 0
GND
Text Label 10000 3450 2    50   ~ 0
+3V3
Text Label 10500 3350 0    50   ~ 0
GND
Text Label 10500 3450 0    50   ~ 0
+3V3
Text Label 10500 2950 0    50   ~ 0
PMOD2_4
Text Label 10500 3050 0    50   ~ 0
PMOD2_5
Text Label 10500 3150 0    50   ~ 0
PMOD2_6
Text Label 10500 3250 0    50   ~ 0
PMOD2_7
Text Label 10000 3050 2    50   ~ 0
PMOD2_1
Text Label 10000 3150 2    50   ~ 0
PMOD2_2
Text Label 10000 3250 2    50   ~ 0
PMOD2_3
Text Label 10000 2950 2    50   ~ 0
PMOD2_0
$Comp
L Connector_Generic:Conn_02x06_Top_Bottom J12
U 1 1 5CA59D08
P 10200 3150
F 0 "J12" H 10250 3567 50  0000 C CNN
F 1 "Conn_02x06_Top_Bottom" H 10250 3476 50  0000 C CNN
F 2 "footprints:PinSocket_2x06_P2.54mm_Horizontal" H 10200 3150 50  0001 C CNN
F 3 "~" H 10200 3150 50  0001 C CNN
	1    10200 3150
	1    0    0    -1  
$EndComp
Text Label 8200 4050 2    50   ~ 0
PMOD2_4
Text Label 8200 3950 2    50   ~ 0
PMOD2_5
Text Label 8200 3850 2    50   ~ 0
PMOD2_6
Text Label 8200 3750 2    50   ~ 0
PMOD2_7
Text Label 8700 4050 0    50   ~ 0
PMOD2_0
Text Label 8700 3950 0    50   ~ 0
PMOD2_1
Text Label 8700 3850 0    50   ~ 0
PMOD2_2
Text Label 8700 3750 0    50   ~ 0
PMOD2_3
Text Label 8850 5600 2    50   ~ 0
PMOD2_4
Text Label 8850 5300 2    50   ~ 0
PMOD2_5
Text Label 8850 5500 2    50   ~ 0
PMOD2_6
Text Label 8850 5400 2    50   ~ 0
PMOD2_7
Wire Wire Line
	8100 5150 8100 5250
Text Label 7700 5600 2    50   ~ 0
SW1
Wire Wire Line
	7700 5150 7700 5250
$Comp
L Device:R R10
U 1 1 5CA628B7
P 7700 5800
F 0 "R10" V 7900 5800 50  0000 L CNN
F 1 "1K" V 7800 5750 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 7630 5800 50  0001 C CNN
F 3 "~" H 7700 5800 50  0001 C CNN
	1    7700 5800
	1    0    0    -1  
$EndComp
$Comp
L Device:R R11
U 1 1 5CA629EB
P 8100 5800
F 0 "R11" V 8300 5800 50  0000 L CNN
F 1 "1K" V 8200 5750 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 8030 5800 50  0001 C CNN
F 3 "~" H 8100 5800 50  0001 C CNN
	1    8100 5800
	1    0    0    -1  
$EndComp
Wire Wire Line
	7700 5550 7700 5650
Wire Wire Line
	8100 5550 8100 5650
Wire Wire Line
	7700 5950 7900 5950
Wire Wire Line
	8100 4750 7900 4750
$Comp
L power:+3.3V #PWR021
U 1 1 5CA6DACB
P 7900 4750
F 0 "#PWR021" H 7900 4600 50  0001 C CNN
F 1 "+3.3V" H 7915 4923 50  0000 C CNN
F 2 "" H 7900 4750 50  0001 C CNN
F 3 "" H 7900 4750 50  0001 C CNN
	1    7900 4750
	1    0    0    -1  
$EndComp
Connection ~ 7900 4750
Wire Wire Line
	7900 4750 7700 4750
$Comp
L power:GND #PWR022
U 1 1 5CA6DB40
P 7900 5950
F 0 "#PWR022" H 7900 5700 50  0001 C CNN
F 1 "GND" H 7905 5777 50  0000 C CNN
F 2 "" H 7900 5950 50  0001 C CNN
F 3 "" H 7900 5950 50  0001 C CNN
	1    7900 5950
	1    0    0    -1  
$EndComp
Connection ~ 7900 5950
Wire Wire Line
	7900 5950 8100 5950
$Comp
L Device:C_Small C6
U 1 1 5CA6EEE6
P 2850 7300
F 0 "C6" H 2942 7346 50  0000 L CNN
F 1 "100n" H 2942 7255 50  0000 L CNN
F 2 "Capacitor_THT:C_Axial_L3.8mm_D2.6mm_P7.50mm_Horizontal" H 2850 7300 50  0001 C CNN
F 3 "~" H 2850 7300 50  0001 C CNN
	1    2850 7300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3250 7150 3250 7200
Wire Wire Line
	2850 7150 3250 7150
Wire Wire Line
	2450 7150 2850 7150
Connection ~ 2850 7150
Wire Wire Line
	2850 7150 2850 7200
Wire Wire Line
	2850 7450 3250 7450
Wire Wire Line
	3250 7450 3250 7400
Connection ~ 2850 7450
$Comp
L power:GND #PWR025
U 1 1 5CA423EC
P 4350 7400
F 0 "#PWR025" H 4350 7150 50  0001 C CNN
F 1 "GND" H 4355 7227 50  0000 C CNN
F 2 "" H 4350 7400 50  0001 C CNN
F 3 "" H 4350 7400 50  0001 C CNN
	1    4350 7400
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x02 J14
U 1 1 5CA424D4
P 4900 7200
F 0 "J14" H 4850 7350 50  0000 L CNN
F 1 "Conn_01x02" H 4700 7000 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x02_P2.54mm_Vertical" H 4900 7200 50  0001 C CNN
F 3 "~" H 4900 7200 50  0001 C CNN
	1    4900 7200
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x03 J13
U 1 1 5CA425D5
P 3950 7200
F 0 "J13" H 3950 7450 50  0000 C CNN
F 1 "Conn_01x03" H 4000 7000 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 3950 7200 50  0001 C CNN
F 3 "~" H 3950 7200 50  0001 C CNN
	1    3950 7200
	-1   0    0    -1  
$EndComp
Wire Wire Line
	4150 7200 4350 7200
Wire Wire Line
	4150 7300 4250 7300
Wire Wire Line
	4150 7100 4250 7100
Wire Wire Line
	4250 7100 4250 7300
Connection ~ 4250 7300
Wire Wire Line
	4250 7300 4350 7300
$Comp
L power:+5V #PWR024
U 1 1 5CA501C4
P 4350 7050
F 0 "#PWR024" H 4350 6900 50  0001 C CNN
F 1 "+5V" H 4365 7223 50  0000 C CNN
F 2 "" H 4350 7050 50  0001 C CNN
F 3 "" H 4350 7050 50  0001 C CNN
	1    4350 7050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4350 7050 4350 7200
Connection ~ 4350 7200
Wire Wire Line
	4350 7200 4700 7200
Wire Wire Line
	4350 7300 4350 7400
Connection ~ 4350 7300
Wire Wire Line
	4350 7300 4700 7300
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 5CA5B06B
P 4700 7050
F 0 "#FLG0101" H 4700 7125 50  0001 C CNN
F 1 "PWR_FLAG" H 4700 7224 50  0000 C CNN
F 2 "" H 4700 7050 50  0001 C CNN
F 3 "~" H 4700 7050 50  0001 C CNN
	1    4700 7050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4700 7050 4700 7200
Connection ~ 4700 7200
$EndSCHEMATC
