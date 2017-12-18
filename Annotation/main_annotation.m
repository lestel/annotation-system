function varargout = main_annotation(varargin)
% MAIN_ANNOTATION MATLAB code for main_annotation.fig
%      MAIN_ANNOTATION, by itself, creates a new MAIN_ANNOTATION or raises the existing
%      singleton*.
%
%      H = MAIN_ANNOTATION returns the handle to a new MAIN_ANNOTATION or the handle to
%      the existing singleton*.
%
%      MAIN_ANNOTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_ANNOTATION.M with the given input arguments.
%
%      MAIN_ANNOTATION('Property','Value',...) creates a new MAIN_ANNOTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_annotation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_annotation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_annotation

% Last Modified by GUIDE v2.5 21-Mar-2017 12:55:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_annotation_OpeningFcn, ...
                   'gui_OutputFcn',  @main_annotation_OutputFcn, ...
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
%'study_sample-787','exam1-500','exam2-500','exam3-500','exam4-500','exam5-500','exam6-500'};

% --- Executes just before main_annotation is made visible.
function main_annotation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_annotation (see VARARGIN)

% Choose default command line output for main_annotation

%cheating
%set(handles.zb,'Visible','on');
handles.cheat=3.1;

handles.output = hObject;
handles.data_name='HOGandlabel.mat';
load(handles.data_name);
%% AD
options = [];
options.KernelType = 'Gaussian';
options.t = 0.5;
options.ReguBeta = 100;
%% AL
option.choose_strategies=8;
option.fuision_strategies=1;
option.fuision_array=1;
handles.option=option;
%% initial batch
IN=16;
[smpRank1,~] = MAED(f_hog,IN,options);
smpRank=f_label(smpRank1);
pos1_num=length(find(smpRank==1));
posn1_num=length(find(smpRank==-1));
pos0_num=length(find(smpRank==0));
while(pos0_num<2||posn1_num<2||pos1_num<4)
IN=IN+1;   
[smpRank,~] = MAED(f_hog,IN,options);
end
pos1=find(smpRank==1);
posn1=find(smpRank==-1);
pos0=find(smpRank==0);
stand.maed=smpRank1([pos1(1:4);posn1(1:2);pos0(1:2)]);
tmp=randperm(length(f_label));
stand.random=tmp(1:length(stand.maed))';


I=imread('cover1.png');
axes(handles.axes1);
imshow(I);
handles.stand=stand;
set(handles.pushbutton_hint,'Enable','off');
set(handles.slider_pic,'Enable','off');
set(handles.uipanel_MODE,'Visible','off');
set(handles.uipanel_label,'Visible','off');
set(handles.uipanel_help,'Visible','off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main_annotation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_annotation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_pic_Callback(hObject, eventdata, handles)
% hObject    handle to slider_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

study_serials=getappdata(handles.popupmenu, 'study_serials');
strPath=getappdata(handles.start, 'strPath_Data');
mode_choose=getappdata(handles.slider_pic,'mode_choose');
data_name=handles.data_name;

latiao_value=get(hObject, 'value');
setappdata(handles.slider_pic, 'latiao_value',latiao_value);

if mode_choose==1

    
elseif mode_choose==2 %%review
    pos=study_serials(ceil(latiao_value+1));
    [I,I_serials,I_name,~,I_label_str]=display_image(data_name,strPath,study_serials,pos);
    if handles.cheat==3.1415926
    load(data_name);set(handles.zb,'string',[f_name{pos},' = ',num2str(f_label(pos))]);
    end
    axes(handles.axes1);
    imshow(I,[0,255]);
    
    set(handles.edit_guess,'string','NO NEED','Enable','off');
    set(handles.edit_pic_serial,'string',I_serials,'Enable','on');
    set(handles.edit_label,'string',I_label_str,'Enable','on');
    set(handles.edit_name,'string',I_name,'Enable','on');

else
    user_label_record=getappdata(handles.pushbutton_SR,'user_label_record');
    study_serials_serial=getappdata(handles.pushbutton_SR,'study_serials_serial');
    pos=study_serials(study_serials_serial(1,ceil(latiao_value+1)));
    [I,I_serials,~,~,~]=display_image(data_name,strPath,study_serials,pos);
    if handles.cheat==3.1415926
    load(data_name);set(handles.zb,'string',[f_name{pos},' = ',num2str(f_label(pos))]);
    end
    axes(handles.axes1);
    imshow(I,[0,255]);
    
       user_label=user_label_record(study_serials_serial(1,ceil(latiao_value+1)));
    if isnan(user_label)==1
       set(handles.edit_guess,'string','START','Enable','on');  %猜测
    else
        if user_label==-1
        set(handles.edit_guess,'string','？','Enable','on');  %猜测
        elseif user_label==1
        set(handles.edit_guess,'string','Guess:not mass','Enable','on');  %猜测
    
        elseif user_label==0
        set(handles.edit_guess,'string','Guess:mass','Enable','on');  %猜测
        end
    end
    set(handles.edit_pic_serial,'string',I_serials,'Enable','on');  %
    set(handles.edit_label,'string','Hidden','Enable','off');
 end


set(handles.uipanel_help,'Visible','off');
guidata(hObject, handles);











% --- Executes during object creation, after setting all properties.
function slider_pic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data_name=handles.data_name;

name = inputdlg('please input your username:','Input Username');
if isempty(name)==1
    return
else
while (isempty(str2num(name{1,1}))==0)
name = inputdlg('please input your username:','Input Username');
end
load('database.mat');
if isfield(data,name{1,1})==1  %%老用户
eval(['userdata=data.',name{1,1},';']);    
str1='welcome back';
str2=name{1,1};
if isempty(userdata.result{1,1})==0
str3=['your best common test accuarcy is: ',num2str(userdata.result{1,1}.totall_acc)];
else
str3=['your best common test accuarcy is none'];
end
if isempty(userdata.result{1,2})==0
str4=['your best AL test accuarcy is: ',num2str(userdata.result{1,2}.totall_acc)];
else
str4=['your best AL test accuarcy is none'];
end    
str={str1;'============';str2;'============';str3;'============';str4};

else                           %%新用户
button=questdlg('Are you new user','question','Yes','No','Yes');
      if strcmp(button,'Yes')
         str1='welcome first use';
         str2=name{1,1};
         str={str1;'============';str2};
         load(data_name);
         sample_num=size(f_hog,1);
         pppp=randperm(sample_num);
         tmp.serials={pppp(1:787),pppp(788:1287),pppp(1288:1787),pppp(1788:2287),pppp(2288:2787),pppp(2788:3287),pppp(3288:3787)};
         result{1,1}=[];
         result{1,2}=[];
         result{1,3}=[];
         result{1,4}=[];
         result{1,5}=[];
         result{1,6}=[];
         tmp.result=result;
         eval(['data.',name{1,1},'=tmp;']);
         save('.\data\database.mat','data')
      else
         errordlg('I can not find your record');
         return
      end
    
end
handles.usename=name;
eval(['userdata=data.',name{1,1},';']);
strPath='.\data\all';
all_serials=userdata.serials;


I=imread('cover2.jpg');
axes(handles.axes1);
imshow(I);

%{
pic_num=length(serials);
serials_serials=1;
index=serials_serials;
I=imread(fullfile(strPath,Pname{1,serials_serials}));
I_label=f_label(serials(serials_serials));
str_label=label_invert_str(I_label);
axes(handles.axes1);
imshow(I,[0,255]);
%}

set(handles.edit_user,'string',str);
set(handles.edit_label,'string','COVER');
%set(handles.edit_label,'string',str_label);

set(handles.uipanel_MODE,'Visible','on');
set(handles.popupmenu,'String','Mode Choose');
popupmenu_str='please choose mode|Review Mode|Test Mode|Test Mode with AL|Exam Mode with nothing|Exam Mode with AL|Exam Mode with MD|Exam Mode with AL and MD';
set(handles.popupmenu,'String',popupmenu_str);

set(handles.edit_guess,'string','GUESS','Enable','off');
set(handles.edit_pic_serial,'string','','Enable','off');
set(handles.edit_label,'string','LABEL','Enable','off');
set(handles.edit_name,'string','name of the image','Enable','off');
set(handles.uipanel_label,'Visible','off');
set(handles.popupmenu,'Enable','on');
set(handles.uipanel_help,'Visible','off');





setappdata(hObject, 'all_serials_Data',all_serials);
setappdata(hObject, 'strPath_Data', strPath);%%保存路径数据包

set(handles.slider_pic,'Enable','off');
end



guidata(hObject, handles);


function edit_user_Callback(hObject, eventdata, handles)
% hObject    handle to edit_user (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_user as text
%        str2double(get(hObject,'String')) returns contents of edit_user as a double


% --- Executes during object creation, after setting all properties.
function edit_user_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_user (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_label_Callback(hObject, eventdata, handles)
% hObject    handle to edit_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_label as text
%        str2double(get(hObject,'String')) returns contents of edit_label as a double


% --- Executes during object creation, after setting all properties.
function edit_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_guess_Callback(hObject, eventdata, handles)
% hObject    handle to edit_guess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_guess as text
%        str2double(get(hObject,'String')) returns contents of edit_guess as a double


% --- Executes during object creation, after setting all properties.
function edit_guess_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_guess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_SR.
function pushbutton_SR_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_SR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mode_choose=getappdata(handles.slider_pic,'mode_choose');

latiao_value=getappdata(handles.slider_pic, 'latiao_value');
user_label_record=getappdata(handles.pushbutton_SR,'user_label_record');
study_serials_serial=getappdata(handles.pushbutton_SR,'study_serials_serial');
strPath=getappdata(handles.start, 'strPath_Data');
user_choose_label=getappdata(handles.pushbutton_SR,'user_choose_label');
tString=[get(handles.radiobutton_notmass,'Value'),get(handles.radiobutton_mass,'Value'),get(handles.radiobutton_idnk,'Value')];
tSP=find(tString==1);
switch tSP
    case 1
         user_choose_label=1;
         user_label_record(1,study_serials_serial(ceil(latiao_value+1)))=user_choose_label;
         set(handles.edit_guess,'string','Guess:not mass','Enable','on');
    case 2
         user_choose_label=0;
         user_label_record(1,study_serials_serial(ceil(latiao_value+1)))=user_choose_label;
         set(handles.edit_guess,'string','Guess:mass','Enable','on');

    case 3
         user_choose_label=-1;
         user_label_record(1,study_serials_serial(ceil(latiao_value+1)))=user_choose_label;
         set(handles.edit_guess,'string','？','Enable','on');

end

setappdata(handles.pushbutton_SR,'user_label_record',user_label_record);

study_serials=getappdata(handles.popupmenu, 'study_serials');
%%



if mode_choose~=5&&mode_choose~=6&&mode_choose~=7&&mode_choose~=8
set(handles.pushbutton_upload,'Enable','on');
end




%%

if length(study_serials_serial)<length(study_serials)
pause(0.3);    
data_name=handles.data_name;
option=handles.option;
if mode_choose==3||mode_choose==5||mode_choose==7
option.choose_strategies=1;
end
stand=handles.stand;
initial_serials=stand.maed';

[one_serials,study_serials_serial,user_label_record]=find_next_annotation(data_name,study_serials,initial_serials,study_serials_serial,user_label_record,option,1);

pos=one_serials;
[I,I_serials,~,~,~]=display_image(data_name,strPath,study_serials,pos);
    if handles.cheat==3.1415926
    load(data_name);set(handles.zb,'string',[f_name{pos},' = ',num2str(f_label(pos))]);
    end
axes(handles.axes1);
imshow(I,[0,255]);   
   
Pnum=length(study_serials_serial)-1;
minPnum=1/Pnum;
if (10/Pnum)>1
   maxPnum=1/Pnum;
else
   maxPnum=10/Pnum;  
end
   
latiao_value=0;
setappdata(handles.slider_pic, 'latiao_value',latiao_value);
set(handles.slider_pic,'Enable','on');
if Pnum>=1
    
set(handles.slider_pic,'Max',Pnum,'Min',0,'sliderstep',[minPnum,maxPnum],'Value',latiao_value);
else
set(handles.slider_pic,'Enable','off','Value',latiao_value);
end
set(handles.edit_guess,'string','START','Enable','on');  %猜测
set(handles.edit_pic_serial,'string',I_serials,'Enable','on');  %
set(handles.edit_label,'string','Hidden','Enable','off');
    
set(handles.uipanel_label,'Visible','on');
set(handles.popupmenu,'Enable','off');
set(handles.edit_user,'string','');
set(handles.uipanel_help,'Visible','off');
   
setappdata(handles.pushbutton_SR,'user_label_record',user_label_record);
user_choose_label=-1;
setappdata(handles.radiobutton_idnk,'value',1);
setappdata(handles.pushbutton_SR,'user_choose_label',user_choose_label);
setappdata(handles.pushbutton_SR,'study_serials_serial',study_serials_serial);
else
set(handles.pushbutton_upload,'Enable','on');
    
end
  









guidata(hObject, handles);



% --- Executes on button press in pushbutton_upload.
function pushbutton_upload_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_upload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
user_label_record=getappdata(handles.pushbutton_SR,'user_label_record');
study_serials_serial=getappdata(handles.pushbutton_SR,'study_serials_serial');

study_serials=getappdata(handles.popupmenu, 'study_serials');
all_serials=getappdata(handles.start, 'all_serials_Data');
test_serials=all_serials{1,1};

mode_choose=getappdata(handles.slider_pic,'mode_choose');
start_time=getappdata(handles.pushbutton_upload,'start_time');


data_name=handles.data_name;
load(data_name);
mat=[(1:size(f_hog,1))',f_label,f_hog];
if mode_choose==3||mode_choose==4
axes(handles.axes1);
[test_record,~,~,~,~,~,~,report]=evaluate_label_result(mat,mode_choose,study_serials,study_serials_serial,test_serials,user_label_record,start_time,2,5,0);
set(handles.edit_user,'string',report);
else
[test_record,~,~,~,~,~,~,~]=evaluate_label_result(mat,mode_choose,study_serials,study_serials_serial,test_serials,user_label_record,start_time,2,5,0);
axes(handles.axes1);
I=imread('cover3.jpg');
imshow(I);
report='Thank you for finishing this part of exam';
set(handles.edit_user,'string',report);

end

name=handles.usename;
load('database.mat');
eval(['TMP=data.',name{1,1},'.result{1,',num2str(test_record.mode_pos),'};']);
button=questdlg('Do you want save result','question','Yes','No','Yes');
if (isempty(TMP)==1||TMP.totall_acc<test_record.totall_acc)&&(strcmp(button,'Yes'))

eval(['data.',name{1,1},'.result{1,',num2str(test_record.mode_pos),'}=test_record;']);
save('.\data\database.mat','data')
end
set(handles.popupmenu,'Enable','on');
guidata(hObject, handles);

function edit_hint_Callback(hObject, eventdata, handles)
% hObject    handle to edit_hint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_hint as text
%        str2double(get(hObject,'String')) returns contents of edit_hint as a double


% --- Executes during object creation, after setting all properties.
function edit_hint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_hint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pic_serial_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pic_serial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pic_serial as text
%        str2double(get(hObject,'String')) returns contents of edit_pic_serial as a double


% --- Executes during object creation, after setting all properties.
function edit_pic_serial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pic_serial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu.
function popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu
%% 导入初始消息
all_serials=getappdata(handles.start, 'all_serials_Data');
strPath=getappdata(handles.start, 'strPath_Data');
mode_choose=get(hObject, 'value');
setappdata(handles.slider_pic,'mode_choose',mode_choose);
data_name=handles.data_name;

%% 获取当前研究的序列
switch mode_choose
   
case 1  %% cover   
    set(handles.pushbutton_hint,'Enable','off');

case 2  %% review
    group_num=1;
    pic_num=length(all_serials{1,group_num});
    order=1:pic_num;
    study_serials=all_serials{1,group_num}(order);
    setappdata(handles.popupmenu, 'study_serials',study_serials);
    set(handles.pushbutton_hint,'Enable','on');

case 3  %% test1
    group_num=1;
    pic_num=length(all_serials{1,group_num});
    order=1:pic_num;
    option=handles.option;
    option.choose_strategies=1;
    study_serials=all_serials{1,group_num}(order);
    setappdata(handles.popupmenu, 'study_serials',study_serials);
    set(handles.pushbutton_hint,'Enable','on');

case 4  %% test2 AL
    group_num=1;
    pic_num=length(all_serials{1,group_num});
    order=1:pic_num;
    option=handles.option;
    study_serials=all_serials{1,group_num}(order);
    setappdata(handles.popupmenu, 'study_serials',study_serials);
    set(handles.pushbutton_hint,'Enable','on');

case 5  %% ex1 nothing
    group_num=2;
    pic_num=length(all_serials{1,group_num});
    order=1:pic_num;
    option=handles.option;
    option.choose_strategies=1;
    study_serials=all_serials{1,group_num}(order);
    setappdata(handles.popupmenu, 'study_serials',study_serials);
    set(handles.pushbutton_hint,'Enable','off');

case 6  %% ex2 AL
    group_num=3;
    pic_num=length(all_serials{1,group_num});
    order=1:pic_num;
    option=handles.option;
    study_serials=all_serials{1,group_num}(order);
    setappdata(handles.popupmenu, 'study_serials',study_serials); 
    set(handles.pushbutton_hint,'Enable','off');

case 7  %% ex3 AD
    group_num=4;
    pic_num=length(all_serials{1,group_num});
    order=1:pic_num;
    option=handles.option;
    option.choose_strategies=1;

    study_serials=all_serials{1,group_num}(order);
    setappdata(handles.popupmenu, 'study_serials',study_serials);   
    set(handles.pushbutton_hint,'Enable','on');

case 8  %% ex4 ALAD
    group_num=5;
    pic_num=length(all_serials{1,group_num});
    order=1:pic_num;
    option=handles.option;
    study_serials=all_serials{1,group_num}(order);
    setappdata(handles.popupmenu, 'study_serials',study_serials);    
    set(handles.pushbutton_hint,'Enable','on');
   
    
    
    
    
    
    
    
    
end
%% 显示与按钮调整

if mode_choose==1  %% cover
   I=imread('cover2.jpg');
   axes(handles.axes1);
   imshow(I);
   
   set(handles.edit_guess,'string','GUESS','Enable','off');
   set(handles.edit_pic_serial,'string','','Enable','off');
   set(handles.edit_label,'string','LABEL','Enable','off');
   set(handles.edit_name,'string','name of the image','Enable','off');
   set(handles.slider_pic,'Enable','off');  
   set(handles.uipanel_label,'Visible','off');
   set(handles.uipanel_help,'Visible','off');
   set(handles.edit_user,'string','');
   
elseif mode_choose==2 %% review
    
    latiao_value=0;
    setappdata(handles.slider_pic, 'latiao_value',latiao_value);
    pos=study_serials(ceil(latiao_value+1));
    [I,I_serials,I_name,~,I_label_str]=display_image(data_name,strPath,study_serials,pos);
    if handles.cheat==3.1415926
    load(data_name);set(handles.zb,'string',[f_name{pos},' = ',num2str(f_label(pos))]);
    end
    axes(handles.axes1);
    imshow(I,[0,255]);
    
    set(handles.edit_guess,'string','NO NEED','Enable','off');
    set(handles.edit_pic_serial,'string',I_serials,'Enable','on');
    set(handles.edit_label,'string',I_label_str,'Enable','on');
    set(handles.edit_name,'string',I_name,'Enable','on');
    
    set(handles.slider_pic,'Enable','on');
    set(handles.slider_pic,'Max',pic_num-1,'Min',0,'sliderstep',[1/(pic_num-1),10/(pic_num-1)],'Value',latiao_value);
    
    set(handles.uipanel_label,'Visible','off');
    set(handles.uipanel_help,'Visible','off');

    set(handles.edit_user,'string','');
   
else  %% test1 
   project={'Test with Nothing','Test with Active Learning','Exam with Nothing','Exam with Active Learning','Exam with Mislabeled Detection','Exam with Active Learning and Mislabeled Detection'};
   TIT=['Are you prepare to do a ',project{1,mode_choose-2}];
   button=questdlg(TIT,'question','Yes','No','Yes');
   if strcmp(button,'No')
      return
   else
   %% 初始化    
   set(handles.pushbutton_upload,'Enable','off');

   stand=handles.stand;

   initial_serials=stand.maed';
   study_serials_serial=[];
   user_label_record=nan(1,length(study_serials));
   
   [one_serials,study_serials_serial,user_label_record]=find_next_annotation(data_name,study_serials,initial_serials,study_serials_serial,user_label_record,option,1);
    

   
   pos=one_serials;
   [I,I_serials,~,~,~]=display_image(data_name,strPath,study_serials,pos);
    if handles.cheat==3.1415926
    load(data_name);set(handles.zb,'string',[f_name{pos},' = ',num2str(f_label(pos))]);
    end
   axes(handles.axes1);
   imshow(I,[0,255]);   
   
   Pnum=length(study_serials_serial)-1;
   minPnum=1/Pnum;
   if (10/Pnum)>1
   maxPnum=1/Pnum;
   else
   maxPnum=10/Pnum;  
   end
   
   latiao_value=0;
   setappdata(handles.slider_pic, 'latiao_value',latiao_value);
   set(handles.slider_pic,'Enable','on');
   if Pnum>=1
   set(handles.slider_pic,'Max',Pnum,'Min',0,'sliderstep',[minPnum,maxPnum],'Value',latiao_value);
   else
   set(handles.slider_pic,'Enable','off','Value',latiao_value);
   end
   set(handles.edit_guess,'string','START','Enable','on');  %猜测
   set(handles.edit_pic_serial,'string',I_serials,'Enable','on');  %
   set(handles.edit_label,'string','Hidden','Enable','off');
   set(handles.edit_name,'string',project{1,mode_choose-2},'Enable','on');
   set(handles.uipanel_label,'Visible','on');
   set(handles.popupmenu,'Enable','off');
   set(handles.edit_user,'string','');
   set(handles.uipanel_help,'Visible','off');
   
   setappdata(handles.pushbutton_SR,'user_label_record',user_label_record);
   user_choose_label=-1;
   setappdata(handles.radiobutton_idnk,'value',1);
   setappdata(handles.pushbutton_SR,'user_choose_label',user_choose_label);
   setappdata(handles.pushbutton_SR,'study_serials_serial',study_serials_serial);
   
   start_time=clock;
   setappdata(handles.pushbutton_upload,'start_time',start_time);
    
   end

end











guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_name_Callback(hObject, eventdata, ~)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_name as text
%        str2double(get(hObject,'String')) returns contents of edit_name as a double


% --- Executes during object creation, after setting all properties.
function edit_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit_guess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_guess as text
%        str2double(get(hObject,'String')) returns contents of edit_guess as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_guess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel_group.
function uipanel_group_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_group 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)





guidata(hObject, handles);


% --- Executes on button press in pushbutton_hint.
function pushbutton_hint_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_hint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel_help,'Visible','on');
stand=handles.stand;
data_name=handles.data_name;
load(data_name);
latiao_value=getappdata(handles.slider_pic, 'latiao_value');
str_tmp=['of ',num2str(ceil(latiao_value+1)),' image'];
set(handles.edit_hint_serial,'string',str_tmp);
study_serials=getappdata(handles.popupmenu, 'study_serials');
mode_choose=getappdata(handles.slider_pic,'mode_choose');
if mode_choose==3
user_label_record=getappdata(handles.pushbutton_SR,'user_label_record');
elseif mode_choose==2
user_label_record=(f_label(study_serials))';
else
user_label_record=getappdata(handles.pushbutton_SR,'user_label_record');

end
strPath=getappdata(handles.start, 'strPath_Data');



[I1,I2,I3,I4,str_3nn]=give_hint_3nn(f_hog,f_name,f_label,strPath,study_serials,user_label_record,latiao_value,stand.maed);
str_svm=give_hint_svm(f_hog,f_label,study_serials,user_label_record,latiao_value,stand.maed);
str_cl=give_hint_clstability(f_hog,f_label,study_serials,user_label_record,latiao_value,stand.maed);
str_all={'Hints are as following:';'============';str_3nn;'============';str_svm;'============';str_cl};
set(handles.edit_hint,'string',str_all);

axes(handles.axes2);
imshow(I1.pic);title(I1.name);  
axes(handles.axes3);
imshow(I2.pic);title(I2.name);
axes(handles.axes4);
imshow(I3.pic);title(I3.name)
axes(handles.axes5);
imshow(I4.pic);title(I4.name);
guidata(hObject, handles);



function edit_hint_serial_Callback(hObject, eventdata, handles)
% hObject    handle to edit_hint_serial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_hint_serial as text
%        str2double(get(hObject,'String')) returns contents of edit_hint_serial as a double


% --- Executes during object creation, after setting all properties.
function edit_hint_serial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_hint_serial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_fu.
function pushbutton_fu_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_fu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
user_label_record=getappdata(handles.pushbutton_SR,'user_label_record');
unlabeled_num=length(find(isnan(user_label_record)==1));
unknown_num=length(find(user_label_record==-1));
all_num=length(user_label_record);
str={'Present Label Condition:';'============';['complete ',num2str(100*(all_num-unlabeled_num)/all_num),' %, total ',num2str(all_num)];};
str1={'============';['the number of unlabeled sample is ',num2str(unlabeled_num),':    '];num2str(find(isnan(user_label_record)==1))};
str2={'============';['the number of unknown sample is ',num2str(unknown_num),':    '];num2str(find(user_label_record==-1))};

str_all=[str;str1;str2];
set(handles.edit_user,'string',str_all);
guidata(hObject, handles);



function zb_Callback(hObject, eventdata, handles)
% hObject    handle to zb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zb as text
%        str2double(get(hObject,'String')) returns contents of zb as a double


% --- Executes during object creation, after setting all properties.
function zb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
