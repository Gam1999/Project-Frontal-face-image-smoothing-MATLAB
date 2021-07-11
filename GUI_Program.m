function varargout = GUI_Program(varargin)
% GUI_PROGRAM MATLAB code for GUI_Program.fig
%      GUI_PROGRAM, by itself, creates a new GUI_PROGRAM or raises the existing
%      singleton*.
%
%      H = GUI_PROGRAM returns the handle to a new GUI_PROGRAM or the handle to
%      the existing singleton*.
%
%      GUI_PROGRAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PROGRAM.M with the given input arguments.
%
%      GUI_PROGRAM('Property','Value',...) creates a new GUI_PROGRAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Program_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Program_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Program

% Last Modified by GUIDE v2.5 14-Feb-2021 14:17:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Program_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Program_OutputFcn, ...
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


% --- Executes just before GUI_Program is made visible.
function GUI_Program_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Program (see VARARGIN)

% Choose default command line output for GUI_Program
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Program wait for user response (see UIRESUME)
% uiwait(handles.figure1);
pic = 255.*ones(100,100,3);
%pic = uint8(pic);
image(pic,'Parent',handles.axes1);
image(pic,'Parent',handles.axes2);
%axis off

% --- Outputs from this function are returned to the command line.
function varargout = GUI_Program_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function tbLoc_Callback(hObject, eventdata, handles)
% hObject    handle to tbLoc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbLoc as text
%        str2double(get(hObject,'String')) returns contents of tbLoc as a double


% --- Executes during object creation, after setting all properties.
function tbLoc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbLoc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pt] = uigetfile({'*.png','PNG';'*.jpg','JPG';'*.jpeg','JPEG'},'Select image');
if(isequal(fn,0))
    return;
end
ffn = fullfile(pt,fn);
set(handles.tbLoc,'string',ffn);
pic = imread(ffn);
%imwrite(pic,'F1.jpg');
imshow(pic,'Parent',handles.axes1);
set(handles.Browse,'userdata',1);
set(handles.axes1,'userdata',pic);


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)gry = rgb2gray(pic);
[fn,pt] = uiputfile({'*.png','PNG';'*.jpg','JPG'});
if(isequal(fn,0))
    return;
end

v1 = get(handles.Browse,'userdata');
if(v1>0)
    %User select sigle file
    pic = get(handles.axes2,'userdata');
    ffn = fullfile(pt,fn);
    imwrite(pic,ffn);
end


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pic = get(handles.axes1,'userdata');
inpainting_mask =inpaint_mask(pic);
imshow(inpainting_mask,'Parent',handles.axes2);
set(handles.axes2,'userdata',inpainting_mask);
