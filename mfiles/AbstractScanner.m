classdef AbstractScanner
    %ABSTRACTSCANNNER Scanner Interface
    %   Abstract Scanner Interface that can be implemented
    %   with real hardware or by reading a file
    
    methods (Abstract)
        firstScan(obj)
        scanCells(obj)
        img_matrix = getCell(obj, x,y)
    end
    
end

