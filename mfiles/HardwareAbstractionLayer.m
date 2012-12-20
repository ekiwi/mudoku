classdef HardwareAbstractionLayer < handle   
    
    % HardwareAbstractionLayer: Wrapper for the hardware layer
    % 
    % Syntax 
    %   obj = HardwareAbstractionLayer(varargin)
    %
    % Description
    %
    %   
    %
    %     Available properties are:
    %   
    %  
    %
    % Signature
    %   Author: Johannes, Martin, Kevin, Florian
    %   Date: 2012/12/17
    %   Copyright: 2012-2014, RWTH Aachen University
    
    properties (Access = 'private')
        
        
        % nxt1 -> Motor (AB->y, C->x)
        %         SENSOR_1->left Sensor
        %         SENSOR_2->middle Sensor
        %         SENSOR_3->right Sensor
        % nxt2 -> Motor (A->z, B->Lamp1, C->Lamp2)
        %         SENSOR_1->pressureLeft, 
        %         SENSOR_2->pressureRight)

        lamp1 = 0;
        lamp2 = 0;
    end
    
    properties (Access = 'public')
        
        motorY1 = 0;
        motorY2 = 0;
        motorX = 0;
        motorZ = 0;

        nxtHandle1 = 0;
        nxtHandle2 = 0;
        maxStepsWidth = 1500;   % the max amount of steps which the sledge can move
    end
    
    methods (Access = 'private')
    
        function setMotorX(obj, steps, power)
            
            if(steps < 0)
                power = -power;
            end
            
            obj.motorX.TachoLimit = floor(abs(steps));
            obj.motorX.Power = floor(power);
        end
        
        function setMotorY(obj, steps, power)
            
            if(steps < 0)
                power = -power;
            end
            
            obj.motorY1.TachoLimit = floor(abs(steps));
            obj.motorY1.Power = floor(power);
            obj.motorY2.TachoLimit = floor(abs(steps));
            obj.motorY2.Power = floor(power);
        end
        
        function setMotorZ(obj, steps, power)
            
            if(steps < 0)
                power = -power;
            end
            
            obj.motorZ.TachoLimit = floor(abs(steps));
            obj.motorZ.Power = floor(power);
        end
    end
    
    
    methods

        % constructor
        function obj = HardwareAbstractionLayer(varargin)
            COM_CloseNXT('all');

            obj.nxtHandle1 = COM_OpenNXTEx('USB','00165311BC5D');
            obj.nxtHandle2 = COM_OpenNXTEx('USB','00165302F03F');
            
            OpenSwitch(SENSOR_1, obj.nxtHandle2);
            
            OpenLight(SENSOR_1, 'ACTIVE', obj.nxtHandle1);
            OpenLight(SENSOR_2, 'ACTIVE', obj.nxtHandle1);
            OpenLight(SENSOR_3, 'ACTIVE', obj.nxtHandle1);

            obj.motorY1 = NXTMotor('A', 'SpeedRegulation', 1, 'ActionAtTachoLimit', 'HoldBrake');
            obj.motorY2 = NXTMotor('B', 'SpeedRegulation', 1);
            obj.motorX = NXTMotor('C', 'SpeedRegulation', 1, 'ActionAtTachoLimit', 'HoldBrake');
            obj.motorZ = NXTMotor('A', 'SpeedRegulation', 1, 'ActionAtTachoLimit', 'HoldBrake');
        end
        
        % destructor
        function delete(obj)
            
            CloseSensor(SENSOR_1, obj.nxtHandle2);

            CloseSensor(SENSOR_1, obj.nxtHandle1);
            CloseSensor(SENSOR_2, obj.nxtHandle1);
            CloseSensor(SENSOR_3, obj.nxtHandle1);

            SwitchLamp(MOTOR_B, 'off', obj.nxtHandle2);
            SwitchLamp(MOTOR_C, 'off', obj.nxtHandle2);
            
            StopMotor('all', 'off', obj.nxtHandle1);
            StopMotor('all', 'off', obj.nxtHandle2);
            COM_CloseNXT('all');
        end
        
        %% START: Pencil-Control
        function putPenDown(obj)
            obj.setMotorZ(9, 20);
            obj.motorZ.SendToNXT(obj.nxtHandle2);
        end
        function pickPenUp(obj)
            obj.setMotorZ(9, -20);
            obj.motorZ.SendToNXT(obj.nxtHandle2);
        end
        %% end
        
        
        %% START: Lamps
        
        % toggles the lamp1
        function toggleLamp1(obj)
            if(obj.lamp1)
                SwitchLamp(MOTOR_B, 'off', obj.nxtHandle2);
            else
                SwitchLamp(MOTOR_B, 'on', obj.nxtHandle2);
            end
            obj.lamp1 = ~obj.lamp1;
        end
        
        % toggles the lamp2
        function toggleLamp2(obj)
            if(obj.lamp2)
                SwitchLamp(MOTOR_C, 'off', obj.nxtHandle2);
            else
                SwitchLamp(MOTOR_C, 'on', obj.nxtHandle2);
            end
            obj.lamp2 = ~obj.lamp2;
        end
        %% end
        
        
        
        %% START: Light-Sensors
        function value = getBrightness1(obj)
            value = GetLight(SENSOR_1, obj.nxtHandle1);
        end
        function value = getBrightness2(obj)
            value = GetLight(SENSOR_2, obj.nxtHandle1);
        end
        function value = getBrightness3(obj)
            value = GetLight(SENSOR_3, obj.nxtHandle1);
        end
        function [a b c] = getBrightness(obj)
            a = GetLight(SENSOR_1, obj.nxtHandle1);
            b = GetLight(SENSOR_2, obj.nxtHandle1);
            c = GetLight(SENSOR_3, obj.nxtHandle1);
        end
        %% end
        
        
        
        %% START: Move in Y-Dir
        
        % moves right asynchron
        function moveRight(obj, steps)            
            obj.setMotorX(steps, -50);            
            obj.motorX.SendToNXT(obj.nxtHandle1);
        end
        
        
        % moves left asynchron
        function moveLeft(obj, steps)
            obj.setMotorX(steps, 50);            
            obj.motorX.SendToNXT(obj.nxtHandle1);
        end
        
        % moves right and waits until it is finished
        function moveRightW(obj, steps)
            obj.moveRight(steps);
            obj.motorX.WaitFor(0, obj.nxtHandle1);
        end
        
        % moves left and waits until it is finished
        function moveLeftW(obj, steps)
            obj.moveLeft(steps);
            obj.motorX.WaitFor(0, obj.nxtHandle1);
        end
        %% end
        
        
        
        %% START: Move in X-Dir
        
        % moves forward and waits until it is finished
        function moveForwardsW(obj, steps)
            obj.moveForwards(steps);
            
            obj.motorY1.WaitFor(0, obj.nxtHandle1);
            obj.motorY2.WaitFor(0, obj.nxtHandle1);

        end
        
        % moves backwards and waits until it is finished
        function moveBackwardsW(obj, steps)
            obj.moveBackwards(steps);
            obj.motorY1.WaitFor(0, obj.nxtHandle1);
            obj.motorY2.WaitFor(0, obj.nxtHandle1);
        end
        
        % moves forward asynchron
        function moveForwards(obj, steps)
            obj.setMotorY(steps, -10);       
            obj.motorY1.SendToNXT(obj.nxtHandle1);
            obj.motorY2.SendToNXT(obj.nxtHandle1);
        end
        
        % moves backward asynchron
        function moveBackwards(obj, steps)
            obj.setMotorY(steps, 10);       
            obj.motorY1.SendToNXT(obj.nxtHandle1);
            obj.motorY2.SendToNXT(obj.nxtHandle1);
        end
        %% end
        
        
        
        %% START: Move Y (pressure)
        
        % checks wether the end of sledge has been reached
        % returns 1 when end is reached
        % returns 0 when end is not reached
        function ans = reachedEnd(obj)
            ans = GetSwitch(SENSOR_1, obj.nxtHandle2);
        end
        
        % moves to the left origin until the switch is pressed
        function moveToXOrigin(obj)
            obj.moveLeft(0);
            while(~obj.reachedEnd()) end
            obj.motorX.Stop('off', obj.nxtHandle1);
            obj.motorX.ResetPosition(obj.nxtHandle1);
        end

        % move to the max right position
        function moveMaxRight(obj)
            pos = obj.getPosition();
            steps = obj.maxStepsWidth - pos(1);
            obj.moveRight(steps);
        end
        
        % calculates the max width steps which the sledge can move
        function calibrateSledge(obj)
            
            obj.motorX.ResetPosition(obj.nxtHandle1);
            obj.setMotorX(0, 25);
            
            data = obj.motorX.ReadFromNXT(obj.nxtHandle1);
            
            start = data.Position;
            
            obj.motorX.SendToNXT(obj.nxtHandle1);
            while(~obj.reachedEnd()) end
            obj.motorX.Stop('off', obj.nxtHandle1);
            
            data = obj.motorX.ReadFromNXT(obj.nxtHandle1);
            
            % Calculate the max step width (offset 14)
            obj.maxStepsWidth = abs(data.Position - start); 
            
            pause(1);
            
            % Setting the origin to [0 0]
            obj.motorY1.ResetPosition(obj.nxtHandle1);
            obj.motorY2.ResetPosition(obj.nxtHandle1);
            obj.motorX.ResetPosition(obj.nxtHandle1);
        end
        %% end
        
        
        %% START: Positioning
        % gets the current position from the motors 
        function [x y] = getPosition(obj)
            
                data = obj.motorX.ReadFromNXT(obj.nxtHandle1);
            x = abs(data.Position);

                data = obj.motorY1.ReadFromNXT(obj.nxtHandle1);
            y1 = -data.Position;
                data = obj.motorY2.ReadFromNXT(obj.nxtHandle1);
            y2 = -data.Position;

            y = 0.5*(y1+y2);

        end
        
        % moves to a specific location
        function moveToXY(obj, x, y)
                        
            [x_old, y_old] = obj.getPosition();

            x_old = floor(x_old);
            y_old = floor(y_old);
            x = floor(x);
            y = floor(y);

            if( x~=x_old)
                obj.moveRight( x-x_old );
            end
            if(y ~= y_old)
                obj.moveForwards( y-y_old );
            end


            obj.motorY1.WaitFor(0, obj.nxtHandle1);
            obj.motorY2.WaitFor(0, obj.nxtHandle1);
            obj.motorX.WaitFor(0, obj.nxtHandle1);

        end
        
        % moves to a specific relative location
        function moveToRelativeXY(obj, xRel, yRel)
            [x_old, y_old] = obj.getPosition();
            obj.moveToXY(x_old + xRel, y_old + yRel);
        end
        
        %% end
        
    end
    
end

