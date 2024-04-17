 %load libraries
addpath('lib')
%clc
clear sim_rsun
%% Simulation Parameters

mu=3.986044418e14;

% Set a date
y=sim_params.Year;
m=sim_params.Month;
d=sim_params.Day;
h=sim_params.Hour;  
min=sim_params.Min;
s=sim_params.Sec;

[JD, JDE, T,TE,Tau]=Julian_date(y,m,d,h,min,s); %Julian date transformation

% Control paramecters for generation of satellites
hmin=sim_params.hmin;
hmax=sim_params.hmax;

% Chose the satellite you want
sat_size=sim_params.sat_size;%randi([1,3]);
sub_cat=sim_params.sub_cat;%randi([1,4]);
deploy_panels=sim_params.deploy_panels;


%Propagation control
save_time=Sim_meas_save;  
dt_sim=0.1; %Fundamental time step


%% Target Satellite generation


RSO=Satellite;

% position velcity and atitude Randon generation
rt=sim_params.rt_init';

vtaux=(-100+200*rand(3,1));
vtaux=vtaux/norm(vtaux);

% vt=sqrt(mu/norm(rt))*cross(rt,vtaux)/norm(cross(rt,vtaux));
vt = [4413.29659583140, -3358.64341581046, -1375.48020792377]';
target_state=[rt',vt']';

qt= sim_params.qt; % rand_quat;

%Satellite Creation

RSO=Sat_rand_generation(RSO,sat_size, sub_cat, deploy_panels);

%% Observer initialization

%Noise parameters
sig_err=[50/3600*pi/180,50/3600*pi/180,0.02]*1;
orbit_err=1*[1000, 1000, 1000];
atti_err=1*[0.05 0.05 0.05]*pi/180;

%Random generation of every observer
t_vis=zeros(n_observers,1);
for i=1:n_observers

% ro=sim_params.ro_init';
% 
% voaux=(-100+200*rand(3,1));
% voaux=voaux/norm(voaux);
% 
% vo=sqrt(mu/norm(ro))*cross(ro,voaux)/norm(cross(ro,voaux));

if i == 1
    [ro, vo] = generate_1st_obs_pos(rt, vt, sim_params.d_1stObs_target);
    r_n_1 = ro;
    v_n_1 = vo;
else 
    [ro, vo] = generate_Nobs_pos(r_n_1, v_n_1, rt, vt);
    r_n_1 = ro;
    v_n_1 = vo;
end
qo(i,:)=rand_quat();

observer_state(i,:)=[ro',vo'];


%Position and attitude error addition

observer_state(i,:);

%%%%---THIS CODE INTRODUCES ERROR POSITION IN VELOCITY, NADIR and normal direction---
[state_ob_LV,CLVi]=Sat_RSW_frame(observer_state(i,:)',1);

state_ob_LV=real(state_ob_LV);
CLVi=real(CLVi);

ro_LV_err(i,:)=[normrnd(0,orbit_err(1)) ;normrnd(0,orbit_err(2)) ;normrnd(0,orbit_err(3))]';

ro_err(i,:)=(CLVi'*(ro_LV_err(i,:))')';

%%%%%%--------------------------------------------%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%--------------------------Atitude error-----------------%%%%%%%%%%%%%%
euler_angles= [normrnd(0,atti_err(1)) ;normrnd(0,atti_err(2)) ;normrnd(0,atti_err(3))];

deltaq=Quat_321euler(euler_angles);

qo_vir(i,:)= quatmultiply([deltaq(4);deltaq(1:3)]',[qo(i,4) qo(i,1:3)]);


qo_vir(i,:)=[qo_vir(i,2:4) qo_vir(i,1)];

%%%%------------------------------------------------------%%%%%%%%%%%%%%%

end

%% Simulation

for i=1:floor(total_sim_time/save_time)
    
    %Environment
    [DECsun,RAsun, SDsun, HPsun]=Sun_Ephemerids(JD,T,TE,Tau);
    
    rsun=[cosd(DECsun)*cosd(RAsun),cosd(DECsun)*sind(RAsun),sind(DECsun)];
    
    %Satellites propagation
    
    target_state=RG4(@(St)Orbit_propagation(St),target_state,save_time,dt_sim); 
    for j=1:n_observers    
    observer_state(j,:)=RG4(@(St)Orbit_propagation(St),observer_state(j,:)',save_time,dt_sim); 
    mapp(i, j) = real(magnitude_apparent1(observer_state(j,1:3), target_state(1:3), rsun*1.496e+11, qt, RSO));
    
    if mapp(i,j)<=4
        m_vis(i,j) = mapp(i,j);
        t_vis(j) = t_vis(j)+dt;
    else
        mvis(i,j) = 0;
    end

    end
    %Measuements simulation
     rt=target_state(1:3,1);
    
     rt=target_state(1:3,1);
     ro=observer_state(1:n_observers,1:3);
    
    [y(1:3*n_observers,i),Sim_FAI(1+(i-1)*n_observers:n_observers*i,1)] = Sim_measurement(RSO,rt,qt,ro,qo,rsun,sig_err,n_observers);
    
    
    %%%% Save varaibles %%%5
    
    %ro
    %ro_err
    ro_vir=ro+ro_err;
    %mapp(i) = magnitude_apparent1(observer_state(1:3), target_state(1:3), rsun*1.496e+11, qt, RSO);




    
    sim_ro(n_observers*(i-1)+1:n_observers*i,:)=ro_vir; %ro_vir; %ro;
    sim_qo(n_observers*(i-1)+1:n_observers*i,:)=qo_vir; %qo;  %qo_vir;
    sim_rt(i,:)=rt;
    sim_vt(i,:)=target_state(4:6,1);
    sim_rsun(i,:)=rsun;
    sim_time(i,1)=i*save_time;
    
    %next time stamp
    JD=JD+save_time/86400;
    T=JD/36525;
    TE=JDE/36525;
    Tau=0.1*TE;
     
    
    
end

%%%% Clear unused variables for main code%%%%%%%%%
clear JD JDE T TE Tau d DECsun deploy_panels dt_sim h hmax hmin HPsun i j m min observer_state qo qt RAsun ro RSO
clear rsun rt s sat_size save_time SDsun sig_err sub_cat T target_state vo voaux  vtaux


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Auxiliar functions


function q=rand_quat()

%Generates random quaternion

quat=-100+200*rand(4,1);

q=quat/norm(quat);


end


function r=sat_pos_gen(hmin,hmax)

%Generates random satellite position

Rt=6371000; %metre

h=hmin+(hmax-hmin)*rand;

a=h*1000+Rt;

phi=2*pi*rand;
elev= (pi/2)*(-pi/2 +pi*rand);


r=[a*cos(elev)*cos(phi); a*cos(elev)*sin(phi); a*sin(elev)];

end


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

function kep_param=SS2Kpl(X)

%Transform from position and velocity to keplerian parameters

mu=3.986004415e14;
r(1:3,1)=X(1:3);
v(1:3,1)=X(4:6);

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

function q=Quat_321euler(euler_angles)


%TRANFORM EULER ANGLES TO QUATERION

Cz=[cos(euler_angles(3)) sin(euler_angles(3)) 0;
   -sin(euler_angles(3)) cos(euler_angles(3)) 0;
           0                    0             1];
       
Cy=[cos(euler_angles(2)) 0 -sin(euler_angles(2));
          0              1           0         ;
   sin(euler_angles(2))  0  cos(euler_angles(2))];

Cx=[1            0                    0;
    0 cos(euler_angles(1)) sin(euler_angles(1));
    0 -sin(euler_angles(1)) cos(euler_angles(1))];



Cbi=Cx*Cy*Cz;

quat = rotm2quat(Cbi);

q=[quat(2:4)';quat(1)];

end


function[rad]=norm_2pi_rad(rad)

%NORMALIZE ANGLES
        while (rad<0) 
        rad=rad +2*pi;
        end
end