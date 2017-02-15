function [valStr] = fluidGetData(pipe, nc, inputData)
persistent inputStored
% if isempty(inputStored)
%             inputStored = 1;
% else
%     idxID = idxID + 1;
% end
%    objIdentifier = idxID;
% end


% Number of components
% [~, nc, ierr] = calllib('fluid', 'fluid_get_nc', pipe, 0, 0);

% Get component names.
% Note the buffer 'buf' is required as no memory is allocated by
% the fluid_get_compname function.
% compnames = cell(1, nc);
% buf = blanks(80);
% for i = 1:nc
%    [~, compname, ierr] = calllib('fluid', 'fluid_get_compname', pipe, i, buf, 0);
%    compnames{i} = compname;
% end 
% disp(compnames)

% Get mole weight vector.
[~, mw, ierr] = calllib('fluid', 'fluid_get_mw', pipe, zeros(nc,1), 0);

T = inputData.T;
P = inputData.P;
n = inputData.n;
nflowNames = inputData.nflowNames;

% Get enthalpy, viscosity and density
[~, ~, htot, ierr] = calllib('fluid', 'fluid_get_enthalpy', pipe, T, P, n, 0., 0);
[~, ~, visc, ierr] = calllib('fluid', 'fluid_get_viscosity', pipe, T, P, n, 0., 0);
[~, ~, rho, ierr] = calllib('fluid', 'fluid_get_density', pipe, T, P, n, 0., 0);

% Get fugacities
[~, ~, fug, ierr] = calllib('fluid', 'fluid_get_fugacity', pipe, T, P, n, zeros(nc,1), 0);


% Clean up references.
% Should set the hash table value to NULL also.
% Can this can be done by sending a simple libpointer() ?
% calllib('fluid', 'fluid_free', pipe)
% clear vap liq

%export
valStr.nc = nc;
valStr.mw = mw;
valStr.htot = htot;
valStr.visc = visc;
valStr.rho = rho;
valStr.fug = fug;

end
