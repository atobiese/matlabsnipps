% generates csharp representation of a fortran object hierarchty
% use matlab and visual studio. see example in code with emf example files.
% 
% usage:
% path matlab in FortranClassDigagram 
% run: settingpath
% stay in folder root
% modify the below folders to incorporate all sourcee files to be generated
% run: classdiagrambuilderfortran
% open solution in Studio
% import all generated files (module preferrably, not functions)
% generate objectmapping
% if you do not get a flow diagram there is a problem with the base
% classes, this can be done manually in studio (ill fix it in code if i
% get some time. 
% for questions contact andrew tobiesen

% known issues:
% may have problem finding inherited abstract base classes and base classes, this can be
% fixed manually after csharp codes are generated. 
% some inheritances will generate errors in studio, for example use classes
% that do not represent simlar classes in csharp ruby matlab etc
% one can easily save files in respective folders according to type, they
% are now dumped to FortranClassDiagram folder. do it manually or import
% all to studio. 

% contact me for matlab objectbuilder (works (better) with no found issues). 


function classdiagrambuilderfortran
    CO2SIM_home = pwd;
    files = {};

    %USER:
    %Modify these files to represent your fortran sourcecode
    files = addfilelist([CO2SIM_home '\src\physical'], files);
    files = addfilelist([CO2SIM_home '\src\reactorClass'], files);
    files = addfilelist([CO2SIM_home '\src\thermoClass'], files);
    files = addfilelist([CO2SIM_home '\src\tools'], files);
    files = addfilelist([CO2SIM_home '\src\fluidClass'], files);
    files = addfilelist([CO2SIM_home '\src\flashClass'], files);
    


    for i=1:length(files)
        %fprintf('Building file %i of %i : %s\n',i,length(files),files{i});
%         try
            [csharp filename] = buildcsharpfilefortran(files{i});
            fprintf('############# %s #############\n%s\n\n',filename,csharp);
%         catch
%             fprintftcpip('\tError: Something went wrong.\n \n%s\n\n',files{i})
%             pause
%         end
    end

end


%Subfunction
function filelist = addfilelist(folderpath, filelist)
%     recursively do sub folder alså
     filelist = [filelist; createfilelist(folderpath,1,'*.f90',0)]; %Store in list of files
%     only folders specified
% filelist = [filelist; createfilelist(folderpath,0,'*.f90',0)]; %only the current directory


end
