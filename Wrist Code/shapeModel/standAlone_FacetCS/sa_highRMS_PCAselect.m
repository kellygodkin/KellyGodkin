function varargout = sa_highRMS_PCAselect(varargin)
% SA_HIGHRMS_PCASELECT MATLAB code for sa_highRMS_PCAselect.fig
%      SA_HIGHRMS_PCASELECT, by itself, creates a new SA_HIGHRMS_PCASELECT or raises the existing
%      singleton*.
%
%      H = SA_HIGHRMS_PCASELECT returns the handle to a new SA_HIGHRMS_PCASELECT or the handle to
%      the existing singleton*.
%
%      SA_HIGHRMS_PCASELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SA_HIGHRMS_PCASELECT.M with the given input arguments.
%
%      SA_HIGHRMS_PCASELECT('Property','Value',...) creates a new SA_HIGHRMS_PCASELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sa_highRMS_PCAselect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sa_highRMS_PCAselect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sa_highRMS_PCAselect

% Last Modified by GUIDE v2.5 03-Nov-2021 15:50:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sa_highRMS_PCAselect_OpeningFcn, ...
                   'gui_OutputFcn',  @sa_highRMS_PCAselect_OutputFcn, ...
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


% --- Executes just before sa_highRMS_PCAselect is made visible.
function sa_highRMS_PCAselect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sa_highRMS_PCAselect (see VARARGIN)

%(con1(:,1:3)+1, pts_moved,pts_pca_moved,rms_fit1,rms_fit_pca);
con = varargin{1};
pts_inertia = varargin{2};
pts_pca = varargin{3};
rms_inertia = varargin{4};
rms_pca = varargin{5};

max_locs = varargin{6};
maxs(1,:) = pts_inertia(max_locs(1),:);
maxs(2,:) = pts_inertia(max_locs(2),:);

maxs(3,:) = pts_pca(max_locs(1),:);
maxs(4,:) = pts_pca(max_locs(2),:);

setappdata(gcf,'pts1',varargin{7});
setappdata(gcf,'pts_mm',varargin{8});
setappdata(gcf,'vec',varargin{9});


colsO = {'r','g','b'};

set(handles.inertiaRMS,'String',num2str(rms_inertia));
set(handles.pcaRMS,'String',num2str(rms_pca));

axes(handles.axes_inertial);
trisurf(con,pts_inertia(:,1),pts_inertia(:,2),pts_inertia(:,3));
 hold on
scatter3(maxs(1,1),maxs(1,2),maxs(1,3),100,'g','filled');
scatter3(maxs(2,1),maxs(2,2),maxs(2,3),100,'m','filled');
axis equal

% axes(handles.axes_pca);
% trisurf(con,pts_pca(:,1),pts_pca(:,2),pts_pca(:,3));
%  hold on
% scatter3(maxs(3,1),maxs(3,2),maxs(3,3),100,'g','filled');
% scatter3(maxs(4,1),maxs(4,2),maxs(4,3),100,'m','filled');
% axis equal

rotate3d on

  setappdata(gcf,'mode','pca');
  setappdata(gcf,'pts_pca',pts_pca);
  setappdata(gcf,'con',con);
  setappdata(gcf,'max_locs',max_locs);

% Choose default command line output for sa_highRMS_PCAselect
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
update_plot_PCA(handles);

% UIWAIT makes sa_highRMS_PCAselect wait for user response (see UIRESUME)
uiwait(handles.figure1);

function update_plot_PCA(handles)
    

    pts_pca = getappdata(gcf,'pts_pca');
    con = getappdata(gcf,'con');
    max_locs = getappdata(gcf,'max_locs');

    maxs(3,:) = pts_pca(max_locs(1),:);
    maxs(4,:) = pts_pca(max_locs(2),:);

    axes(handles.axes_pca);
    cla(handles.axes_pca);
    trisurf(con,pts_pca(:,1),pts_pca(:,2),pts_pca(:,3));
    hold on
    scatter3(maxs(3,1),maxs(3,2),maxs(3,3),100,'g','filled');
    scatter3(maxs(4,1),maxs(4,2),maxs(4,3),100,'m','filled');
    axis equal



% --- Outputs from this function are returned to the command line.
function varargout = sa_highRMS_PCAselect_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;
if isstruct(handles)== 0;
    varargout{1} = 1;
    varargout{2} = 1;
    varargout{3} = 1;
    close
else
    varargout{1} = getappdata(gcf,'status');
    switch getappdata(gcf,'status');
        case 'ok'
            varargout{2} = getappdata(gcf,'mode');
            varargout{3} = getappdata(gcf,'vec');
            
            close
        case 'cancel'
            varargout{2} = 1;
            varargout{3} = 1;
            close
        otherwise
            uiwait(handles.figure1);
    end
end



% --- Executes on button press in ok_pb.
function ok_pb_Callback(hObject, eventdata, handles)
% hObject    handle to ok_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(gcf,'status','ok');
uiresume(gcf);

% --- Executes on button press in cancel_pb.
function cancel_pb_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(gcf,'status','cancel');
uiresume(gcf);

% --- Executes on button press in inertia_rb.
function inertia_rb_Callback(hObject, eventdata, handles)
% hObject    handle to inertia_rb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of inertia_rb
if get(hObject,'Value')
    setappdata(gcf,'mode','inertia');
end
    

% --- Executes on button press in pca_rb.
function pca_rb_Callback(hObject, eventdata, handles)
% hObject    handle to pca_rb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    setappdata(gcf,'mode','pca');
end
% Hint: get(hObject,'Value') returns toggle state of pca_rb










function inertiaRMS_Callback(hObject, eventdata, handles)
% hObject    handle to inertiaRMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inertiaRMS as text
%        str2double(get(hObject,'String')) returns contents of inertiaRMS as a double


% --- Executes during object creation, after setting all properties.
function inertiaRMS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inertiaRMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pcaRMS_Callback(hObject, eventdata, handles)
% hObject    handle to pcaRMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pcaRMS as text
%        str2double(get(hObject,'String')) returns contents of pcaRMS as a double


% --- Executes during object creation, after setting all properties.
function pcaRMS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pcaRMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hide_PCA_flip_panel.
function hide_PCA_flip_panel_Callback(hObject, eventdata, handles)
% hObject    handle to hide_PCA_flip_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.PCA_flip_panel,'Visible','off');


% --- Executes on button press in show_PCA_flip_panel.
function show_PCA_flip_panel_Callback(hObject, eventdata, handles)
% hObject    handle to show_PCA_flip_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.PCA_flip_panel,'Visible','on');


% --- Executes on button press in swapXY.
function swapXY_Callback(hObject, eventdata, handles)
% hObject    handle to swapXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vec = getappdata(gcf, 'vec');
temp1 = vec(:,1) ;
vec(:,1) = vec(:,2);
vec(:,2) = temp1;
recalcPtsMove(handles, vec);

setappdata(gcf,'vec',vec);

guidata(hObject, handles);
update_plot_PCA(handles);

% --- Executes on button press in negX.
function negX_Callback(hObject, eventdata, handles)
% hObject    handle to negX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vec = getappdata(gcf, 'vec');
vec(:,1) = vec(:,1) *-1;
recalcPtsMove(handles, vec);

setappdata(gcf,'vec',vec);

guidata(hObject, handles);
update_plot_PCA(handles);


% --- Executes on button press in negY.
function negY_Callback(hObject, eventdata, handles)
% hObject    handle to negY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vec = getappdata(gcf, 'vec');
vec(:,2) = vec(:,2) *-1;
recalcPtsMove(handles, vec);


setappdata(gcf,'vec',vec);

guidata(hObject, handles);
update_plot_PCA(handles);




function recalcPtsMove(handles, vec)

pts_mm = getappdata(gcf,'pts_mm');
pts1 = getappdata(gcf, 'pts1');


Tpca = RT_to_fX4(vec, pts_mm);
T_pca_inv = transposefX4(Tpca);

for i = 1:length(pts1)
    pts_pca_moved(i,:) = (T_pca_inv(1:3,1:3) * pts1(i,:)' + T_pca_inv(1:3,4))';
end %i
    pts_moved_pca_cent = [mean(pts_pca_moved(:,1)) mean(pts_pca_moved(:,2)) mean(pts_pca_moved(:,3))];
    
    %fit 5th order surface to points.. same number points, but conform to M
    fit_order = 5;
    M = polyfitn(pts_pca_moved(:,1:2),pts_pca_moved(:,3), fit_order);
    
    %compute Z value for x & y using surface equation
    Z_fit_pca =  polyvaln(M, [pts_pca_moved(:,1) pts_pca_moved(:,2)]);
    pts_out_pca = [pts_pca_moved(:,1:2) Z_fit_pca];
    %compute RMS values and get r-square
    rms_fit_pca = rms(pts_out_pca(:,3) - pts_pca_moved(:,3));
    
    
    set(handles.pcaRMS,'String',num2str(rms_fit_pca));
    setappdata(gcf,'pts_pca',pts_pca_moved);
    
    
    
    
    


% --- Executes on button press in negZ.
function negZ_Callback(hObject, eventdata, handles)
% hObject    handle to negZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vec = getappdata(gcf, 'vec');
vec(:,3) = vec(:,3) *-1;
recalcPtsMove(handles, vec);


setappdata(gcf,'vec',vec);
guidata(hObject, handles);
update_plot_PCA(handles);