classdef HardwareAbstractionLayer < handle   
    
    % HardwareAbstractionLayer: Wrapper for the hardware layer
    % 
    % Syntax
    %   
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
        
        nxtHandle1 = 0;
        nxtHandle2 = 0;
        
        lamp1 = 0;
        lamp2 = 0;
        
        %rightLightSensor = 0;
        %middleLightSensor = 0;
        %leftLightSensor = 0;
    end
    
    properties (Access = 'public')
        maxStepsWidth = 0;   % the max amount of steps which the sledge can move
    end
    
    methods (Access = 'private')
    
        % creates a motor object and also accept negative steps
        function motorObj = createMotorObj(obj, port, power, steps)
        
            if(steps < 0)
                power = -power;
            end
            
            motorObj = NXTMotor(port, 'Power', floor(power), 'TachoLimit', floor(abs(steps)), 'SpeedRegulation', 1);
            
        end

    
    end
    
    
    methods

        % constructor
        function obj = HardwareAbstractionLayer(varargin)
            COM_CloseNXT('all');
            obj.nxtHandle1 = COM_OpenNXTEx('USB','00165311BC5D');
            obj.nxtHandle2 = COM_OpenNXTEx('USB','00165302F03F');
            
            OpenSwitch(SENSOR_1, obj.nxtHandle2);
            OpenSwitch(SENSOR_2, obj.nxtHandle2);
            
            OpenLight(SENSOR_1, 'ACTIVE', obj.nxtHandle1);
            OpenLight(SENSOR_2, 'ACTIVE', obj.nxtHandle1);
            OpenLight(SENSOR_3, 'ACTIVE', obj.nxtHandle1);
        end
        
        % destructor
        function delete(obj)
            
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
        function motorY = moveRight(obj, steps)
            motorY = createMotorObj('C', 20, steps);
            motorY.SendToNXT(obj.nxtHandle1);
        end
        
        
        % moves left asynchron
        function motorY = moveLeft(obj, steps)
            motorY = createMotorObj('C', -20, steps);
            motorY.SendToNXT(obj.nxtHandle1);
        end
        
        % moves right and waits until it is finished
        function motorY = moveRightW(obj, steps)
            motorY = createMotorObj('C', 20, steps);
            
            motorY.SendToNXT(obj.nxtHandle1);
            motorY.WaitFor(0);
        end
        
        % moves left and waits until it is finished
        function motorY = moveLeftW(obj, steps)
            motorY = createMotorObj('C', -20, steps);
            
            motorY.SendToNXT(obj.nxtHandle1);
            motorY.WaitFor(0);
        end
        %% end
        
        
        
        %% START: Move in X-Dir
        
        % moves forward and waits until it is finished
        function motorX = moveForwardsW(obj, steps)
            motorX = obj.createMotorObj('AB', -20, steps);
            motorX.SendToNXT(obj.nxtHandle1);
            motorX.WaitFor(0);
        end
        
        % moves backwards and waits until it is finished
        function motorX = moveBackwardsW(obj, steps)
            motorX = obj.createMotorObj('AB', 20, steps);
            motorX.SendToNXT(obj.nxtHandle1);
            motorX.WaitFor(0);
        end
        
        % moves forward asynchron
        function motorX = moveForwards(obj, steps)
            motorX = obj.createMotorObj('AB', -20, steps);
            motorX.SendToNXT(obj.nxtHandle1);
        end
        
        % moves backward asynchron
        function motorX = moveBackwards(obj, steps)
            motorX = obj.createMotorObj('AB', 20, steps);
            motorX.SendToNXT(obj.nxtHandle1);
        end
        %% end
        
        
        
        %% START: Move Y (pressure)
        
        % checks wether the end of sledge has been reached
        % returns 1 when end is reached
        % returns 0 when end is not reached
        function ans = reachedEnd(obj)
            state1 = GetSwitch(SENSOR_1, nxtHandle2);
            state2 = GetSwitch(SENSOR_2, nxtHandle2);
            if(state1 || state2)
                ans = 1;
            else
                ans = 0;
            end
        end
        
        % moves to the left until end is reached
        function motorY = moveToLeftLimit(obj)
            while(~reachedEnd())
                motorY = moveLeftW(1);
            end
        end
        
        % moves to the right until end is reached
        function motorY = moveToRightLimit(obj)
            while(~reachedEnd())
                motorY = moveRightW(1);
            end
        end
        
        % calculates the max width steps which the sledge can move
        function calibrateSledge(obj)
            moveToLeftLimit(obj);
            
            motorY = NXTMotor('C', 'Power', 10, 'TachoLimit', 0, 'SpeedRegulation', 1);
            motorY.ResetPosition(obj.nxtHandle1);
            
            data = motorY.ReadFromNXT(obj.nxtHandle1);
            
            start = data.Position;
            
            motorY.SendToNXT();
            while(~reachedEnd()) end
            motorY.Stop('brake');
            
            data = motorY.ReadFromNXT(obj.nxtHandle1);
            
            % Calculate the max step width (offset 14)
            obj.maxStepsWidth = data.Position - start - 14; 
            
            moveLeftW(7);
            
            % Setting the origin to [0 0]
            motorX = NXTMotor('AB');
            motorY = NXTMotor('C');
            motorX.ResetPosition(obj.nxtHandle1);
            motorY.ResetPosition(obj.nxtHandle1);
        end
        %% end
        
        
        %% START: Positioning
        function [x y] = getPosition(obj)
                motorY = NXTMotor('C');
                data = motorY.ReadFromNXT(obj.nxtHandle1);
            y = data.Position;
                motorX = NXTMotor('AB');
                data = motorX.ReadFromNXT(obj.nxtHandle1);
            x = data.Position;
        end
        
        % moves to a specific location
        function moveToXY(obj, x, y)
            pos = getPosition(obj);
            steps = pos - [x y];
            m1 = moveRight(x);
            m2 = moveForward(y);
            m1.WaitFor(0);
            m2.WaitFor(0);
        end
        %% end
        
    end
    
end

