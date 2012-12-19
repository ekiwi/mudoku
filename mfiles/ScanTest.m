clc
clear all
clc
a = HardwareAbstractionLayer
a.calibrateSledge
b = HardwareScanner(a)
b.firstScan
