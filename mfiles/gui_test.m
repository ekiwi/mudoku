%% Test GUI Functionality
%

hObject = MainGUI;
data = guidata(hObject);
a = GUIEnabledObject;
a.connectGUI(data);
a