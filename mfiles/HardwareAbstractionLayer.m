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
        
        
        % nxt1 -> Motor (AB->x, C->y)
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
        
        motorX1 = 0;
        motorX2 = 0;
        motorY = 0;
        motorZ = 0;

        nxtHandle1 = 0;
        nxtHandle2 = 0;
        maxStepsWidth = 1500;   % the max amount of steps which the sledge can move
    end
    
    methods (Access = 'private')
    
        function setMotorY(obj, steps, power)
            
            if(steps < 0)
                power = -power;
            end
            
            obj.motorY.TachoLimit = floor(abs(steps));
            obj.motorY.Power = floor(power);
        end
        
        function setMotorX(obj, steps, power)
            
            if(steps < 0)
                power = -power;
            end
            
            obj.motorX1.TachoLimit = floor(abs(steps));
            obj.motorX1.Power = floor(power);
            obj.motorX2.TachoLimit = floor(abs(steps));
            obj.motorX2.Power = floor(power);
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

            obj.motorX1 = NXTMotor('A', 'SpeedRegulation', 1);
            obj.motorX2 = NXTMotor('B', 'SpeedRegulation', 1);
            obj.motorY = NXTMotor('C');
            obj.motorZ = NXTMotor('A');
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
            obj.setMotorY(steps, -50);            
            obj.motorY.SendToNXT(obj.nxtHandle1);
        end
        
        
        % moves left asynchron
        function moveLeft(obj, steps)
            obj.setMotorY(steps, 50);            
            obj.motorY.SendToNXT(obj.nxtHandle1);
        end
        
        % moves right and waits until it is finished
        function moveRightW(obj, steps)
            obj.moveRight(steps);
            obj.motorY.WaitFor(0, obj.nxtHandle1);
        end
        
        % moves left and waits until it is finished
        function moveLeftW(obj, steps)
            obj.moveLeft(steps);
            obj.motorY.WaitFor(0, obj.nxtHandle1);
        end
        %% end
        
        
        
        %% START: Move in X-Dir
        
        % moves forward and waits until it is finished
        function moveForwardsW(obj, steps)
            obj.moveForwards(steps);
            
            obj.motorX1.WaitFor(0, obj.nxtHandle1);
            obj.motorX2.WaitFor(0, obj.nxtHandle1);

        end
        
        % moves backwards and waits until it is finished
        function moveBackwardsW(obj, steps)
            obj.moveBackwards(steps);
            obj.motorX1.WaitFor(0, obj.nxtHandle1);
            obj.motorX2.WaitFor(0, obj.nxtHandle1);
        end
        
        % moves forward asynchron
        function moveForwards(obj, steps)
            obj.setMotorX(steps, -25);       
            obj.motorX1.SendToNXT(obj.nxtHandle1);
            obj.motorX2.SendToNXT(obj.nxtHandle1);
        end
        
        % moves backward asynchron
        function moveBackwards(obj, steps)
            obj.setMotorX(steps, 25);       
            obj.motorX1.SendToNXT(obj.nxtHandle1);
            obj.motorX2.SendToNXT(obj.nxtHandle1);
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
        function moveToYOrigin(obj)
            obj.moveLeft(0);
            while(~obj.reachedEnd()) end
            obj.motorY.Stop('off', obj.nxtHandle1);

            obj.motorY.ResetPosition(obj.nxtHandle1);

        end

        
        function moveMaxRight(obj)
            pos = obj.getPosition();
            steps = obj.maxStepsWidth - pos(1);
            obj.moveRight(steps);
        end
        
        % calculates the max width steps which the sledge can move
        function calibrateSledge(obj)
            
            obj.motorY.ResetPosition(obj.nxtHandle1);
            obj.setMotorY(0, 25);
            
            data = obj.motorY.ReadFromNXT(obj.nxtHandle1);
            
            start = data.Position;
            
            obj.motorY.SendToNXT(obj.nxtHandle1);
            while(~obj.reachedEnd()) end
            obj.motorY.Stop('off', obj.nxtHandle1);
            
            data = obj.motorY.ReadFromNXT(obj.nxtHandle1);
            
            % Calculate the max step width (offset 14)
            obj.maxStepsWidth = abs(data.Position - start); 
            
            pause(1);
            
            % Setting the origin to [0 0]
            obj.motorX1.ResetPosition(obj.nxtHandle1);
            obj.motorX2.ResetPosition(obj.nxtHandle1);
            obj.motorY.ResetPosition(obj.nxtHandle1);
        end
        %% end
        
        
        %% START: Positioning
        % gets the current position from the motors 
        function [x y] = getPosition(obj)
            
                data = obj.motorY.ReadFromNXT(obj.nxtHandle1);
            y = abs(data.Position);

                data = obj.motorX1.ReadFromNXT(obj.nxtHandle1);
            x1 = -data.Position;
                data = obj.motorX2.ReadFromNXT(obj.nxtHandle1);
            x2 = -data.Position;

            x = 0.5*(x1+x2);

        end
        
        % moves to a specific location
        function moveToXY(obj, x, y)

            [x_old, y_old] = obj.getPosition();

            x_old = floor(x_old);
            y_old = floor(y_old);
            x = floor(x);
            y = floor(y);

            if( x~=x_old)
                obj.moveForwards( x-x_old );
            end
            if(y ~= y_old)
                obj.moveRight( y-y_old );
            end


            obj.motorX1.WaitFor(0, obj.nxtHandle1);
            obj.motorX2.WaitFor(0, obj.nxtHandle1);
            obj.motorY.WaitFor(0, obj.nxtHandle1);

        end
        %% end
        
    end
    
end

