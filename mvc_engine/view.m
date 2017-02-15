%  andrew.tobiesen@sintef.no 19.06.2015
classdef view < handle
    properties
        gui
        model
        controller
    end
    
    methods
        function obj = view(controller)
            obj.controller = controller;
            obj.model = controller.model;
            
            obj.gui = displayTable('controller',obj.controller);
            
            addlistener(obj.model,'thermoPkg','PostSet', ...
                @(src,evnt)view.handlePropEvents(obj,src,evnt));
            addlistener(obj.model,'plotData','PostSet', ...
                @(src,evnt)view.handlePropEvents(obj,src,evnt));
            addlistener(obj.model,'popup_sel_index','PostSet', ...
                 @(src,evnt)view.handlePropEvents(obj,src,evnt));
            addlistener(obj.model,'phase','PostSet', ...
                @(src,evnt)view.handlePropEvents(obj,src,evnt));
            addlistener(obj.model,'clear','PostSet', ...
                @(src,evnt)view.handlePropEvents(obj,src,evnt));
            addlistener(obj.model,'Table','PostSet', ...
                @(src,evnt)view.handlePropEvents(obj,src,evnt));
            addlistener(obj.model,'setInputdata','PostSet', ...
                @(src,evnt)view.handlePropEvents(obj,src,evnt));
            addlistener(obj.model,'getpipeData','PostSet', ...
                @(src,evnt)view.handlePropEvents(obj,src,evnt));
        end
    end
    
    methods (Static)
        function handlePropEvents(obj,src,evnt)
            evntobj = evnt.AffectedObject;
            handles = guidata(obj.gui);
            switch src.Name
                
                %select the set's
                case 'thermoPkg'
                    
                    rowNames = fieldnames(evntobj.valStr);
                    
                    headersS = {'Property'};
                    headersH = {'Property', 'Y-Data', 'Z-Data',  'Z-Data', 'Z-Data'};
                    
                    lenRows= length(fieldnames(evntobj.valStr));
                    
                    %hack, for printing
                    evntobjLoc = evntobj;
                    
                    evntobjLoc.valStr.x = evntobjLoc.inputData.x;
                    rowNames{end+1} = 'x';
                    
                     nc=length(obj.model.inputData.n);
                     
                     if nc ~= length(obj.model.inputData.nflowNames)
                         %alert
                         warndlg('Not same number of components from thermo vs stream','! Warning !')
                     end
                    
                    single = 0;
                    multiple = [];
                    idx = 1;
                    idy = 1;
                    for k=1:lenRows
                        val = eval(['evntobjLoc.valStr.' rowNames{k}]);
                        if length(val) == 1
                            single(idx) = val;
                            sRows(idx) = (rowNames(k));
                            idx = idx +1;
                        else
                            if ~iscell(val)
                                multiple(:,idy)=val;
                                mRows(idy) = (rowNames(k));
                                idy = idy +1;
                            else
                              headersH =  val;
                            end
                        end
                    end
                    
                     %print til gui
                     hTable = uitable('Parent',gcf, ...
                     'Data',single', ...
                     'ColumnName',headersS, ...
                     'RowName',sRows);
                 
                     hTableExtent = get(hTable,'Extent');
                     hTablePosition = get(hTable,'Position');
                    
                     set(hTable,'Pos',[20 400 round(1.*hTableExtent(3)) round(1.*hTableExtent(4))]);
                     set(handles.text1, 'String', evntobj.textLabel);
                     
                     %print til gui
                     hTable = uitable('Parent',gcf, ...
                     'Data',multiple', ...
                     'ColumnName',headersH, ...
                     'RowName',mRows);
                     
                     hTableExtent = get(hTable,'Extent');
                     hTablePosition = get(hTable,'Position');
                     
                     set(hTable,'Pos',[20 300 round(1.*hTableExtent(3)) round(1.*hTableExtent(4))]);
                     
                     %print til gui
                     %hente data
                     
                     temp = obj.model.inputData.T;
                     press = obj.model.inputData.P;
                    
                     
                     nflowVec = obj.model.inputData.n';
                     single = [temp, press, nflowVec];
                     
                     sRows = ['Temp', 'Press', obj.model.inputData.nflowNames];
                     h = uitable('Parent',gcf, ...
                     'Data',single', 'columneditable',true,'RearrangeableColumns','on', ...
                     'ColumnName',headersS, ...
                     'RowName',sRows);
                 
                     hTableExtent = get(h,'Extent');
                     hTablePosition = get(h,'Position');
                    
                     set(h,'Pos',[200 400 round(1.*hTableExtent(3)) round(1.*hTableExtent(4))]);
                     obj.controller.model.handleuitable = h;
                   
                case 'plotData'
                     actx_excel(obj)                        

                case 'popup_sel_index'

                    switch evntobj.popup_sel_index
                        case 1     
                            plot(evntobj.data.tVec, evntobj.data.rhoVec, 'r-');
%                              ymin = min(evntobj.data.rhoVec); ymax = max(evntobj.data.rhoVec); 
                        case 2
                            plot(evntobj.data.tVec, evntobj.data.viscVec , 'b-');
%                              ymin = min(evntobj.data.viscVec); ymax = max(evntobj.data.viscVec);
                        case 3
                            plot(evntobj.data.tVec, evntobj.data.htotVec , 'b-');
%                             ymin = min(evntobj.data.htotVec); ymax = max(evntobj.data.htotVec);
                        case 4
                            cla
                            semilogy(evntobj.data.tVec, evntobj.data.fugVec(:,1) , 'r-');
%                             ymin = min(evntobj.data.fugVec(:,1)); ymax = max(evntobj.data.fugVec(:,1));
                        case 5
                            cla
                            semilogy(evntobj.data.tVec, evntobj.data.fugVec(:,2) , 'b-');
%                             ymin = min(evntobj.data.fugVec(:,2)); ymax = max(evntobj.data.fugVec(:,2));
                       case 6
                           cla
                            semilogy(evntobj.data.tVec, evntobj.data.fugVec(:,3) , 'b-');
%                             ymin = min(evntobj.data.fugVec(:,3)); ymax = max(evntobj.data.fugVec(:,3));
                    end
                    
%                     xmin = min(evntobj.data.tVec); xmax = max(evntobj.data.tVec);     
%                     axis([xmin xmax ymin ymax])
                    axes(handles.axes1);
                    leg = [char(evntobj.data.headers(evntobj.popup_sel_index+1)) ' ' char(evntobj.thermoPkg)  ' ' char(evntobj.phase)];
%                     [legh,c,g,lbs] = legend(['' leg]);
                   
                    hold all;
                    set(handles.text1, 'String', leg);
                case 'clear'
                    axes(handles.axes1);
                      cla;
%                          grid off;
%                           hold on;
                case 'phase'
                     set(handles.text2, 'String', evntobj.phase);
                     
               case 'Table'
                    matData = [obj.controller.model.data.tVec(:) obj.controller.model.data.htotVec(:) obj.controller.model.data.viscVec(:) obj.controller.model.data.rhoVec(:) obj.controller.model.data.fugVec(:,1)];
                    for i=1:length(obj.controller.model.data.fugVec(1,:))
                        matData(:,end+1) = obj.controller.model.data.fugVec(:,i);
                    end
                    f = figure('Position', [200 200 752 500]);
%                    %print til gui
                    t = uitable('Parent',f, 'Position', [25 50 700 450],...
                    'Data',matData, 'ColumnName',evntobj.data.headers);                
             case 'setInputdata'
                  data=get(obj.controller.model.handleuitable,'data');
                  T=data(1);P=data(2); n=data(3:end)';
                  obj.controller.model.UpdateInputData(T, P, n);
             case 'getpipeData'
                 [FileName,PathName] = uigetfile('*.xml','Select the MATLAB code file');
                 %run extraction code
                 obj.controller.model.getXMLdata(FileName,PathName);
                 
            end%switch
           
        end
    end
end