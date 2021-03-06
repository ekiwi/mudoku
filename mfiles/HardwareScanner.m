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
        t = 0;

        xStartSoduko = 0;
        yStartSoduko = 0;
        cellWidth = 0;
        cellHeight = 0;
        
        binMatrix = [];
        
    end
    
    methods(Access = 'private')
        
        % Scan a whole area
        % x: Start (Left/Right)
        % y: Start (Forwards/Backwards)
        % width: Steps right
        % height: Steps forward
        % xStep: Size of steps right
        function rawImageData = scanArea(obj, x, y, width, height, xStep)
                                    
            rawImageData = [];
            pos = [0, 0];   % xPosition and yPosition
            
            usedSensor = 0; % 0: SENSOR_1   1: SENSOR_3
            if(x > obj.hw.maxStepsWidth/2)
                usedSensor = 1;
                x = x - 740;
            end
            
            obj.hw.moveToXY(x, y);  % x and y changed
            
            while(pos(1) < width)
                
                %% START: Move Forwards
                obj.hw.moveForwards(0);
                
                while(pos(2)<height)
                    [a, b] = obj.hw.getPosition(); 
                    pos(1) = a-x;  
                    pos(2) = b-y;  
%                     if(pos(1)<1) pos(1) = 1; end % No negative positions allowed
%                     if(pos(2)<1) pos(2) = 1; end
                    
                    if(usedSensor == 0)
                        rawImageData = [rawImageData, [pos(1); pos(2); obj.hw.getBrightness1()]];
                    else
                        rawImageData = [rawImageData, [pos(1); pos(2); obj.hw.getBrightness3()]];
                    end
                      % rawImageData = [rawImageData, [pos(1)+370; pos(2); obj.hw.getBrightness2()+60]];
%                     rawImageData = [rawImageData, [pos(1)+740; pos(2); obj.hw.getBrightness3()]];
                end
                
                obj.hw.motorY1.Stop('brake', obj.hw.nxtHandle1);
                obj.hw.motorY2.Stop('brake', obj.hw.nxtHandle1);
                %% END
                
                % Abort if end has been reached
                if(pos(1)+xStep>=width)
                    break;
                end
                obj.hw.moveRightW(xStep);
                    
                                
                %% START: Move Backwards
                obj.hw.moveBackwards(0);
                
                while(pos(2)>1)
                    [a, b] = obj.hw.getPosition(); 
                    pos(1) = a-x;  
                    pos(2) = b-y;  
%                     if(pos(1)<1) pos(1) = 1; end % No negative positions allowed
%                     if(pos(2)<1) pos(2) = 1; end
                    
                    if(usedSensor == 0)
                        rawImageData = [rawImageData, [pos(1); pos(2); obj.hw.getBrightness1()]];
                    else
                        rawImageData = [rawImageData, [pos(1); pos(2); obj.hw.getBrightness3()]];
                    end
%                     rawImageData = [rawImageData, [pos(1)+370; pos(2); obj.hw.getBrightness2()+60]];
%                     rawImageData = [rawImageData, [pos(1)+740; pos(2); obj.hw.getBrightness3()]];
                end
                
                obj.hw.motorY1.Stop('brake', obj.hw.nxtHandle1);
                obj.hw.motorY2.Stop('brake', obj.hw.nxtHandle1);
                %% END
                
                obj.hw.moveRightW(xStep);
                [a, b] = obj.hw.getPosition(); 
                pos(1) = a-x;  
                pos(2) = b-y; 
%                 if(pos(1)<1) pos(1) = 1; end % No negative positions allowed
%                 if(pos(2)<1) pos(2) = 1; end
                    
            end
            
        end
        
        % Scales and (Rounds) the X-Values, Y-Values, Brightness-Values
        % Returns the rawImageData which contains the updated data
        % Also includes the xScale, xMin and yScale, yMin values:
        %   x_new * xScale + xMin = x_old
        %   y_new * yScale + yMin = y_old         
        function [imageData xScale xMin yScale yMin] = scaleRawImageData(obj, imageData_in, xRes, yRes)
            minBright = min(imageData_in(3,:));
            maxBright = max(imageData_in(3,:));
            imageData = imageData_in;
            imageData(3,:) = (imageData_in(3,:)-minBright) ./ (maxBright-minBright) .* 255;
            
            minX = min(imageData(1, :));
            maxX = max(imageData(1, :));
            minY = min(imageData(2, :));
            maxY = max(imageData(2, :));
            
            xScale = (maxX-minX)/xRes;
            xMin = minX;
            yScale = (maxY-minY)/yRes;
            yMin = minY;
            
            imageData(1,:) = round((imageData(1,:) - minX) ./ xScale);
            imageData(2,:) = round((imageData(2,:) - minY) ./ yScale);

        end
        
        % Calculates the real positions of the machine from the positions
        % in an image
        function [x y] = calcOldPosition(obj, x_new, y_new, xScale, yScale, xMin, yMin)
            x = x_new*xScale+xMin;
            y = y_new*yScale+yMin;
        end
        
        
        % Takes the raw image data generated by scanArea and produces a
        % gray image
        function rawGrayImage = createGrayImageFromRawData(obj, imageData)
            
            numEntries = length(imageData(1, :));
            minX = min(imageData(1, :));
            maxX = max(imageData(1, :));
            minY = min(imageData(2, :));
            maxY = max(imageData(2, :));
            
            width = maxX-minX+1;
            height= maxY-minY+1;
            
            % create NaN matrix
            rawGrayImage = ones(width, height)*NaN;
            % NaN is used to identify which pixels have not been set
            
            for i=1:numEntries
                
                x = imageData(1,i)+1;
                y = imageData(2,i)+1;
                                
                if(isnan(rawGrayImage(x, y)))
                    rawGrayImage(x, y) = imageData(3, i);
                else
                    rawGrayImage(x, y) = 0.5*(rawGrayImage(x, y)+imageData(3, i));
                end
                
            end
            
        end

        % Value
        function value = getValueNear(rawImageData, x, y)
            delta = abs(rawImageData(1,:)-x) + abs(rawImageData(2,:)-y);
            [~, i] = min(delta);
            value = rawImageData(3,i);
        end
        
        % Get the position of the left bottom corner of a cell
        function [x y] = getCellPosition(obj, i, j)
            x = obj.xStartSoduko+obj.cellWidth*i;
            y = obj.yStartSoduko+obj.cellHeight*j;
        end

    end
    
    methods

        % Reads a line
        function rawImageData = readLine(obj, x_start, y_start, x_end, y_end)
            
            rawImageData = [];
            obj.hw.moveToXY(x_start, y_start);  % x and y changed

            pause(1);

            if(y_end ~= y_start)
                obj.hw.moveForwards(y_end-y_start);
            end
            if(x_end ~= x_start)
                obj.hw.moveRight(x_end-x_start);
            end
            data1 = obj.hw.motorX.ReadFromNXT(obj.hw.nxtHandle1);
            data2 = obj.hw.motorY1.ReadFromNXT(obj.hw.nxtHandle1);

            while(data1.Power ~= 0 || data2.Power ~= 0)

                [a, b] = obj.hw.getPosition();                  
                rawImageData = [rawImageData, [a; b; obj.hw.getBrightness1()-10]];
%                     rawImageData = [rawImageData, [pos(1)+370; pos(2); obj.hw.getBrightness2()+60]];
%                     rawImageData = [rawImageData, [pos(1)+740; pos(2); obj.hw.getBrightness3()]];

                data1 = obj.hw.motorX.ReadFromNXT(obj.hw.nxtHandle1);
                data2 = obj.hw.motorY1.ReadFromNXT(obj.hw.nxtHandle1);
            end

        end
                
        
        function drawImage(obj, rawImage, t)
            set(t, 'UserData', rawImage);
        end
        
        function testScan(obj)
            
            obj.hw.moveToXY(0,0);        
            
            width = 1000;
            height = 500;
            xStep = 20;
            pos = [0 0];
            
            image = ones(width+370*2, height)*NaN;
            
            obj.t = timer('TimerFcn',@timer_callback_fcn,'Period', 1,'ExecutionMode','fixedRate', 'UserData', image);            
            start(obj.t);
            
            while(pos(1) < width)
                
                %% START: Move Forwards
                obj.hw.moveForwards(0);
                
                while(pos(2)<height-10)
                    [a, b] = obj.hw.getPosition(); 
                    pos(1) = round(a);  
                    pos(2) = round(b);  
                    if(pos(1)<1) pos(1) = 1; end % No negative positions allowed
                    if(pos(2)<1) pos(2) = 1; end
                    if(pos(1)>width) pos(1) = width; end % No negative positions allowed
                    if(pos(2)>height) pos(2) = height; end
                    
                    image(pos(1), pos(2)) = obj.hw.getBrightness1();
                    image(pos(1)+370, pos(2)) = obj.hw.getBrightness2();
                    image(pos(1)+370*2, pos(2)) = obj.hw.getBrightness3();

                    obj.drawImage(image, obj.t);
                end
                
                obj.hw.motorY1.Stop('brake', obj.hw.nxtHandle1);
                obj.hw.motorY2.Stop('brake', obj.hw.nxtHandle1);
                %% END
                
                % Abort if end has been reached
                if(pos(1)+xStep>=width)
                    break;
                end
                obj.hw.moveRightW(xStep);
                    
                                
                %% START: Move Backwards
                obj.hw.moveBackwards(0);
                
                while(pos(2)>10)
                    [a, b] = obj.hw.getPosition(); 
                    pos(1) = round(a);  
                    pos(2) = round(b);  
                    if(pos(1)<1) pos(1) = 1; end % No negative positions allowed
                    if(pos(2)<1) pos(2) = 1; end
                    if(pos(1)>=width) pos(1) = width-1; end % No negative positions allowed
                    if(pos(2)>=height) pos(2) = height-1; end
                    
                    
                    image(pos(1), pos(2)) = (obj.hw.getBrightness1()-580)/200*255;
                    image(pos(1)+370, pos(2)) = (obj.hw.getBrightness2()-580)/200*255;
                    image(pos(1)+370*2, pos(2)) = (obj.hw.getBrightness3()-580)/200*255;

                    obj.drawImage(image, obj.t);
                end
                
                obj.hw.motorY1.Stop('brake', obj.hw.nxtHandle1);
                obj.hw.motorY2.Stop('brake', obj.hw.nxtHandle1);
                %% END
                
                obj.hw.moveRightW(xStep);
                [a, b] = obj.hw.getPosition();  
                    pos(1) = a;  
                    pos(2) = b; 
                    if(pos(1)<1) pos(1) = 1; end % No negative positions allowed
                    if(pos(2)<1) pos(2) = 1; end
                    if(pos(1)>=width) pos(1) = width-1; end % No negative positions allowed
                    if(pos(2)>=height) pos(2) = height-1; end
                    
            end
            
            stop(obj.t);
            delete(obj.t);
        end


        function obj = HardwareScanner(hal)
            obj.hw = hal;
        end

        function peaksID = detectPeaks(obj, RawImageData, numPeaks)
            window_size = 20;
            threshold_max = 2;
            threshold_step = 0.25;
            threshold_min = 1;
            peaksID = [];

            smoothed = smooth(max(RawImageData(3,:))-RawImageData(3,:), 10);
            differ = smooth(diff(smoothed), 10);
            %axis([1, length(differ), -5 5]);
            %plot(differ);


            threshold = threshold_max;
            while length(peaksID) < numPeaks && threshold >= threshold_min
                i = 1;
                peaksID = [];
                %fprintf('Try with threshold: %d\n', threshold);
                while i <= (length(differ)-window_size)
                    window = differ(i:(window_size+i));
                    [vmax, imax] = max(window);
                    [vmin, imin] = min(window);
                    %plot(window);
                    %axis([1,window_size,-7,7]);          
                    if(vmax > threshold && vmin < -threshold)
                        %fprintf('found peak at %d\n', round(i+((imax+imin)/2)));
                        peaksID = [peaksID, round(i+((imax+imin)/2))];
                        if(length(peaksID) == numPeaks)
                            break;
                        end
                        i = i + window_size;
                        %pause(1);
                    else
                        i = i + 1;
                    end
                    %pause(0.001);
                end
                threshold = threshold - threshold_step;
            end
            
        end


        % Do the first scan
        function firstScan(obj)
            disp('First Scan...');
% 
%             YimageRawData = obj.readLine(400,0,400,400);
%             peaksIDs = obj.detectPeaks(YimageRawData, 2);
% 
%             obj.yStartSoduko = YimageRawData(2, peaksIDs(1));
%             obj.cellHeight = YimageRawData(2, peaksIDs(2)) - YimageRawData(2, peaksIDs(1));
% 
%             XimageRawData = obj.readLine(0,120,600,120);
%             peaksIDs = obj.detectPeaks(XimageRawData, 2);
% 
%             obj.xStartSoduko = YimageRawData(1, peaksIDs(1));
%             obj.cellWidth = XimageRawData(1, peaksIDs(2)) - XimageRawData(1, peaksIDs(1));
% 
%             fprintf('X:%d Y:%d; Width:%d Height:%d\n', obj.xStartSoduko,...
%                 obj.yStartSoduko, obj.cellWidth, obj.cellHeight);

            obj.yStartSoduko = 0;
            obj.xStartSoduko = 0;
            obj.cellWidth = 200;
            obj.cellHeight = 90;
             

% 
%             % Scan a small area (there have to be at least one soduko box)
%             rawImageData = obj.scanArea(0,0,370, 200, 30);
%             
%             [imageData xScale xMin yScale yMin] = obj.scaleRawImageData(rawImageData, 900, 300);
%             
%             grayRawImage = obj.createGrayImageFromRawData(imageData);
%             
%             figure(1); imshow(uint8(grayRawImage));
% 
%             obj.saveData(grayRawImage, 'grayRawImage');
% 
%             grayRawImage = obj.loadData('grayRawImage');
% 
%             % Now do some filtering...
%             grayRawImageFilled = interpolation(grayRawImage);
% 
%             figure(2); imshow(uint8(grayRawImageFilled'));
% 
%             obj.saveData(grayRawImageFilled, 'grayRawImageFilled');
% 
%             firstPeakMatrix = [];
%             numRows = length(grayRawImageFilled(:,10));
%             for y=1:numRows
%                 [peak location] = findpeaks(grayRawImageFilled(:,y), 'THRESHOLD', 10, 'NPEAKS', 1);
%                 if(~isempty(location))
%                     firstPeakMatrix = [firstPeakMatrix, [location; y]];                    
%                 end
%             end
            
            
        end

        
        
        % Do the second scan
        function secondScan(obj)
            disp('Second Scan...');


                
            rawBrightData = [];
            scansPerRow = 3;
            for row=0:(8*scansPerRow)
                rawBrightData = [rawBrightData, ...
                                 obj.readLine(obj.xStartSoduko, obj.yStartSoduko + (row/scansPerRow)*obj.cellHeight,...
                                              obj.xStartSoduko+obj.cellWidth, obj.yStartSoduko + (row/scansPerRow)*obj.cellHeight);];
            end

            rawImageData = obj.scanArea(0,0,obj.hw.maxStepsWidth, 200, 10);
            
            [imageData xScale xMin yScale yMin] = scaleRawImageData(rawImageData, 200, 100);
            
            grayRawImage = createGrayImageFromRawData(imageData);
            
            figure(1); imshow(uint8(grayRawImage));
            
            % Now do some filtering...
            
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
            figure(2); imshow(uint8(grayRawImage));



        end
        
        % Do the thrid scan
        function thirdScan(obj)
            
            im = ImageRecognition();
            for i=1:9
                for j=1:9
                    if(obj.binMatrix(i, j))
                        [x y] = obj.getCellPosition(i-1, j-1);
                        imageData = obj.scanArea(x, y, obj.cellWidth, obj.cellHeight, 10);
                        
                        [imageData xScale xMin yScale yMin] = obj.scaleRawImageData(imageData, obj.cellWidth, obj.cellHeight);
                        grayImage = createGrayImageFromRawData(imageData);
                        grayImageFilled = interpolation(grayImage);
                        number = im.parseCell(grayImageFilled);
                        
                        obj.binMatrix(i, j) = number;
                    end
                end
            end
        end

        function scanCells(obj)
            disp('Scanning Cells...');
        end
    end

end

