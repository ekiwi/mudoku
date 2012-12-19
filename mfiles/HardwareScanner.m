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
            
            sensorThickness = 50;
            xResulutionFaktor = 0.2;
            yLength = 20000;
            
            image = [];

            % begin at [0 0]
            obj.hw.moveToXY(0, 0);
            pos = [0 0];

            while(pos(1)<obj.hw.maxStepsWidth && ~obj.hw.reachedEnd())
            
                [motorX1 motorX2] = obj.hw.moveForwards(0);

                while(pos(2)<yLength)
                    pos = obj.hw.getPosition(); 
                    image(pos(1), pos(2)) = obj.hw.getBrightness1();
                    image(pos(1)+sensorThickness, pos(2)) = obj.hw.getBrightness2();
                    image(pos(1)+sensorThickness*2, pos(2)) = obj.hw.getBrightness3();
                end
                motorX1.Stop('brake', obj.hw.nxtHandle1);
                motorX2.Stop('brake', obj.hw.nxtHandle1);

                obj.hw.moveRightW(sensorThickness*xResulutionFaktor);
                pos = obj.hw.getPosition();

                [motorX1 motorX2] = obj.hw.moveBackwards(0);

                while(pos(2)>=0)
                    pos = obj.hw.getPosition(); 
                    image(pos(1), pos(2)) = obj.hw.getBrightness1();
                    image(pos(1)+sensorThickness, pos(2)) = obj.hw.getBrightness2();
                    image(pos(1)+sensorThickness*2, pos(2)) = obj.hw.getBrightness3();
                end
                motorX1.Stop('brake', obj.hw.nxtHandle1);
                motorX2.Stop('brake', obj.hw.nxtHandle1);

                obj.hw.moveRightW(sensorThickness*xResulutionFaktor);
                pos = obj.hw.getPosition();
            
            end
            

            image
            imshow(image);

        end

        function scanCells(obj)
            disp('Scanning Cells...');
        end
    end

end

