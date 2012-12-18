classdef HardwareScanner < AbstractScanner
    % HardwareScanner
    %
    % Syntax
    %
    % Description
    %   Implements the AbstractScanner interface with
    %   real hardware.
    %
    %
    % Signature
    %   Author: Johannes, Martin, Kevin, Florian
    %   Date: 2012/12/17
    %   Copyright: 2012-2014, RWTH Aachen University
    
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
    end

end

