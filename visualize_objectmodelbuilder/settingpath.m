function paths = settingpath(CO2SIM_home, remove)
% Name      : settingpath
% Syntax    : paths = settingpath(CO2SIM_home,gui)
%               CO2SIM_home      : [string] CO2SIM installation path
%
% Example   : paths = settingpath('E:\CO2SIM')
%--------------------------------------------------------------------------

fprintf('Generates Fortran class and functional diagrams\n \n');
if (nargin < 1)
    CO2SIM_home=pwd;
end
if nargin < 2
    remove = false; %adding path instead of removing
end
fprintf('Home path: %s \n', CO2SIM_home);

paths = {};
paths = addsimpath([CO2SIM_home], paths, remove);
paths = addsimpath([CO2SIM_home '\src'], paths, remove);
paths = addsimpath([CO2SIM_home '\FortranClassDiagramDist'], paths, remove);
paths = paths'; %To make visible list

%Subfunction
function paths = addsimpath(folderpath, paths, remove)

if remove
    rmpath(folderpath); %Remove from Matlab paths
else
    addpath(folderpath); %Add to Matlab paths
end
paths{end+1} = folderpath; %Store in list of paths
