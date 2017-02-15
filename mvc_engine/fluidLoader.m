%  andrew.tobiesen@sintef.no 19.06.2015
function [pipeOut, nc, compnames] = fluidLoader(phase, amineName, tagName)

loadfortran

%example of usage

% Fluid references -- put these in hash table
% Create this in Matlab, C#, or wherever witithin SAME PROCESS.
% vap = calllib('fluidload', 'fluidload', 'fluid_cc6.dll', 'cc6_init_vapor');
% vap = calllib('fluidload', 'fluidload', 'fluid_cc2_enrtl.dll', 'cc2_enrtl_init_vapor');
namedll = strtrim(amineName); 
fullnamedll = ['fluid_' namedll];

switch(phase)
    case('liquid')
        tagName = 'liq';
        initliquid = [namedll '_init_liquid'];    
        pipe = libpointer('voidPtrPtr'); 
        [err, dummy, dummy, pipeOut] = calllib('fluidload', 'fluidload_compat', [fullnamedll '.dll'], initliquid, pipe);
        if err ~= 0
            fprintftcpip('Unable to load up %s, belonging to %s. Make sure that dll exists and is in system path.\n', initliquid, [fullnamedll '.dll']);   
             %alert
             warndlg('Thermopackage dll does not exist','! obs !')
            %errr;
        end
         calllib('ptrtable', 'ptrtable_insert', tagName, pipe)
    case('vapor')
        tagName = 'vap';
        initvapor = [namedll '_init_vapor'];  
        pipe = libpointer('voidPtrPtr'); 
        [err, dummy, dummy, pipeOut] = calllib('fluidload', 'fluidload_compat', [fullnamedll '.dll'], initvapor, pipe);
        if err ~= 0
            fprintftcpip('Unable to load up %s, belonging to %s. Make sure that dll exists and is in system path.\n', initvapor, [fullnamedll '.dll']);
             %alert
             warndlg('Thermopackage dll does not exist','! obs !')
        end
        calllib('ptrtable', 'ptrtable_insert', tagName, pipe)
end

% Number of components
[~, nc, ierr] = calllib('fluid', 'fluid_get_nc', pipe, 0, 0);

% Get component names.
% Note the buffer 'buf' is required as no memory is allocated by
% the fluid_get_compname function.
compnames = cell(1, nc);
buf = blanks(80);
for i = 1:nc
   [~, compname, ierr] = calllib('fluid', 'fluid_get_compname', pipe, i, buf, 0);
   compnames{i} = compname;
end 
% disp(compnames)

end

