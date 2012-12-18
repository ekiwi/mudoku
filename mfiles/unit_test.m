%% Setuop Unit Tests
clear all; % clear workspace


%% Test HardwareScanner

c = ones(2,5)*5;

a = HardwareScanner(0);
% Test set/get Cell

a.setCell(5,6,c);

if a.getCell(5,6) ~= c
    error('Set Cell did not work.');
end

% Test Saving and Loading
a.saveCells('test.cells');
b = HardwareScanner(0);
b.loadCells('test.cells');

if b.getCell(5,6) ~= c
    error('Save/Load Cell did not work.');
end

%% Done. Success!
% be nice and quiet about it
