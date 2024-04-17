function [LVLH_state,CLVi]=Sat_RSW_frame(Sat_state,def)

%Changes system of reference

    if def==1
        X=SS2Kpl(Sat_state);
    else
        X=Sat_state;
    end


mu=3.986004415e14;

a=X(1);
e=X(2);
i=norm_2pi_rad(X(3));
Raan=norm_2pi_rad(X(4));
argpeg= norm_2pi_rad(X(5));
nu=norm_2pi_rad(X(6));


r=a*(1-e^2)/(1+e*cos(nu));

r_rsw=[r*cos(nu);r*sin(nu);0];

v_rsw=[sqrt(mu/(a*(1-e^2)))*-sin(nu);sqrt(mu/(a*(1-e^2)))*(e+1*cos(nu)) ;0];


CLVLH=[cos(nu) sin(nu) 0;
      -sin(nu) cos(nu) 0;
       0          0    1];

CRAAN=[ cos(Raan) sin(Raan) 0;
       -sin(Raan) cos(Raan) 0;
          0          0      1];
    
Ci=[1    0       0;
    0  cos(i) sin(i);
    0 -sin(i) cos(i)];

Carg_peg=[ cos(argpeg) sin(argpeg) 0;
          -sin(argpeg) cos(argpeg) 0;
          0          0         1];
      
      
Ctrue_arg=[ cos(argpeg+nu) sin(argpeg+nu) 0;
          -sin(argpeg+nu) cos(argpeg+nu) 0;
                    0          0         1];      

      
CRswi=Carg_peg*Ci*CRAAN;


CLVi=Ctrue_arg*Ci*CRAAN;


r_LVLH=CLVLH*r_rsw;
v_LVLH=CLVLH*v_rsw;

LVLH_state=[r_LVLH;v_LVLH];


end