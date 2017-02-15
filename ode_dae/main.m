% illustrates setup of boundary conditions avoiding algebraic singularities. the ode
% thus avoids the singular m-matrix.
% a.tobiesen 23072016
% uses DSS subroutines from Schisser et al. 
% Graham W Griffiths and William E Schiesser (2011).

%the models is a simple hyperbolic advection example with a non-linear
%source. The inlets are on oppsite sides (counter-current). 
addpath(genpath([pwd '\dss']))

%choose scheme (dae or ode)
% s.dae =false;
s.dae =0;

%initial condition (guess or current states at inlet)
%c1 is RHS of column
%c2 is LHS
s.c10=6; s.c20=6; 

%new values for inlets
s.c1e=2; s.c2e=2;

s.nz=21;
s.zL=5; s.zR = 0;

%model
s.v1=1; s.v2=-1;
s.k1=1;  s.k2=1;

%spatial grid
dz = (s.zL - s.zR)/(s.nz-1);
z=[s.zR:dz:s.zL];

%solver:
%dss012         first order directional 
%dss020         Five point biased upwind approximation (5pbu)
%vanl           van Leer flux limiter (directional)
% s.axialmethod = @vanl;
% s.axialmethod = @dss004; %classic 5 point centered
s.axialmethod = @dss012;
timeInc =[0.1:1:30];
% timeInc =[1];
for i=1:length(timeInc)
    % Set initial condition for two components 
    u0(1:s.nz)          = s.c10; % rand(1,s.nz)*1000;
    u0(s.nz+1:2*s.nz)   = s.c20; % rand(1,s.nz)*1000;

    t0=0; 
    tf=timeInc(i); 
    nout=21;

    dt = (tf-t0)/(nout-1);
    tvec=linspace(t0,tf,nout)';
    tic
    if s.dae
        a_M = zeros(length(u0),1); 
        %left
        a_M(2:s.nz) = 1;
        %right
        a_M((s.nz+1):2*s.nz-1) = 1;
        
        M = diag(a_M); 
        options = odeset('Mass',M,'MassSingular','yes','RelTol',1e-6,'AbsTol',1e-6);
       [tout,yout, a] = ode15s(@(t,y) fboth(t, y ,s),tvec, u0 ,options);
    else
        %attempt with explicit scheme
        explicit = false;
        if explicit
            Dtplot = tvec(2)-tvec(1);
            Dt = dt;
            explicitsol =@euler_solver;
            explicitsol =@midpoint_solver;
           [tout,yout]  = feval (explicitsol, @(t,y) fboth(t,y,s),t0,tf,u0',Dt,Dtplot);
        else
            options = odeset('RelTol',1e-6,'AbsTol',1e-6);
            [tout,yout, a] = ode15s(@(t,y) fboth(t, y ,s),tvec, u0 ,options);
        end
    end
    
    for idx =1:nout
     for i = 1:s.nz
        c1(idx, i)=yout((idx), i);
        c2(idx, i)=yout((idx), s.nz+i);
     end
    end
    movie = true;
    if movie
        figure(20)
        h = animatedline;
        title('u')
            for i=1:s.nz
                 plot(tout,c2(:,i),'-r'); axis tight
                 plot(tout,c1(:,i),'-k'); axis tight
            end

        incc2= c2(end,:);
        incc1= c1(end,:);
%         plot(z,incc1,'-r');
        hold on;
%         plot(z,incc2,'-k');
       
        drawnow
%         delay(.01)
    end
end

%  stop 
for idx =1:nout
 for i = 1:s.nz
    c1(idx, i)=yout((idx), i);
    c2(idx, i)=yout((idx), s.nz+i);
 end
end
ncall = a(3);
fprintf('c2 ut out of column (at z=0): %f4\n', c2(length(tvec),1))
fprintf('c1 ut out of column (at z=1): %f4\n', c1(length(tvec),end))
toc

printout = true;

res = true;
switch res
    case(true)        
     % Display solution
    disp((sprintf('\n\n     t     c1(z=zL,t)  c2(z=0,t)\n')));
    for(it = 1:nout)
      disp(sprintf('%7.2f %12.4f %12.4f\n',tout(it),c1(it,s.nz),c2(it,1)))
    end
end

switch(printout)

    case(1)
         figure(1)
         
         mesh(z,tout,c1);
          hold on
         xlabel('z');
         ylabel('t');
         zlabel('u(z,t)');
         title('c1')
    
         figure(2)

         mesh(z,tout,c2);
         hold on;
         xlabel('z');
         ylabel('t');
         zlabel('c2(z,t)');
         title('c2 ')

         figure(12)
    for i=1:s.nz
        title('c1')
         plot(tout,c1(:,i),'-r'); 
         hold on;
          plot(tout,c2(:,i),'-k'); 
          hold on;
    end
    figure(13)
    for i=1:s.nz
        title('c2')
         plot(tout,c2(:,i),'-k'); axis tight
          hold on;
    end

       figure(14)
    for i=s.nz
        title('c1 at exit of column at zL (red line is c2 at inlet)')
         plot(tout,c1(:,i),'-g');
         hold on;
          plot(tout,c2(:,i),'-r'); 
         hold on;
    end
    figure(15)
    for i=1
        title('c2 at z=0 of column at z0 (red line is c1 at inlet)')
        plot(tout,c1(:,i),'-g');  
        hold on;

         plot(tout,c2(:,i),'-r'); 
          hold on;
    end
end% switch