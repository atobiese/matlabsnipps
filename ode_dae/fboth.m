function [ct, s]= fboth(t,u,s) 
    
%format
c1 = u(1:s.nz)';
c2 = u(s.nz+1:s.nz+s.nz)';

if s.dae
    %only fixedpoints in time differential
else
    % Boundary conditions
    c1(1)       = s.c1e;
    c2(s.nz)    = s.c2e;
end
% axial discr c1z, c2z
switch char(s.axialmethod)
    case ('dss004')
        %center diff
        c1z=feval(s.axialmethod,0,s.zL,s.nz,c1);  
        c2z=feval(s.axialmethod,0,s.zL,s.nz,c2);  
    otherwise
        %upwind methods
        c1z=feval(s.axialmethod,0,s.zL,s.nz,c1,s.v1);
        c2z=feval(s.axialmethod,0,s.zL,s.nz,c2,s.v2);
end
% Boundary conditions (ae)
if s.dae
    c1t(1)      =(c1(1)    - s.c1e);
    c2t(s.nz)   =(c2(s.nz) - s.c2e);
else
    %set initial grid at each side to zero (no flux at boundary) 
    c1t(1)      =0;
    c2t(s.nz)   =0;    
end

source1 = s.k1*(c2(2:s.nz)  -c1(2:s.nz  ));%  + c1(2:s.nz);
source2 = s.k2*(c1(1:s.nz-1)-c2(1:s.nz-1));%  - c1(2:s.nz);
c1t(2:s.nz)   = -s.v1*c1z(2:s.nz)    + source1;
c2t(1:s.nz-1) = -s.v2*c2z(1:s.nz-1)  + source2;

%return
ct(1:s.nz)         =c1t(:);
ct(s.nz+1:2*s.nz)  =c2t(:);

ct = ct';