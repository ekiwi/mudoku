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
            
            sensorThickness = 370;
            yResulutionFaktor = 0.1;    % how many lines between one sensor are scanned 1/1
            xLength = 100;
                     
            image = [];

            % begin at [0 0]
            obj.hw.moveToXY(0, 0);
            x = 0;
            y = 0;

            while(y < obj.hw.maxStepsWidth)
            
                obj.hw.moveForwards(0);

                while(x<xLength)
                    [x, y] = obj.hw.getPosition(); 
                    x = x+1; y = y+1;

                    image = [image, [x; y; obj.hw.getBrightness1()]];
                    image = [image, [x+sensorThickness; y; obj.hw.getBrightness2()]];
                    image = [image, [x+sensorThickness*2; y; obj.hw.getBrightness3()]];
                end
                obj.hw.motorX1.Stop('brake', obj.hw.nxtHandle1);
                obj.hw.motorX2.Stop('brake', obj.hw.nxtHandle1);

                obj.hw.moveRightW(sensorThickness*yResulutionFaktor);
                [x, y] = obj.hw.getPosition(); 
                x = x+1; y = y+1;
                
                obj.hw.moveBackwards(0);

                while(x>0)
                    [x, y] = obj.hw.getPosition(); 
                    x = x+1; y = y+1;
                    image = [image, [x; y; obj.hw.getBrightness1()]];
                    image = [image, [x+sensorThickness; y; obj.hw.getBrightness2()]];
                    image = [image, [x+sensorThickness*2; y; obj.hw.getBrightness3()]];
                end
                obj.hw.motorX1.Stop('brake', obj.hw.nxtHandle1);
                obj.hw.motorX2.Stop('brake', obj.hw.nxtHandle1);

                obj.hw.moveRightW(sensorThickness*yResulutionFaktor);
                [x, y] = obj.hw.getPosition();         
                 x = x+1; y = y+1;    
            end
            
            minBright = min(image(3,:));
            maxBright = max(image(3,:));
            image(3,:) = (image(3,:)-minBright) ./ (maxBright-minBright) .* 255;

            maxX = max(image(1,:));
            minX = min(image(1,:));
            maxY = max(image(2,:));
            minY = min(image(2,:));

            xResolution = 200;
            yResolution = 40;

            image(1,:) = (image(1,:) - minX) ./ (maxX-minX) .* (xResolution-1)+1;
            image(2,:) = (image(2,:) - minY) ./ (maxY-minY) .* (yResolution-1)+1;

            imageMatrix = ones(xResolution+1, yResolution+1)*NaN;

            figure(2);
            hold on;
            plot(image(1,:),image(2,:));
            image(1,:) = round(image(1,:));
            image(2,:) = round(image(2,:));
            plot(image(1,:),image(2,:));

            for i=1:length(image(1,:))
                x = image(1,i);
                y = image(2,i);
                if(isnan(imageMatrix(x, y)))
                    imageMatrix(x, y) = image(3, i);
                else
                    imageMatrix(x, y) = 0.5*(imageMatrix(x, y)+image(3, i));
                end
            end

            figure(3);

            for x=1:xResolution
                for y=2:yResolution
                    if(isnan(imageMatrix(x, y)))
                        imageMatrix(x, y) = imageMatrix(x, y-1);
                    end
                end
            end

            for y=1:yResolution
                for x=2:xResolution
                    if(isnan(imageMatrix(x, y)))
                        imageMatrix(x, y) = imageMatrix(x-1, y);
                    end
                end
            end

            imshow(uint8(imageMatrix))

%             negativeValues = find(image(1,:)<0);
%             image(:, negativeValues) = zeros( [3,length(negativeValues)]);
% 
%             matrix2D
% 
%             numXY = length(image(3,:));
% 
%             maxX = max(image(1,:));
%             maxY = max(image(2,:));
% 
%             imageMatrix = [];
% 
%             for x=1:maxX
%                 sameX = find(image(1,:) == x);    
%                 [r c] = size(sameX);    
%                 if(c == 0 && r == 0)
%                     continue;
%                 end
%                 
%                 buffer1 = image(:,sameX);
%                 for y=1:maxY
%                     sameY = find(buffer1(2,:) == y);
%                     [r c] = size(sameY);    
%                     if(c == 0 && r == 0)
%                         imageMatrix(x, buffer1(2,:)) = buffer1(3,:);
%                     else
%                         buffer2 = image(:, sameY);  
%                         color = mean(buffer2(3,:));
%                         imageMatrix(x, y) = color;
%                     end
%                 end
%             end
% 
%             imshow(imageMatrix);

        end

        function scanCells(obj)
            disp('Scanning Cells...');
        end
    end

end

