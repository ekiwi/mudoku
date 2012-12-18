function [ out ] = ask(varargin)
    %ASK ask a question on the console
    %   you can specify if you want to ask a yes/no question
    %   or if you expect a formatted answer
    %   
    %   Arguments are as follows:
    %   question, intype, default
    %   
    %   possible intypes are: 'bool', 'str'
    %
    % Signature
    %   Author: Johannes, Martin, Kevin, Florian
    %   Date: 2012/12/17
    %   Copyright: 2012-2014, RWTH Aachen University

    out = false;
    if nargin > 0
        question =  varargin{1};

        % parse input type
        if nargin < 2
            intype = 'bool';
        else
            intype = varargin{2};
        end

        % read input
        switch intype
            case 'bool'
                if nargin > 2
                    s = input(sprintf('%s Y/N [%s]: ', question,...
                        varargin{3}), 's');
                else
                    s = input(sprintf('%s Y/N [N]: ', question), 's');
                end
            case 'str'
                if nargin > 2
                    s = input(sprintf('%s [%s]: ', question,...
                        varargin{3}), 's');
                else
                    s = input(sprintf('%s: ', question), 's');
                end
            otherwise
                error('Invalid intype "%s". Valid intypes are',...
                    '"bool" or "str"', intype);
        end % end switch intype

        % substitute default
        if isempty(s) && nargin > 2
            s = varargin{3};
        end

        % parse input
        switch intype
            case 'bool'
                if ~isempty(s) && (lower(s) == 'y' ||...
                    strcmp(lower(s), 'yes')  || strcmp(lower(s), 'true'))
                    out = true;
                else
                    out = false;
                end
            case 'str'
                if isempty(s)
                    out = '';
                else
                    out = s;
                end
            otherwise
                error('Invalid intype "%s". Valid intypes are',...
                    '"bool" or "str"', intype);
        end % end switch intype

end

