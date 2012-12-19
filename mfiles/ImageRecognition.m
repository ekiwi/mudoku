classdef ImageRecognition
    
    % ImageRecognition: Parses a cell
    %
    % Syntax
    %   num = parseCell(img)
    %
    % Description
    %
    %   num = parseCell(img) takes an grayscale image matrix and 
    %   tries to return a corresponding number
    %
    %     Available properties are:
    %   
    %   *img - 2D grayscale matrix (Range of values: 0-255)
    %
    % Signature
    %   Author: Johannes, Martin, Kevin, Florian
    %   Date: 2012/12/17
    %   Copyright: 2012-2014, RWTH Aachen University
    
    properties
    end
    
    methods
                
        function number = parseCell(obj, img_matrix)      
        addpath('OCR');
        warning off
        imagen = mat2gray(img_matrix);
        % Convert to BW
        threshold = graythresh(imagen);
        imagen =~im2bw(imagen,threshold);
        % Remove all object containing fewer than 30 pixels
        imagen = bwareaopen(imagen,30);
        %Storage matrix word from image
        word=[ ];
        re=imagen;
        % Load templates
        load templates
        global templates
        % Compute the number of letters in template file
        num_letras=size(templates,2);
        while 1
            %Fcn 'lines' separate lines in text
            [fl re]=lines(re);
            imgn=fl;
            %-----------------------------------------------------------------     
            % Label and count connected components
            [L Ne] = bwlabel(imgn); 
            for n=1:Ne
                [r,c] = find(L==n);
                % Extract letter
                n1=imgn(min(r):max(r),min(c):max(c));  
                % Resize letter (same size of template)
                img_r=imresize(n1,[42 24]);
                %-------------------------------------------------------------------
                % Call fcn to convert image to text
                letter=read_letter(img_r,num_letras);
                % Letter concatenation
                word=[word letter];
            end
            display(word);
            %*When the sentences finish, breaks the loop
            if isempty(re)  %See variable 're' in Fcn 'lines'
                break
            end    
        end     
        end
        
    end
    
end

