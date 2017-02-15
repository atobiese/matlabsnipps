%  andrew.tobiesen@sintef.no 19.06.2015
classdef controller < handle
    properties
        model
        view
    end
    
    methods
        function obj = controller(model)
            obj.model = model;
            obj.view = view(obj);
        end
        
        function setThermoPkg(obj,thermoPkg)
            obj.model.setThermoPkg(thermoPkg)
        end
        
        function setPushbutton1(obj)
            obj.model.setPushbutton1()
        end
        
        function setPlot(obj, popup_sel_index)
            obj.model.setPlot(popup_sel_index)
        end
        
        function clearPlot(obj)
            obj.model.clearPlot()
        end
        
        
        function setPhase(obj, phase)
            obj.model.setPhase(phase)
        end
        
        function calculate(obj)
            obj.model.calculate()
        end
        
        function reset(obj)
            obj.model.reset()
        end
        
        
        function CreateTable(obj)
            obj.model.CreateTable()
        end
        
        function updateInputData(obj)
            obj.model.updateInputData()
        end
        
        function getXMLpipe(obj)
            obj.model.getXMLpipe()
        end
        
    end
end