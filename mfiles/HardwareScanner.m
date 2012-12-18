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

            % begin at [0 0]
            obj.hw.moveToXY(0, 0);

            x = 0;
            step_x = 20;
            y = 0;
            step_y = 20;

            image = [];
            
            while(y < 2000)

                while(x < obj.maxStepsWidth)

                    image(x, y) = obj.hw.getBrightness1();

                    obj.hw.moveRightW(step_x);
                    x = x+step_x;
                end

                obj.hw.moveForwardsW(step_y);
                y = y + step_y;

                while(x >= 0)

                    image(x, y) = obj.hw.getBrightness1();

                    obj.hw.moveLeftW(step_x);
                    x = x-step_x;
                end

                obj.hw.moveForwardsW(step_y);
                y = y + step_y;
            end

            image
            imshow(image);

        end

        function scanCells(obj)
            disp('Scanning Cells...');
        end
    end

end

