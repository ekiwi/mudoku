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
        fontSize = 200;
    end
    
    methods (Access = 'private')
        function plotZero(obj)
            fontSize = obj.fontSize;
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize*2, 0);
            obj.hw.moveToRelativeXY(0, fontSize);
            obj.hw.moveToRelativeXY(-fontSize*2, 0);
            obj.hw.moveToRelativeXY(0, -fontSize);
            obj.hw.pickPenUp();
        end
        function plotOne(obj)
            fontSize = obj.fontSize;
            obj.hw.moveToRelativeXY(fontSize, 0);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(0, fontSize);
            obj.hw.moveToRelativeXY(-fontSize/2, -fontSize/2);
            obj.hw.pickPenUp();
        end
        function plotTwo(obj)
            fontSize = obj.fontSize;
            obj.hw.moveToRelativeXY(fontSize*2, 0);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(-fontSize*2, 0);
            obj.hw.moveToRelativeXY(0, fontSize/2);
            obj.hw.moveToRelativeXY(fontSize*2, 0);
            obj.hw.moveToRelativeXY(0, fontSize/2);
            obj.hw.moveToRelativeXY(-fontSize*2, 0);
            obj.hw.pickPenUp();
        end
        function plotThree(obj)
            fontSize = obj.fontSize;
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize*2, 0);
            obj.hw.moveToRelativeXY(0, fontSize);
            obj.hw.moveToRelativeXY(-fontSize*2, 0);
            obj.hw.pickPenUp();
            obj.hw.moveToRelativeXY(0, -fontSize/2);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize*2, 0);
            obj.hw.pickPenUp();
        end
        function plotFour(obj)
            fontSize = obj.fontSize;
            obj.hw.moveToRelativeXY(fontSize*2,0);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(0,fontSize);
            obj.hw.moveToRelativeXY(0,-fontSize/2);
            obj.hw.moveToRelativeXY(-fontSize*2,0);
            obj.hw.moveToRelativeXY(0,fontSize/2);
            obj.hw.pickPenUp();            
        end
        function plotFive(obj)
            fontSize = obj.fontSize;
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize*2,0);
            obj.hw.moveToRelativeXY(0,fontSize/2);
            obj.hw.moveToRelativeXY(-fontSize*2,0);
            obj.hw.moveToRelativeXY(0,fontSize/2);
            obj.hw.moveToRelativeXY(fontSize*2,0);
            obj.hw.pickPenUp();
        end
        function plotSix(obj)
            fontSize = obj.fontSize;
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize*2,0);
            obj.hw.moveToRelativeXY(0,fontSize/2);
            obj.hw.moveToRelativeXY(-fontSize*2,0);
            obj.hw.moveToRelativeXY(0,-fontSize/2);
            obj.hw.pickPenUp();
            obj.hw.moveToRelativeXY(0,fontSize);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(0,-fontSize/2);
            obj.hw.pickPenUp();
        end
        function plotSeven(obj)
            fontSize = obj.fontSize;
            obj.hw.moveToRelativeXY(fontSize*2,0);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(0,fontSize);
            obj.hw.moveToRelativeXY(-fontSize*2,0);
            obj.hw.moveToRelativeXY(0,-fontSize/3);
            obj.hw.pickPenUp();
        end
        function plotEight(obj)
            fontSize = obj.fontSize;
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize*2,0);
            obj.hw.moveToRelativeXY(0,fontSize);
            obj.hw.moveToRelativeXY(-fontSize*2,0);
            obj.hw.moveToRelativeXY(0,-fontSize);
            obj.hw.pickPenUp();
            obj.hw.moveToRelativeXY(0,fontSize/2);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(fontSize*2,0);
            obj.hw.pickPenUp();
        end
        function plotNine(obj)
            fontSize = obj.fontSize;
            obj.hw.moveToRelativeXY(fontSize*2,0);
            obj.hw.putPenDown();
            obj.hw.moveToRelativeXY(0,fontSize);
            obj.hw.moveToRelativeXY(-fontSize*2,0);
            obj.hw.moveToRelativeXY(0,-fontSize/2);
            obj.hw.moveToRelativeXY(fontSize*2,0);
            obj.hw.pickPenUp();
        end
    end
    
    methods (Access = 'public')
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

