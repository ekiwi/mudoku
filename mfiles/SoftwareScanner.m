classdef SoftwareScanner < AbstractScanner
    % SoftwareScanner
    %
    % Syntax
    %
    % Description
    %   Implements the AbstractScanner interface by
    %   loading a prescanned file when firstScan is called.
    %
    %
    % Signature
    %   Author: Johannes, Martin, Kevin, Florian
    %   Date: 2012/12/17
    %   Copyright: 2012-2014, RWTH Aachen University
    
    properties (Access='private')
        fileName = '';
    end
    
    methods
        function obj = SoftwareScanner(file)
            if nargs > 1
                obj.fileName = file;
            end
        end
    end
    
end

