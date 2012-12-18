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
    
    properties (Access = 'private')
        cells = [];
    end

    methods
        function img_matrix = getCell(obj, x, y)
            if ~isempty(obj.cells)
                s = size(obj.cells);
                if x > 0 && x < s(1)+1 && y > 0 && y < s(2)+1
                    img_matrix = squeeze(obj.cells(x,y,:,:));
                else
                    error('x or y is out of range! %d > x > 0 and %d > y > 0', s(1)+1, s(2)+1);
                end
            else
                error('No cell data available!');
            end
        end
    end

    methods (Access = 'public')
        function obj = addCell(obj, x, y, cell)
            obj.cells(x,y,:,:) = cell;
        end
    end

    methods (Abstract)
        firstScan(obj)
        scanCells(obj)
    end

end

