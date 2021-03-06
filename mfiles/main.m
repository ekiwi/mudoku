    % ---- Mudoku -----
    %   
    %  
    %
    % Signature
    %   Author: Johannes, Martin, Kevin, Florian
    %   Date: 2012/12/17
    %   Copyright: 2012-2014, RWTH Aachen University

version = 0.1;
defaultfile = 'default.cells';

fprintf('---- Mudoku ----\n');
fprintf('Version: %.1f\n', version);
fprintf('Authors: Johannes, Martin, Kevin, Florian\n');
fprintf('RWTH Aachen University\n\n');

%% Get Cell Data
hal = 0;

if ask('Using real hardware?')
    hal = HardwareAbstractionLayer;
    scanner = HardwareScanner(hal);
    disp('Starting first scan...');
    scanner.firstScan();
    disp('Scanning cells...');
    scanner.scanCells();
else
    scanner = HardwareScanner(hal);
    filename = ask('Please provide a file name', 'string', defaultfile);
    scanner.loadCells(filename);
end

[ width, height ] = scanner.getNumCells();
fprintf('Scann done. Sudoku dimensions: %dx%d', width, height);

if ~ask('Continue?', 'bool', 'yes')
    error('aborted');
end

if ask('Do you want to save the cells?', 'bool', 'no')
    filename = ask('Please provide a file name', 'string', defaultfile);
    scanner.saveCells(filename);
end

%% Image Recognition
sudoku = ones(width, height) * NaN;

r = ImageRecognition;
for x = 1:width
    for y = 1:height
        sudoku(x,y) = r.parseCell(scanner.getCell(x,y));
    end
end

disp('Done with ImageRecognition.');
disp_sudoku(sudoku);



%% Solve Sudoku




%% Draw Results
if hal ~= 0
    disp('Using real hardware -> draw results');
end