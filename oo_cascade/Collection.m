%CLASSDEF @Collection  One-line description here, please.
%    Collection(input) does what, described by several lines of text
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
classdef Collection < handle
    properties
        Name
        Components;
        Parameters;
    end
    
    properties (SetAccess = public, GetAccess = public, Hidden = true)
        CreatedStruct
        InternalUpdating 
    end
    
    properties %Public
        Struct
    end
    
    methods
        
        %Constructor
        function obj = Collection(name)
            obj.Name = name;
        end
        %Add new item to Collection
        function AddComponents(obj,value)
            if ~isempty(value)
                if isempty(obj.Components)
                    if iscell(value)
                        for ii=1:length(value)
                            obj.Components(ii) = value{ii};
                            obj.AddHalflifeListener(value{ii});
                        end
                    else
                        obj.Components = value;
                        obj.AddHalflifeListener(value);
                    end
                else
                    if iscell(value)
                        for ii=1:length(value)
                            obj.Components(end+ii) = value{ii};
                            obj.AddHalflifeListener(value{ii});
                        end
                    else
                        for ii=1:length(value)
                            obj.Components(end+1) = value(ii);
                            obj.AddHalflifeListener(value(ii));
                        end
                    end
                end
            end
        end
        
         %Add new Item to Collection
        function AddParameter(obj,value)
            if ~isempty(value)
                if isempty(obj.Parameters)
                    if iscell(value)
                        for ii=1:length(value)
                            obj.Parameters(ii) = value{ii};
                            obj.AddHalflifeListener(value{ii});
                        end
                    else
                        obj.Parameters = value;
                        obj.AddHalflifeListener(value);
                    end
                else
                    if iscell(value)
                        for ii=1:length(value)
                            obj.Parameters(end+ii) = value{ii};
                            obj.AddHalflifeListener(value{ii});
                        end
                    else
                        obj.Parameters(end+1) = value;
                        obj.AddHalflifeListener(value);
                    end
                end
            end
        end
        
        function ComponentHalflife(obj, collection, bEvent)
            fprintf([collection.Name ' is reduced to: ' num2str(bEvent.Value) ' in conentration!\n']);
        end
    end
    
     methods (Hidden = true, Access = protected)
        
        %Create the struct accessed by the property obj.Struct
        function st = CreateStruct(obj, st)
            obj.InternalUpdating = true; %Value indicating that change to SimItems is initiated from Code and not from User. See UpdateParentStruct@SimItem for usage of this Property.
            
%             st.simtype = obj.Type();
            st.name = obj.Name;
            
            % Call sub-class specific CreateStruct method (see sub-classes for implementation)
%             st = obj.CreateClassSpecificStruct(st);
            
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
    
    
    methods (Access = private, Hidden = true)
        function AddHalflifeListener(obj, collection)
            collection.addlistener('Halflife',@obj.ComponentHalflife);
        end    
    end
end

