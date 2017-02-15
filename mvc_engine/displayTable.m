function varargout = displayTable(varargin)
% DISPLAYTABLE MATLAB code for displayTable.fig
%      DISPLAYTABLE, by itself, creates a new DISPLAYTABLE or raises the existing
%      singleton*.
%
%      H = DISPLAYTABLE returns the handle to a new DISPLAYTABLE or the handle to
%      the existing singleton*.
%
%      DISPLAYTABLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAYTABLE.M with the given input arguments.
%
%      DISPLAYTABLE('Property','Value',...) creates a new DISPLAYTABLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before displayTable_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to displayTable_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help displayTable

% Last Modified by GUIDE v2.5 29-Jun-2015 15:43:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @displayTable_OpeningFcn, ...
                   'gui_OutputFcn',  @displayTable_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before displayTable is made visible.
function displayTable_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to displayTable (see VARARGIN)

% Choose default command line output for displayTable
handles.output = hObject;

% get handle to the controller
for i = 1:2:length(varargin)
    switch varargin{i}
        case 'controller'
            handles.controller = varargin{i+1};
        otherwise
            error('unknown input')
    end
end

string = cellstr(get(handles.listbox2, 'String'));
set(handles.listbox2, 'String', string);
% set(handles.phasegroup, 'SelectedObject', handles.english);


set(handles.phasegroup, 'SelectedObject', handles.liquid);
% set(handles.phasegroup, 'SelectedObject', handles.vapor);
% set(handles.text4, 'String', 'lb/cu.in');
% set(handles.text5, 'String', 'cu.in');
% set(handles.text6, 'String', 'lb');
% set(handles.listbox2, 'String', 0);
% set(handles.text1, 'String', 0);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes displayTable wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = displayTable_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.controller.setPushbutton1()



% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
if get(handles.liquid,'Value') == true
    phase = 'liquid';
else
    phase = 'vapor';
end
handles.controller.setPhase(phase)


contents = cellstr(get(hObject,'String'));
thermoPkg = contents{get(hObject,'Value')};
handles.controller.setThermoPkg(thermoPkg)

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% axes(handles.axes1);
% cla;
popup_sel_index = get(handles.popupmenu1, 'Value');
handles.controller.setPlot(popup_sel_index)


% --- Executes on button press in liquid.
% function liquid_Callback(hObject, eventdata, handles)
% hObject    handle to liquid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of liquid


% --- Executes during object creation, after setting all properties.
function phasegroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phasegroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in phasegroup.
function phasegroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in phasegroup 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.liquid,'Value') == true
    phase = 'liquid';
else
    phase = 'vapor';
end
handles.controller.setPhase(phase)


% --- Executes on button press in liquid.
function liquid_Callback(hObject, eventdata, handles)
% hObject    handle to liquid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a= 1;
% Hint: get(hObject,'Value') returns toggle state of liquid
phase = 'liquid';

handles.controller.setPhase(phase)


% --- Executes on button press in clearplot.
function clearplot_Callback(hObject, eventdata, handles)
% hObject    handle to clearplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% axes(handles.axes1);
% cla;
handles.controller.clearPlot();


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.controller.CreateTable();


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.controller.updateInputData();


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.controller.getXMLpipe();
