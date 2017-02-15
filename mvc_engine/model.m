%  andrew.tobiesen@sintef.no 19.06.2015
classdef model < handle    
    properties (SetObservable)
        thermoPkg 
        textLabel
        valStr
        plotData
        clear
        popup_sel_index
        phase
        data
        Table
        handleuitable
        setInputdata
        getpipeData
    end
    
    properties
        pipesAPI
        inputData
    end
        
    methods
        function obj = model()
            obj.reset();
        end
                
        function reset(obj)
            obj.thermoPkg = '';
            obj.textLabel = '';
            obj.plotData = '';
        end
        
        function setThermoPkg(obj,thermoPkg)
            
            tagName = 'liq';
            [pipe, nc, compnames] = fluidLoader(obj.phase, thermoPkg, tagName);
            
            for i=1:nc
                nflowNames{i} = ['n' compnames{i}]; 
            end
            
            if ~isfield(obj.inputData,'nflowNames') || (nc ~= length(obj.inputData.n))
                T = 298.15;
                P = 1e5;
                n = ones(1, nc);
                obj.UpdateInputData(T, P, n)
                
            end
            
            obj.inputData.nflowNames = nflowNames;
            
            
            [valStr] = fluidGetData(pipe, nc,  obj.inputData);
            valStr.compnames = compnames;
            obj.valStr = valStr;
            obj.textLabel = sprintf('Variable for package: %s', thermoPkg);
            obj.thermoPkg = thermoPkg;
            name = 'liq';
            obj.pipesAPI.liq = calllib('ptrtable', 'ptrtable_lookup', name);
%               name = 'vap';
%             obj.pipesAPI.vap = calllib('ptrtable', 'ptrtable_lookup', name);
        end
        
        function UpdateInputData(obj, T, P, n)
            obj.inputData.T = T;
            obj.inputData.P = P;
            obj.inputData.n = n';
            obj.inputData.x = n/sum(n);
            
         end
        
        function setPushbutton1(obj)    
            obj.GetData()
            obj.plotData = 0;
        end
        
        function clearPlot(obj)
            obj.clear = [];
        end
        
        function setPlot(obj, popup_sel_index)   
            obj.GetData()
            obj.popup_sel_index = popup_sel_index;
        end
        
        function setPhase(obj, phase)
            obj.phase = phase;
        end
        
        function CreateTable(obj)
            obj.Table  = [];
        end
        
        function GetData(obj)

                name = 'liq';
                tagName = 'liq';
                [obj.pipesAPI.liq] = fluidLoader(obj.phase, obj.thermoPkg, tagName);          
                [~, nc, ierr] = calllib('fluid', 'fluid_get_nc', obj.pipesAPI.liq, 0, 0);

                npos = 100;
                %update data from pipe
                temp = obj.inputData.T;
                press = obj.inputData.P;
                nflowVec = obj.inputData.n; %ones(1, nc); 
                
                low = temp;
                high=temp+100d0;
                tVec(1:npos,1) = CreateValueRange(low,high,npos);
%                 press = 1e5;
                
                obj.data.tVec = zeros(npos,1);
                obj.data.htotVec = zeros(npos,1);
                obj.data.viscVec = zeros(npos,1);
                obj.data.rhoVec = zeros(npos,1);
                obj.data.fugVec = zeros(npos, nc);
                for idx = 1:npos
                    % Get enthalpy, viscosity and density
                    [~, ~, htot, ierr] = calllib('fluid', 'fluid_get_enthalpy', obj.pipesAPI.liq, tVec(idx), press, nflowVec, 0., 0);
                    [~, ~, visc, ierr] = calllib('fluid', 'fluid_get_viscosity', obj.pipesAPI.liq, tVec(idx), press, nflowVec, 0., 0);
                    [~, ~, rho, ierr] = calllib('fluid', 'fluid_get_density', obj.pipesAPI.liq, tVec(idx), press, nflowVec, 0., 0);
                    obj.data.tVec = tVec;
                    obj.data.htotVec(idx) = htot;
                    obj.data.viscVec(idx) = visc;
                    obj.data.rhoVec(idx) = rho;

                % Get fugacities
                [~, ~, fug, ierr] = calllib('fluid', 'fluid_get_fugacity', obj.pipesAPI.liq, tVec(idx), press, nflowVec, zeros(nc,1), 0);
                obj.data.fugVec(idx,1:nc) = fug(1:nc);
                end
                
                head = {'tVec' 'enthalpy tot' 'viscocity' 'rho'};
                for idx = 1:length(obj.valStr.compnames)
                 headers{idx} = ['fucacity ' obj.valStr.compnames{idx}];
                end
                obj.data.headers = [head headers];
        end
        
         function updateInputData(obj)
            obj.setInputdata = [];
         end
         
         function getXMLpipe(obj)
            obj.getpipeData = [];
         end
         
         function getXMLdata(obj, FileName,PathName)
             [data] = getCO2SIMPipe(FileName,PathName);
             
             %fixme_must reload the given thermopackage
             T = data.temp; P = data.press;
             n=(data.flow.*data.molfrac(:))';
             n=n*(1000/3600);
             
             obj.UpdateInputData(T, P, n);
             
             %update tables
             obj.thermoPkg = obj.thermoPkg;
         end
         
         
    end
end