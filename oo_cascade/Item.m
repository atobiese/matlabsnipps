%CLASSDEF @Item  One-line description here, please.
%    Item(input) does what, described by several lines of text
%
%   INPUT
%    ParaIn    - description
%    ParaIn2   - (optional) description
%
%   OUTPUT
%    obj       - class reference
%
%   EXAMPLE
%    SimTestingFortranProperties
%
%   See also CLASS1, CLASS2

% References:
%   Add references here if any
%

% Author:
%   Andrew F. Tobiesen, SINTEF Materials and Chemistry
% 
% Copyright (c) SINTEF
%   $Revision: 2.0.0.0 $, $Date: 2011-13-03 $, & ft $
%   $Id$
%
classdef Item < SimSuperObject

    properties
        Value %See below for special implementation of set and get
        Group
        Unit 
    end
    
   
%     properties(Hidden = true, Access = public)
%         Parent
%     end

     properties (SetAccess = public, GetAccess = public, Hidden = true)
        %Internal collections containing SimItem objects
        
        CreatedStruct
        
        InternalUpdating %If Struct and or items are created or updated inside code this should be true. If changes is due to user input this is set to []. See SimItem for usage.
    end
    
    properties %Public
        Struct
    end
    
    methods (Abstract)
        Identifier(obj);
    end
    
    methods
        %Class constructor
        function obj = Item(name, type, value, group, unit)
            obj.Name = name;
            obj.Type = type;
            obj.Value = value;
            obj.Group = group;
            obj.Unit = unit;
        end

        %Implementation of get functionality for Unit
        function Value = get.Value(obj)
            Value = obj.Value;
        end
        
        %Implementation of set functionality for Unit
        function set.Value(obj, value)
            obj.Value = value;
            
            if quant(value,1) == round(value)
               notify(obj, 'Halflife', HalflifeEventDataClass(value));
            end
        end
    end
    
     methods (Hidden = true, Access = protected)
        
        %Create the struct accessed by the property obj.Struct
        function st = CreateStruct(obj, st)
            obj.InternalUpdating = true; %Value indicating that change to SimItems is initiated from Code and not from User. See UpdateParentStruct@SimItem for usage of this Property.
            
            st.name = obj.Name;
            st.type = obj.Type();
            st.value = obj.Value;
            st.group = obj.Group;
            st.unit = obj.Unit;
            
            % Call sub-class specific CreateStruct method (see sub-classes for implementation)
            st = obj.CreateClassSpecificStruct(st);
            
            obj.InternalUpdating = []; %Reset to again force updating to Struct when Items or Parameters are changed by user
        end
    end
    
    methods     
    % Implementation of Get Struct property
    function s = get.Struct(obj)
            obj.CreatedStruct = true;
            st = obj.CreateStruct();

            if isempty(st)
                obj.CreatedStruct = [];
            else
                obj.Struct = st;
            end

            s = obj.Struct;
        end
        
        % Implementation of Get Struct property
        function set.Struct(obj, value)      
                obj.CreatedStruct = true;
                obj.Struct = value;     
        end
    end
    
    events
        Halflife;
    end
end





