
function X_t=backprog(X,back_time)

mu=3.986004415e14;

% Change from Space State to keplerian parameters
kep_param=SS2Kpl(X);

a0=kep_param(1);
e0=kep_param(2);
i0=kep_param(3);
Raan0=kep_param(4);
argpeg0=kep_param(5);
nu0=kep_param(6);

%backpropag
n=sqrt(mu/a0^3);
 
 AE0=norm_2pi_rad(atan2(sqrt(1-e0^2)*sin(nu0),e0+cos(nu0)));
 M0=norm_2pi_rad(AE0-e0*sin(AE0));
 M=norm_2pi_rad(M0-n*(back_time));
 
 

 AE=fsolve(@(E)E-e0*sin(E)-M,AE0);

 AE=norm_2pi_rad(AE);

 nu=atan2(sqrt(1-e0)*sin(AE),cos(AE)-e0); %acos((cos(AE)-e0)/(1-e0*cos(AE)))

 nu=norm_2pi_rad(nu);
 
 X=[a0;e0;i0;Raan0;argpeg0;nu];

X_t=Klp2SS(X);


end

function kep_param=SS2Kpl(X)


mu=3.986004415e14;
r=X(1:3);
 v=X(4:6);

 h=cross(r,v);
 
 n=cross([0; 0; 1],h);

 e_vec=((norm(v)^2-mu/norm(r))*r -(r'*v)*v)/mu;
 e=norm(e_vec);
 
 Energy=norm(v)^2/2-mu/norm(r);
 
 a=-mu/(2*Energy);
 
 p=a*(1-e^2);
 
 i=acos(h(3)/norm(h));
 Raan=acos(n(1)/norm(n));
 if n(2)<0
     Raan=2*pi-Raan;
 end
 
 argpe=acos((n'*e_vec)/(norm(n)*norm(e)));
 
 if e_vec(3)<0
     argpe=2*pi-argpe;
 end
 
 nu=acos(e_vec'*r/(norm(r)*norm(e)));
 
 if r'*v<0
     nu=2*pi-nu;
 end
 
kep_param=[a;e;i;Raan;argpe;nu];
 
end


function Xss=Klp2SS(X)

mu=3.986004415e14;

a=X(1);
e=X(2);
i=X(3);
Raan=X(4);
argpeg= X(5);
nu=X(6);


r=a*(1-e^2)/(1+e*cos(nu));

r_rsw=[r*cos(nu);r*sin(nu);0];

v_rsw=[sqrt(mu/(a*(1-e^2)))*-sin(nu);sqrt(mu/(a*(1-e^2)))*(e+1*cos(nu)) ;0];

CRAAN=[ cos(Raan) sin(Raan) 0;
       -sin(Raan) cos(Raan) 0;
          0          0      1];
    
Ci=[1    0       0;
    0  cos(i) sin(i);
    0 -sin(i) cos(i)];

Carg_peg=[ cos(argpeg) sin(argpeg) 0;
          -sin(argpeg) cos(argpeg) 0;
          0          0         1];

CRswi=Carg_peg*Ci*CRAAN;

r_i=CRswi'*r_rsw;
v_i=CRswi'*v_rsw;


Xss=[r_i;v_i];
end

    function [x]= norm_360_deg(x)
        if x<0
            
        while (x<0) 
        x=x+360;
        end
        
        elseif x>360
          aux=floor(x/360);
          x=x-aux*360;
        end
    end

function[rad]=norm_2pi_rad(rad)
        while (rad<0) 
        rad=rad +2*pi;
        end
end