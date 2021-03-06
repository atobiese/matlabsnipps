function actx_excel(obj)                                             
% Copyright 2013 The MathWorks, Inc.
% Use Excel as a data server for MATLAB
% 
% Start data server
startServ1
% Scope variables from startServ1 to main function
exl; exlWkbk; exlData;
% Start graph server
startServ2
% Scope variables from startServ2 to main function
exl2; exlWkbk2; wb; Shapes;
matData = [obj.controller.model.data.tVec(:) obj.controller.model.data.htotVec(:) obj.controller.model.data.viscVec(:) obj.controller.model.data.rhoVec(:) obj.controller.model.data.fugVec(:,1)];

for i=1:length(obj.controller.model.data.fugVec(1,:))
    matData(:,end+1) = obj.controller.model.data.fugVec(:,i);
end
%% Extract column data
% Time:1, inptAil:2, inptEle:3, inptRud:4, respAil:5, respEle:6, respRud:7
% for ii = 1:size(exlData,2)
%    matData(:,ii) = reshape([exlData{2:end,ii}],size(exlData(2:end,ii)));
%    lBoxList{ii} = [exlData{1,ii}];
% end
lBoxList = obj.controller.model.data.headers; 
lbs = '';
tme = matData(:,1); % Time data
%% ------------ GUI layout ---------------
% Use system background color for GUI components
panelColor = get(0,'DefaultUicontrolBackgroundColor');
%% Set up the figure and defaults
f = figure('Units','characters',...
        'Position',[30 30 120 35],...
        'Color',panelColor,...
        'HandleVisibility','callback',...
        'IntegerHandle','off',...
        'Renderer','painters',...
        'Toolbar','figure',...
        'NumberTitle','off',...
        'Name','Excel Plotter',...
        'PaperPositionMode','auto',...
        'DeleteFcn',@deleteFig);

%% Create the bottom uipanel
botPanel = uipanel('BorderType','etchedin',...
    'BackgroundColor',panelColor,...
    'Units','characters',...
    'Position',[1/20 1/20 119.9 8],...
    'Parent',f);

%% Create the right side panel
rightPanel = uipanel('bordertype','etchedin',...
    'BackgroundColor',panelColor,...
    'Units','characters',...
    'Position',[88 8 32 27],...
    'Parent',f);

%% Create the center panel
centerPanel = uipanel('bordertype','etchedin',...
    'Units','characters',...
    'Position', [1/20 8 88 27],...
    'Parent',f);

%% Add an axes to the center panel
a = axes('parent',centerPanel);
xlabel(a,'Time')

%% Add listbox and label
listBoxLabel = uicontrol('Style','text','Units','characters',...
        'Position',[4 24 24 2],...
        'String','Select column(s) to plot',...
        'BackgroundColor',panelColor,...
        'Parent',rightPanel);
listBox = uicontrol('Style','listbox','Units','characters',...
        'Position',[4 2 24 20],...
        'BackgroundColor','white',...
        'Max',10,'Min',1,...
        'Parent',rightPanel,...
        'String',lBoxList(2:end));

%% Add edit field for excel file name
plotButton = uicontrol('Style','pushbutton','Units','characters',...
        'Position',[5 2 24 2],...
        'String','Create Plot',...
        'Parent',botPanel,...
        'Callback',@plotButtonCallback);
clearButton = uicontrol('Style','pushbutton','Units','characters',...
        'Position',[33 2 24 2],...
        'String','Clear Graph',...
        'Parent',botPanel,...
        'Callback',@clearButtonCallback);
saveButton = uicontrol('Style','pushbutton','Units','characters',...
        'Position',[60 2 24 2],...
        'String','Save Graph',...
        'Parent',botPanel,...
        'Callback',@saveButtonCallback);     
% dispButton = uicontrol('Style','togglebutton','Units','characters',...
%         'Position',[87 2 24 2],...
%         'String','Show Excel Data File',...
%         'Parent',botPanel,...
%         'Callback',@dispButtonCallback);

%% ------------------Callback Functions------------

function plotButtonCallback(src,evnt)   
iSelected = get(listBox,'Value');
grid(a,'on');hold all
for p = 1:length(iSelected)
   switch iSelected(p)
      case 1
         plot(a,tme,matData(:,2))
         ymin = min(matData(:,2)); ymax = max(matData(:,2));
         xmin = min(tme); xmax = max(tme); 
         axis([xmin xmax ymin ymax])

      case 2
         plot(a,tme,matData(:,3))
      case 3
         plot(a,tme,matData(:,4))   
      case 4
         plot(a,tme,matData(:,5))
      case 5
         plot(a,tme,matData(:,6))
      case 6
         plot(a,tme,matData(:,7))
      case 7
         plot(a,tme,matData(:,8))
     case 9
         plot(a,tme,matData(:,9))
      otherwise
         disp('Select data to plot')
   end
end
[legh,c,g,lbs] = legend([lbs lBoxList(iSelected+1)]);
end % plotButtonCallback

%% Callback for clear button
function clearButtonCallback(src,evt)
   cla(a,'reset')
   lbs = '';
end % clearButtonCallback

%% Callback for save graph button
function saveButtonCallback(src,evt)
   [stat,struc] = fileattrib(pwd);
   if struc.UserWrite
       tempfig = figure('Visible','off','PaperPositionMode','auto');
       ah = findobj(f,'type','axes');
       copyobj(ah,tempfig)
       print(tempfig,'-dpng',[pwd '\exlgraphexample']);
       Shapes.AddPicture([pwd '\exlgraphexample.png'] ,0,1,50,18,300,235);
       exl2.visible = 1;
   else
       disp('Cannot save graph in this folder.') 
   end
end
   
%% Display or hide Excel file
function dispButtonCallback(src,evt)
   %exl.visible = get(src,'Value');
   if get(src,'Value')
      exl.visible = true;
      set(src,'String','Hide Excel Data File')
   else
      exl.visible = false;
      set(src,'String','Show Excel Data File')
   end
end % dispButtonCallback

%% Start data server
function startServ1
   exl = actxserver('excel.application');
   % Load data from an excel file
   % Get Workbook interface and open file
   exlWkbk = exl.Workbooks; 
   exlFile = exlWkbk.Open([docroot '/techdoc/matlab_external/examples/input_resp_data.xls']);
   % Get interface for Sheet1 and read data into range object
   exlSheet1 = exlFile.Sheets.Item('Sheet1');
   robj = exlSheet1.Columns.End(4);
   numrows = robj.row;
   dat_range = ['A1:G' num2str(numrows)]; 
   rngObj = exlSheet1.Range(dat_range);
   % Read data from excel range object into MATLAB cell array
   exlData = rngObj.Value; 
   exl.registerevent({'WorkbookBeforeClose',@close_event1});
end % startServ1

% Start graph server
function startServ2
   % Create a second Excel server and
   % Add another workbook for saving
   % the graph to an Excel file
   exl2 = actxserver('excel.application');
   exlWkbk2 = exl2.Workbooks;
   wb = exlWkbk2.Add;
   graphSheet = wb.Sheets.Add;
   Shapes = graphSheet.Shapes;
   exl2.registerevent({'WorkbookBeforeClose',@close_event2});
end % startServ2

% Handle situation where user closes Excel data file
function close_event1(varargin)
% MATLAB does not currently support 
% pass by reference arguments for events
% so you cannot set Cancel argument to True
% Instead, just quit server and restart
   if exist('exl','var')
      exl.Quit;
      set(dispButton,'Value',0,...
         'String','Show Excel Data File')
   end
   startServ1
end % close_event1

% Handle situation where user closes Excel graph file
function close_event2(varargin)
% MATLAB does not currently support 
% pass by reference arguments for events
% so you cannot set Cancel argument to True
% Instead, just quit server and restart
   if exist('exl2','var')
      wb.Saved = true;
      exlWkbk2.Close
      exl2.Quit;
   end
startServ2
end % close_event2

%% Terminate Excel process
function deleteFig(src,evt)
   if exist('exl','var')
      exl.unregisterevent({'WorkbookBeforeClose',@close_event1});
      exlWkbk.Close
      exl.Quit
   end
   if exist('exl2','var')
      wb.Saved = true;
      exl2.unregisterevent({'WorkbookBeforeClose',@close_event2});
      exlWkbk2.Close
      exl2.Quit
   end
end % deleteFig       
end % actx_excel







