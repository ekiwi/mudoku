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

        function firstScan(varargin)
            disp('First Scan...');
        end

        function scanCells(varargin)
            disp('Scanning Cells...');
        end

        function getCell(x,y)
            disp('Getting Cell Content');
        end

    end

end

