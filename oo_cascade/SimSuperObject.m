%CLASSDEF @SimObject1  One-line description here, please.
%    SimObject1(input) does what, described by several lines of text
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
classdef SimSuperObject < handle 
    properties
        Name
        Type
    end
    
    properties(Hidden = true, Access = public)
        Parent
    end
    
    methods
        function obj = SimObject1()
            %global savingGlob;
            %savingGlob = false;
        end
        
        function simtype = get.Type(obj)
            simtype = class(obj);
        end
        
        function cloneobj = Clone(obj)
            filename=strcat(pwd,filesep,'temp.mat');
            
            save(filename,'obj');
            cloneobj=load(filename);
            
            cloneobj=cloneobj.obj;
            delete(filename);
        end
    end
end