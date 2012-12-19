classdef GUIEnabledObject < handle
    %GUIENABLEDOBJECT All Objects that want to modify the GUI need to
    %inherit from this object
    %  
    
    properties (Access = 'private')
        guiHandles = 0;
        updateProgress_Handle = 0;
        showImage_Handle = 0;
        showSudoku_Handle = 0;
    end
    
    methods (Access = 'public')
        % connects Object to GUI
        % parameters are:
        %   * handles: GUI handles handle
        %   * updateprog: updateProgress(handles, step, progress) handle
        %   * showimg: showImage(handles, 2d_matrix) handle
        %   * showsudoku: showSudoku(hanles, 9x9_matrix) handle
        function connectGUI(obj, handles, updateprog, showimg, showsudoku)
            obj.guiHandles = handles;
            obj.updateProgress_Handle = updateprog;
            obj.showImage_Handle = showimg;
            obj.showSudoku_Handle = showsudoku;
        end
    end
    
    methods (Access = 'protected')
        function updateProgress(obj, step, progress)
            if obj.updateProgress_Handle == 0
                error('updateProgress handle not set. You need to call',...
                    'connectGUI first!');
            end
            obj.updateProgress_Handle(obj.guiHandles, step, progress);
        end

        function showImage(obj, image)
            if obj.updateProgress_Handle == 0
                error('updateProgress handle not set. You need to call',...
                    'connectGUI first!');
            end
            obj.showImage_Handle(obj.guiHandles, image);
        end

        function showSudoku(obj, sudoku)
            if obj.updateProgress_Handle == 0
                error('updateProgress handle not set. You need to call',...
                    'connectGUI first!');
            end
            obj.showSudoku_Handle(obj.guiHandles, sudoku);
        end
    end
    
end

