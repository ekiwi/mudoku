%
% 
%


HardwareScanner scan = MOD_HardScanner();
% SoftwareScanner scan = MOD_SoftScanner();

scan.firstScan();


binMatrix = firstScan();

imageMatrix = finalScan(binMatrix);

sodukoMatrix = recognizeNumbers(imageMatrix);

sodukoMatrix = solveSoduko(sodukoMatrix);

paintSodukoMatrix(binMatrix, sodukoMatrix);

