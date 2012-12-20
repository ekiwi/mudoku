classdef GUIEnabledObject < handle
    %GUIENABLEDOBJECT All Objects that want to modify the GUI need to
    %inherit from this object
    %  
    
    properties (Access = 'private')
        guiHandles = 0;
        showProgress_Handle = 0;
        showImage_Handle = 0;
        showSudoku_Handle = 0;
    end
    
    methods (Access = 'public')
        % connects Object to GUI
        % parameters are:
        %   * handles: GUI handles handle they need to contain handles to
        %              the following functions:
        %   * showeProgress(handles, step, progress) handle
        %   * showImage(handles, 2d_matrix, min, max) handle
        %   * showSudoku(hanles, 9x9_matrix) handle
        function connectGUI(obj, handles)
            obj.guiHandles = handles;
            obj.showProgress_Handle = handles.showProgress;
            obj.showImage_Handle = handles.showImage;
            obj.showSudoku_Handle = handles.showSudoku;
        end
    end
    
    methods (Access = 'public')
        function showProgress(obj, step, progress)
            if ~isa(obj.showProgress_Handle, 'function_handle')
                error('updateProgress handle not set. You need to call connectGUI first!');
            end
            obj.showProgress_Handle(obj.guiHandles, step, progress);
        end

        function showImage(obj, image, min, max)
            if ~isa(obj.showImage_Handle, 'function_handle')
                error('updateProgress handle not set. You need to call connectGUI first!');
            end
            obj.showImage_Handle(obj.guiHandles, image, min, max);
        end

        function showSudoku(obj, sudoku)
            if ~isa(obj.showSudoku_Handle, 'function_handle')
                error('updateProgress handle not set. You need to call connectGUI first!');
            end
            obj.showSudoku_Handle(obj.guiHandles, sudoku);
        end
    end
    
end

