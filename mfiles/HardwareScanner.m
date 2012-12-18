classdef HardwareScanner < AbstractScanner
    %HARDWARESCANNER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = 'private', SetAccess = 'private')
        hw = 0;
    end
    
    methods
        function obj = HardwareScanner(hal)
            obj.hw = hal;
        end

        function firstScan(obj)
            disp('First Scan...');
        end

        function scanCells(obj)
            disp('Scanning Cells...');
        end

        function getCell(obj, x, y)
            fprintf('Getting Cell @ %d,%d\n', x, y);
        end

    end

end

