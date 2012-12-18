classdef HardwareAbstractionLayer   
    
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
    
    properties
        
        nxtHandle = 0;
        motorX = 0;
        motorY = 0;
        motorZ = 0;
        
        pressureLeft = 0;
        pressureRight = 0;
    end
    
    methods
        
        % constructor
        function obj = HardwareAbstractionLayer()
            
            
        end
        
        % destructor
        function delete(obj)
            
        end
        
        function moveRight(obj, steps)
            
        end
        
        function moveLeft(obj, steps)
        end
        
        function moveForwards(obj, steps)
            obj.motorX = NXTMotor('BC', 'Power', 20, 'TachoLimit', steps);
            
            motorX.SendToNXT();
            motorX.WaitFor(20);
        end
        
        function moveBackwards(obj steps)
            obj.motorX = NXTMotor('BC', 'Power', -20, 'TachoLimit', steps);
            motorX.SendToNXT();
            motorX.WaitFor(20);
        end
        
        function ans = reachedEnd(obj)
        end
        
        function moveToLeftLimit(obj)
            while(~reachedEnd())
                moveLeft(1);
            end
        end
        
        function moveToRightLimit(obj)
            while(~reachedEnd())
                moveRight(1);
            end
        end
        
    end
    
end

