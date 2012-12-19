classdef Drawer < GUIEnabledObject
    % Drawer
    %
    % Syntax
    %
    % Description
    %   Plots the numbers on the paper.
    %
    %
    % Signature
    %   Author: Johannes, Martin, Kevin, Florian
    %   Date: 2012/12/19
    %   Copyright: 2012-2014, RWTH Aachen University 
    
    properties
        hw = 0;
    end
    
    
    methods
        % constructor
        function obj = Drawer(hal)
            obj.hw = hal;
        end
        
        % plots a number to a specific location
        function plotNumber(obj, number, x, y)
        
            obj.hw.moveToXY(x, y);
            
            if(number < 0 || number > 9)
                error('Wrong number as input. Only numbers between 0-9 allowed.');
            end
        
        end
    end
    
end

