classdef DataSaveable < handle
    %DATASAVEABLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        saveDir = 'data'
    end
    
    methods (Access = 'protected')
        function saveData(obj, data, fileName)
            mkdir(obj.saveDir);
            d = data;
            save([obj.saveDir, '/', fileName], 'd', '-mat');
        end
        
        function data = loadData(obj, fileName)
            load([obj.saveDir, '/', fileName], 'd', '-mat');
            data = d;
        end
    end
    
end

