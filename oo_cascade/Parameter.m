%CLASSDEF @Parameter  One-line description here, please.
%    Parameter(input) does what, described by several lines of text
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
classdef Parameter < Item
    properties
        
    end
    
    methods
        %Constructor
        function obj = Parameter(name, type, value, group, unit)
            obj@Item(name, type, value, group, unit); %Call superclass constructor
        end
        
       function Identifier(obj)
            fprintf(['This is a type: ' obj.Type ' with name: ' obj.Name, '\n']);
        end
        
        function Sit(obj)
            fprintf([obj.Name ' is doing something\n']);
        end
    end
end