%CLASSDEF @ComponentCollection  One-line description here, please.
%    ComponentCollection(input) does what, described by several lines of text
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
classdef ComponentCollection < handle
    properties
        Name
        Components;
        Parameters;
    end
    methods
        
        %Constructor
        function obj = ComponentCollection(name)
            obj.Name = name;
        end
        %Add new Component to ComponentCollection
        function AddComponents(obj,value)
            if ~isempty(value)
                if isempty(obj.Components)
                    if iscell(value)
                        for ii=1:length(value)
                            obj.Components(ii) = value{ii};
                            obj.AddListener(value{ii});
                        end
                    else
                        obj.Components = value;
                        obj.AddListener(value);
                    end
                else
                    if iscell(value)
                        for ii=1:length(value)
                            obj.Components(end+ii) = value{ii};
                            obj.AddListener(value{ii});
                        end
                    else
                        obj.Components(end+1) = value;
                        obj.AddListener(value);
                    end
                end
            end
        end
        
         %Add new Component to ComponentCollection
        function AddParameter(obj,value)
            if ~isempty(value)
                if isempty(obj.Parameters)
                    if iscell(value)
                        for ii=1:length(value)
                            obj.Parameters(ii) = value{ii};
                            obj.AddListener(value{ii});
                        end
                    else
                        obj.Parameters = value;
                        obj.AddListener(value);
                    end
                else
                    if iscell(value)
                        for ii=1:length(value)
                            obj.Parameters(end+ii) = value{ii};
                            obj.AddListener(value{ii});
                        end
                    else
                        obj.Parameters(end+1) = value;
                        obj.AddListener(value);
                    end
                end
            end
        end
        
        function ComponentReduction(obj, collection, bEvent)
            fprintf(['Object ' collection.Name ' is ' num2str(bEvent.Unit) ' reduced\n']);
        end
    end
    
    methods (Access = private, Hidden = true)
        function AddListener(obj, collection)
            collection.addlistener('Event!',@obj.ComponentReduction);
        end    
    end
end

