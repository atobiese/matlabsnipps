% generates csharp representation of a fortran object hierarchty
% if questions contact andrew tobiesen, 20120110 sintef 2013
% use classdiagrambuilderfortran to execute recursively
% for use by sintef mc
% changelog: 
% added functionality for f90 files and "object oriented fortran"
% known issues:
% may have problem finding inherited abstract base classes, this is easily
% fixed manually after csharp codes are generated.
% fex public class mod_fluid : mod_fluidtype, mod_precision (mod_fluidtype
% may have to be added manually) 
function [csharpline filename] = buildcsharpfile(file)

    filenamestart = findstr(file,'\');
    filename = file(filenamestart(end)+1:end);
    foldername = file(filenamestart(end-1)+1:filenamestart(end)-1);
    csharpline = sprintf('using System;\nnamespace CO2SIM_FORTRAN\n{\n');

    fid = fopen(file);
    fidUseIdx = fopen(file);
    matlabline = fgetl(fid);
    abstract = false;
    access = 'public';
    hidden = false;
    classdefname = '';
    while true
        if matlabline == -1
           break 
        end
        if ~isempty(matlabline) 
            matlabline = removesep(matlabline);
            if (~isempty(matlabline))
                if ~strcmp(matlabline(1),'!')
                    [line classname abstract access]  = createcsharpline(matlabline, classdefname, filename, foldername, abstract, access, hidden, fid, fidUseIdx);
                    if length(line) > 0
                        csharpline = sprintf('%s\n%s',csharpline,line);
                        
                        if ~isempty(classname)
                            classdefname = classname;
                        else
                            classdefname = filename;
                        end
                    end
                end
            end
        end
        matlabline = fgetl(fid); 
    end
    
    if strcmp(classdefname,filename)
        csharpline = sprintf('%s\n}\n',csharpline);
        classdefname = classdefname(1:end-2);
    else
        csharpline = sprintf('%s\n}\n}\n',csharpline);
    end
    fclose(fid);

    fidcs = fopen(['FortranClassDiagram\FortranClassDiagram\' classdefname '.cs'],'w+');
    fwrite(fidcs,csharpline);
    fclose(fidcs);

end


%SUBFUNCTION

function [csharpline classname abstract access] = createcsharpline(matlabline, classname, filename, foldername, abstract, access, hidden, fid, fidUseIdx)
%     persistent moduleName
    csharpline = '';
    if findstr(lower(matlabline),'procedure')
        %do nothing now
    elseif findstr(lower(matlabline),'module')
        if findstr(matlabline(1:6),'module')
            [csharpline classname] = createclassdef(matlabline, fidUseIdx);
        end
    elseif findstr(matlabline,'properties')
        if findstr(matlabline(1:10),'properties')
            csharpline = extractproperties(matlabline,fid);
        end
%     elseif findstr(matlabline,'procedure')
%         if findstr(matlabline(1:9),'procedure')
%             [abstract access hidden] = extractaccesmodifiers(matlabline);
%             if abstract
%                 csharpline = extractabstractmethods(matlabline, abstract, access, hidden, fid);
%             end
%         end
    elseif findstr(matlabline,'function')
        if findstr(matlabline(length('function')),'function')
            if isempty(classname)
               classname = filename;
            end
            csharpline = extractfunction(matlabline, classname ,filename, foldername, abstract, access, hidden, fid);
        end
     elseif findstr(matlabline,'subroutine')
        if findstr(matlabline(length('subroutine')),'subroutine')
            if isempty(classname)
               classname = filename;
            end
            
            csharpline = extractfunction(matlabline, classname ,filename, foldername, abstract, access, hidden, fid);
        end
    end
end

function csharpline = extractabstractmethods(matlabline, abstract, access, hidden, fid)
    csharpline = '';
    matlabline = fgetl(fid);
    while ~strcmp(clearstring(matlabline),'end')
        matlabline = removesep(matlabline);
        if ~isempty(matlabline) & (strcmp(matlabline(1),'%') == 0)
            
            functionname = createfunctionname(matlabline);
    
            returnvaluestart = findstr(matlabline,'=');
            returnvalue = false;
            if ~isempty(returnvaluestart)
                returnvalue = true;
            end
            
            if returnvalue
                functionstring = [access ' abstract object ' functionname '();'];
            else
                functionstring = [access ' abstract void ' functionname '();'];
            end
            csharpline = sprintf('%s\n%s',csharpline, functionstring);
        end
        matlabline = fgetl(fid);
    end
end

function csharpline = extractproperties(matlabline,fid)
    csharpline = '';
    [abstract access hidden] = extractaccesmodifiers(matlabline);
    matlabline = fgetl(fid);
    while ~strcmp(clearstring(matlabline),'end')
        matlabline = removesep(matlabline);
        if ~isempty(matlabline) & (strcmp(matlabline(1),'%') == 0)
            propertyname = clearstring(matlabline);
            if hidden
                propertystring = [access ' object ' propertyname ';'];
            else
                propertystring = [access ' object ' propertyname ' { get; set; }'];
            end
            csharpline = sprintf('%s\n%s',csharpline, propertystring);    
        end
        matlabline = fgetl(fid);
    end
end

function csharpline = extractfunction(matlabline, classname, filename, foldername, abstract, access, hidden, fid)
    csharpline = '';
    
    returnvaluestart = findstr(matlabline,'subroutine');
    if ~isempty(returnvaluestart)
       functionname = createfunctionnamefromsubroutine(matlabline);
    else
       functionname = createfunctionname(matlabline);  
    end
    
   
    
    returnvaluestart = findstr(matlabline,'=');
    returnvalue = false;
    if ~isempty(returnvaluestart)
       returnvalue = true;
    end
    
    if strcmp(classname,filename)
        if returnvalue
            csharpline = sprintf('%s\n',[access ' delegate object ' functionname '();']);
        else
            csharpline = sprintf('%s\n',[access ' delegate void ' functionname '();']);
        end
        
    elseif strcmp(classname,functionname)
        csharpline = sprintf('%s\n',[ access ' ' functionname '() { }']);
    
    else
        if abstract
            if returnvalue
                csharpline = sprintf('%s\n',[ access ' abstract object ' functionname '();']);
            else
                csharpline = sprintf('%s\n',[ access ' abstract void ' functionname '();']);
            end
        else
            if returnvalue
                csharpline = sprintf('%s\n',[access ' object ' functionname '() { return null; }']);
            else
                csharpline = sprintf('%s\n',[access ' void ' functionname '() { }']);
            end
        end
    end
end

function functionname = createfunctionname(matlabline)
    findx = findstr(matlabline,'function');
    if ~isempty(findx)
        functiondefinition = clearstring(matlabline(findx(1)+0:end));
    else
        functiondefinition = clearstring(matlabline);
    end
    functionname = '';
    equalsign = findstr(functiondefinition,'=');
    startbracket = findstr(functiondefinition,'(');
    if ~isempty(equalsign)
        if ~isempty(startbracket)
            functionname = clearstring(functiondefinition(equalsign(1)+1:startbracket(1)-1));
        else
            functionname = clearstring(functiondefinition(equalsign(1)+1:end));
        end
    else
        if ~isempty(startbracket)
            functionname = clearstring(functiondefinition(1:startbracket(1)-1));
        else
            functionname = clearstring(functiondefinition);
        end
    end
    
    %added to increase length (fat 25 January)
    if (length(functionname) < 4 ) functionname = [functionname '_Add']; end
    
    if strcmp(functionname(1:4),'get.') || strcmp(functionname(1:4),'set.')
        functionname = strrep(functionname,'et.','et');
    end
end

function functionname = createfunctionnamefromsubroutine(matlabline)
    findx = findstr(matlabline,'subroutine');
    if ~isempty(findx)
        functiondefinition = clearstring(matlabline(findx(1)+10:end));
    else
        functiondefinition = clearstring(matlabline);
    end
    functiondefinition = (['subroutine_' functiondefinition]);
    functionname = '';
    equalsign = findstr(functiondefinition,'=');
    startbracket = findstr(functiondefinition,'(');
    if ~isempty(equalsign)
        if ~isempty(startbracket)
            functionname = clearstring(functiondefinition(equalsign(1)+1:startbracket(1)-1));
        else
            functionname = clearstring(functiondefinition(equalsign(1)+1:end));
        end
    else
        if ~isempty(startbracket)
            functionname = clearstring(functiondefinition(1:startbracket(1)-1));
        else
            functionname = clearstring(functiondefinition);
        end
    end
    
    %added to increase length (andrew)
    if (length(functionname) < 4 ) functionname = [functionname '_Add']; end
    
    if strcmp(functionname(1:4),'get.') || strcmp(functionname(1:4),'set.')
        functionname = strrep(functionname,'et.','et');
    end
end


function [csharpline classdefname] = createclassdef(matlabline, fidUseIdx)
    classdefheader = findstr(matlabline,'module procedure');
    if ~isempty(classdefheader) 
        csharpline = [];
        classdefname = [];
        return
    end
    
    classdefheader = findstr(matlabline,'module');
    
    j=0;
    classdefinheritanceCell=[];
    while true
        j=j+1;
         inheritanceline = fgetl(fidUseIdx);
         if inheritanceline == -1
           break 
        end
        if ~isempty(inheritanceline) 
            classdefinheritance1 = findstr(inheritanceline,'use');
            if (isempty(classdefinheritance1) && (j>5))  %check 5 lines down on the script %(j~=1)
                break
            end
            if ~isempty(classdefinheritance1) 
                classdefinheritance1 = findstr(inheritanceline,'use');
                
                %trim and get the parent classes
                inheritanceline = clearstring(inheritanceline(classdefinheritance1(1)+length('use'):end));
                a = findstr(inheritanceline,'only');
                if ~isempty(a) 
                    inheritanceline = clearstring(inheritanceline(a(1)+length('only:'):end));
                end
                b = findstr(inheritanceline,'=>');
                if ~isempty(b) 
                    inheritanceline = clearstring(inheritanceline(b(1)+length('=>'):end));
                end
                b = findstr(inheritanceline,'::');
                if ~isempty(b) 
                    inheritanceline = clearstring(inheritanceline(b(1)+length('::'):end));
                end
                
                classdefinheritanceCell = [classdefinheritanceCell ', ' inheritanceline];
%                 classdefinheritanceCell(j) =  a;
            end
        end
    end
    if ~isempty(classdefinheritanceCell)
        c = findstr(classdefinheritanceCell,',');
        if c(1) == 1 
            classdefinheritanceCell = clearstring(classdefinheritanceCell(c(1)+length(','):end));
        end
    end
    classdefinheritance = classdefinheritanceCell;
%     classdefinheritance = findstr(matlabline,'<');
    if length(classdefinheritance) > 0  
        %classdefinheritancename = clearstring(matlabline(classdefinheritance(1)+1:end));
        classdefname = clearstring(matlabline(classdefheader(1) + 6:end));
%         if checkabstract(classdefname)
%             if ~strcmp(classdefinheritancename,'handle')
%                 csharpline = ['public abstract class ' classdefname ' : ' classdefinheritancename];
%             else
%                 csharpline = ['public abstract class ' classdefname ];
%             end
%         else
%             if ~strcmp(classdefinheritancename,'handle')
                csharpline = ['public class ' classdefname ' : ' classdefinheritance];
%             else
%                 csharpline = ['public class ' classdefname ];
%             end
%         end
    else
        classdefname = clearstring(matlabline(classdefheader(1) + 6:end));
        if checkabstract(classdefname)
            csharpline = ['public abstract class ' classdefname ];
        else
            csharpline = ['public class ' classdefname ];
        end
    end
    
    csharpline = sprintf('%s\n{\n',csharpline);
end

function [csharpline classdefname] = createclassdefInheritance(matlabline)
    classdefheader = findstr(matlabline,'module');
    classdefinheritance = findstr(matlabline,'use');
    if length(classdefinheritance) > 0  
        classdefinheritancename = clearstring(matlabline(classdefinheritance(1)+3:end));
        classdefname = clearstring(matlabline(classdefheader(1) + 8:classdefinheritance(1)-1));
        if checkabstract(classdefname)
            if ~strcmp(classdefinheritancename,'handle')
                csharpline = ['public abstract class ' classdefname ' : ' classdefinheritancename];
            else
                csharpline = ['public abstract class ' classdefname ];
            end
        else
            if ~strcmp(classdefinheritancename,'handle')
                csharpline = ['public class ' classdefname ' : ' classdefinheritancename];
            else
                csharpline = ['public class ' classdefname ];
            end
        end
    else
        classdefname = clearstring(matlabline(classdefheader(1) + 6:end));
        if checkabstract(classdefname)
            csharpline = ['public abstract class ' classdefname ];
        else
            csharpline = ['public class ' classdefname ];
        end
    end
    
    csharpline = sprintf('%s\n{\n',csharpline);
end


function abstract = checkabstract(classname)
    switch(classname)
        case 'mod_fluid'
            abstract = true;
        case 'mod_Reactor'
            abstract = true;
        otherwise
            abstract = false;
    end
end

function [abstract access hidden] = extractaccesmodifiers(matlabline)
    hidden = false;
    matlabline = lower(matlabline);
    if (findstr(matlabline,'deferred'))
        abstract = true;
    else
        abstract = false;
    end
    
    if (findstr(matlabline,'private'))
        access = 'private';
    elseif (findstr(matlabline,'protected'))
        access = 'protected';
    else
        access = 'public';
    end
    
    if (findstr(matlabline,'hidden'))
        hidden = true;
    else
        hidden = false;
    end
end

function stringout = clearstring(stringin)
    stringout = clearcomments(stringin);
    stringout =  removesep(stringout);
    
    if length(stringout) > 0
        if strcmp(stringout(end),';')
            stringout = stringout(1:end-1);
        end
    end
end

function stringout = clearcomments(stringin)
    comment = findstr(stringin,'!');

    if ~isempty(comment)
        stringout = stringin(1:comment-1); 
    else
        stringout = stringin;
    end
end
function stringout = removesep(stringin)
    if ~isempty(stringin)
        if strcmp(stringin(1),sprintf('\t'))
            stringout = strrep(stringin,sprintf('\t'),'');
        else
            stringout = strrep(stringin,' ','');
        end
    else
        stringout = stringin;
    end
end