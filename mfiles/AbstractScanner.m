classdef AbstractScanner

    % AbstractScanner: Scanner Interface
    %
    % Syntax
    %
    % Description
    %   Abstract Scanner Interface that can be implemented
    %   with real hardware or by reading a file
    %
    %
    % Signature
    %   Author: Johannes, Martin, Kevin, Florian
    %   Date: 2012/12/17
    %   Copyright: 2012-2014, RWTH Aachen University
    
    methods (Abstract)
        firstScan(obj)
        scanCells(obj)
        img_matrix = getCell(obj, x,y)
    end
    
end

