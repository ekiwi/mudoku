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
        fontSize = 30;
    end
    
    methods (Access = 'Private')
        function plotZero(obj)
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize, 0);
            obj.hw.moveToRelativeXY(0, fontSize);
            obj.hw.moveToRelativeXY(-fontSize, 0);
            obj.hw.moveToRelativeXY(0, -fontSize);
            obj.hw.picPenUp();
        end
        function plotOne(obj)
            obj.hw.moveToRelativeXY(fontSize/2, 0);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(0, fontSize);
            obj.hw.moveToRelativeXY(-fontSize/3, -fontSize/3);
            obj.hw.picPenUp();
        end
        function plotTwo(obj)
            obj.hw.moveToRelativeXY(fontSize, 0);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(-fontSize, 0);
            obj.hw.moveToRelativeXY(0, fontSize/2);
            obj.hw.moveToRelativeXY(fontSize, 0);
            obj.hw.moveToRelativeXY(0, fontSize/2);
            obj.hw.moveToRelativeXY(-fontSize, 0);
            obj.hw.picPenUp();
        end
        function plotThree(obj)
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize, 0);
            obj.hw.moveToRelativeXY(0, fontSize);
            obj.hw.moveToRelativeXY(-fontSize, 0);
            obj.hw.picPenUp();
            obj.hw.moveToRelativeXY(0, -fontSize/2);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize, 0);
            obj.hw.picPenUp();
        end
        function plotFour(obj)
            obj.hw.moveToRelativeXY(fontSize,0);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(0,fontSize);
            obj.hw.moveToRelativeXY(0,-fontSize/2);
            obj.hw.moveToRelativeXY(-fontSize,0);
            obj.hw.moveToRelativeXY(0,fontSize/2);
            obj.picPenUp();            
        end
        function plotFive(obj)
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize,0);
            obj.hw.moveToRelativeXY(0,fontSize/2);
            obj.hw.moveToRelativeXY(-fontSize,0);
            obj.hw.moveToRelativeXY(0,fontSize/2);
            obj.hw.moveToRelativeXY(fontSize,0);
            obj.hw.picPenUp();
        end
        function plotSix(obj)
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize,0);
            obj.hw.moveToRelativeXY(fontSIze/2,0);
            obj.hw.moveToRelativeXY(-fontSize,0);
            obj.hw.moveToRelativeXY(0,-fontSize/2);
            obj.hw.moveToRelativeXY(0,fontSize);
            obj.hw.moveToRelativeXY(fontSize/2,0);
            obj.picPenUp();
        end
        function plotSeven(obj)
            obj.hw.moveToRelativeXY(fontSize,0);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(0,fontSize);
            obj.hw.moveToRelativeXY(-fontSize,0);
            obj.hw.moveToRelativeXY(0,-fontSize/3);
            obj.hw.picPenUp();
        end
        function plotEight(obj)
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize,0);
            obj.hw.moveToRelativeXY(0,fontSize);
            obj.hw.moveToRelativeXY(-fontSize,0);
            obj.hw.moveToRelativeXY(0,-fontSize);
            obj.hw.picPenUp();
            obj.hw.moveToRelativeXY(0,fontSize/2);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize,0);
            obj.hw.picPenUp();
        end
        function plotNine(obj)
            obj.hw.moveToRelativeXY(fontSize,0);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(0,fontSize);
            obj.hw.moveToRelativeXY(-fontSize,0);
            obj.hw.moveToRelativeXY(0,-fontSize/2);
            obj.hw.moveToRelativeXY(fontSize,0);
            obj.hw.picPenp();
        end
    end
    
    methods
        % constructor
        function obj = Drawer(hal)
            obj.hw = hal;
        end
        
        % plots a number to a specific location
        function plotNumber(obj, number, x, y)
        
            obj.hw.moveToXY(x, y);
            
            switch(number)
                case 0
                    obj.plotZero();
                case 1
                    obj.plotOne();
                case 2
                    obj.plotTwo();
                case 3
                    obj.plotThree();
                case 4
                    obj.plotFour();
                case 5
                    obj.plotFive();
                case 6
                    obj.plotSix();
                case 7
                    obj.plotSeven();
                case 8
                    obj.plotEight();
                case 9
                    obj.plotNine();
                    
                otherwise
                error('Wrong number as input. Only numbers between 0-9 allowed.');
            end
        
        end
    end
    
end

