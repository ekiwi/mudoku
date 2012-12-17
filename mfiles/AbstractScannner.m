classdef AbstractScannner
    %ABSTRACTSCANNNER Scanner Interface
    %   Abstract Scanner Interface that can be implemented
    %   with real hardware or by reading a file
    
    methods (Abstract)
        firstScan(hw)
        scanCells(hw)
        img_matrix = getCell(x,y)
    end
    
end

