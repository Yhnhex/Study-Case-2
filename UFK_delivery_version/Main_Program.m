
%% Main Code of the Uncested Kalman Filter

addpath('Simulated data')
addpath('Simulated data/lib')

tic % Time conter



%Constant initalization
Rt=6378e3; %km  % Earth's radius
mu=3.986004415e14;  % Earth's gravitational parameter

%% Control data and Status
%control

%Total sim time
total_sim_time=sim_params.total_sim_time;  % Insert here total simulation time

%Filert propagation and measurment control

dt=0.1; % fundamental dt of propagator
prog_time=0.1; %Defines the duration of the propagation step (and the tiime step to save results), shall be equar or less than DtMeasa
DtMeas=0.1; % Time between measures
Sim_meas_save=0.1;  % Insert here dt between measurements (for data generation)  DtMeas=Sim_meas_save


% Filter options
n_observers=sim_params.n_observers;  %
max_iter=5;     %Set maximum number of back-propagation steps




%%  import Real data or  generate simulated data 

%Load here your real or simulated data or use my random generator

Data_Simulation   %This code generates and propagates the position of all satelites

%load sim_data_1.mat


%%%%----Code to introduce needed data into the code efficiently (I think)%%

%--------------------CHANGE THIS AS NEEDED-----------------------------%%%%

measurement_data=table; %COMPLETE THIS EXPLANATION

for i=1:n_observers: size(sim_rsun,1)*n_observers

sim_rsun(i:i+n_observers-1,:)=ones(n_observers,3).*sim_rsun(1+(i-1)/n_observers,:);

end


measurement_data=addvars(measurement_data,sim_ro,sim_qo,sim_rsun);
%%%%-----------------------------------------------------------------%%%%%%

%% Kalman State initialization
  
%Diferent methods select the one that you want (Just comment or uncomment)


%%%%%-------RANDOM INITIALIZATION--------%%%%%%%%%%%%%%%%

r0=sat_pos_gen(500,800);
v0aux=(-100+200*rand(3,1));
v0aux=v0aux/norm(v0aux);
 
v0=sqrt(mu/norm(r0))*cross(r0,v0aux)/norm(cross(r0,v0aux));

X0=[r0;v0];
 
 
%%%%%-------RANDOM INITIALIZATION AS NEAR AS YOU WANT FROM RSO--------%%%%%%%%%%%%%%%%

%  X0 =[ sim_rt(1,:)'+500e3*rand(3,1); sim_vt(1,:)'+200*rand(3,1)];   %
% X0 =[ sim_rt(1,:)'; sim_vt(1,:)'];   %




%%%%%%%%%-------------------GAUSS_METHOD---------------------%%%%%%%%%%%

% gauss_mess=[y(1:3,1)'; y(4:6,2)'; y(1:3,3)'];
% gauss_atti=[sim_qo(1,:);sim_qo(2+n_observers*1,:);sim_qo(1+n_observers*2,:)];
% obv_poss=[sim_ro(1,:);sim_ro(2+n_observers*1,:);sim_ro(1+n_observers*2,:)];
% 
% check=sim_rt(2,:)/norm(sim_rt(2,:))
% check2=norm(sim_rt(2,:))
% 
% X0=find_initial(gauss_mess,obv_poss,gauss_atti,DtMeas);
% 
% X0(1:3)-sim_rt(2,:)'
% 
% X=X0;

%%%%%----- INITIALIZATION WITH METHOD 2 (LINE INTERSECTION)--------%%%%%
% mess=[y(:,1),y(:,2),y(:,3)];
% atti=sim_qo(1:n_observers*3,:);
% obv_poss=sim_ro(1:n_observers*3,:);

%X0=find_initial_V2(mess,obv_poss,atti,n_observers,DtMeas);


%%%%%----- INITIALIZATION WITH METHOD 3 (Minimum distant)--------%%%%%
% mess=[y(:,1),y(:,2),y(:,3)];
% atti=sim_qo(1:n_observers*3,:);
% obv_poss=sim_ro(1:n_observers*3,:);
%X0=find_initial_V3(mess,obv_poss,atti,n_observers,DtMeas);   % Needs improve


X=X0;

%% UKF PARAMETERS INITIALIZATION

%%%---Initial covariance matrix----%%%%
 %Set a guess value for initial error in position and velocity
 
sigma_pos=1000/3*1e3;  
sigma_vel=2.67e3;%2.67e3;%1e3;

P = [sigma_pos^2 0 0 0 0 0 ;
     0 sigma_pos^2 0 0 0 0 ;
     0 0 sigma_pos^2 0 0 0 ;
     0 0 0 sigma_vel^2 0 0 ;
     0 0 0 0 sigma_vel^2 0 ;
     0 0 0 0 0 sigma_vel^2];


%%%%%-----Process noise---------%%%%%%%

%intoduce a stimation of forces disturbances and how it affects position and velocity propagation

vel=(0.1*dt)^2; 
pos=(0.05*dt^2)^2; 

 Q=[pos 0 0 0 0 0 ;
     0 pos 0 0 0 0 ;
     0 0 pos 0 0 0 ;
     0 0 0 vel 0 0 ;
     0 0 0 0 vel 0 ;
     0 0 0 0 0 vel];


%%%%%----- Measurement noise Matrix formation---%%%%%

sigmas=[0.01, 0.01, 0.01];  % Set noise in vector component (Need to give notes)
R = R_matrix_formation(n_observers,sigmas);



%% UFK Algorithm

Meass_status =0;
j=0;

for k=1:max_iter
    

%%%%-----This piece controls the back propagation-----%%%%%%%%   
iter_vec(k)=k; %Counter to plot and save for every iteration step (not really needed)

    if k==max_iter
        back=0;
    else 
        back=1;
    end
 %%%-----------------------------------%%%%%%%%   
    
 
 %%------Main Loop starts here---------%%%%%%%% 
for i=1:floor(total_sim_time/prog_time)   
    
    if i<2 % Only for saving propourses
    X_estim(:,i)=X;
    
    else
    
    
	% 1) Predicción Step
    
   [Xminus,X1,Pmenos,X2]=ukf_predictor(X,P,Q,prog_time,dt);
   
   
 %%-----This pieces chesks for correction step----%%% 
   j=j+1;
   
   if (j==DtMeas/prog_time)      
      Meass_status =1;
      j=0;
   else
      Meass_status = 0;
   end
   
%%-------------------------------------------%%%%
   
   if (Meass_status == 1)
     
   % 2) Correction step if there is measurement

    
    meass=y(:,i);  %I don't Know why I introduced the measurement like this
    
    
    [X,P]=ukf_corr(Xminus,Pmenos,X1,X2,meass,R,measurement_data(1+(i-1)*n_observers:i*n_observers,:),n_observers);

    
   else
      
      X= Xminus;
      P = Pmenos;
      
   end
   
   %sava states
  
   end   
    
%%%% Saving results of every step in filter    

     X_estim(:,i)=X;
     
     
     x_estimate(i) =X(1);
     error_x(i) = x_estimate(i) - sim_rt(i,1);
     y_estimate(i) = X(2);
     error_y(i) = y_estimate(i) - sim_rt(i,2);
    z_estimate(i) = X(3);
     error_z(i) =z_estimate(i) - sim_rt(i,3);
     
   Vx_estimate(i) = X(4);
   error_Vx(i) = Vx_estimate(i) - sim_vt(i,1);
   Vy_estimate(i) = X(5);
   error_Vy(i) = Vy_estimate(i) - sim_vt(i,2);
   Vz_estimate(i) = X(6);
   error_Vz(i) = Vz_estimate(i) - sim_vt(i,3);
   
   
  %This saves some simulated light curves,  Coment if not save or generated
%    Sim_FAI_1(i)=Sim_FAI(1+(i-1)*n_observers,1);
%    Sim_FAI_2(i)=Sim_FAI(i*n_observers,1);
%    


% Saves time to plot porpouses
t_vec(i)=prog_time*i;
   

end

%END OF MAIN LOOP


%%%%%---RMSE CALCULATION OF EVERY BACK-PROG ITERATION---%%%%
RMSE_x(k)=sqrt(sum(error_x.^2)/(total_sim_time/prog_time));
RMSE_y(k)=sqrt(sum(error_y.^2)/(total_sim_time/prog_time));
RMSE_z(k)=sqrt(sum(error_z.^2)/(total_sim_time/prog_time));
RMSE_vx(k)=sqrt(sum(error_Vx.^2)/(total_sim_time/prog_time));
RMSE_vy(k)=sqrt(sum(error_Vy.^2)/(total_sim_time/prog_time));
RMSE_vz(k)=sqrt(sum(error_Vz.^2)/(total_sim_time/prog_time));

%%%%%--------------------------------------------------%%%%

%%%%%---MORE RMSE CALCULATION OF EVERY BACK-PROG ITERATION---%%%%
sum_pos=0;
sum_vel=0;
for count1=1:size(error_x,2)
 sum_pos=sum_pos+[error_x(count1),error_y(count1),error_z(count1)]*[error_x(count1);error_y(count1);error_z(count1)];
 sum_vel=sum_vel+[error_Vx(count1),error_Vy(count1),error_Vz(count1)]*[error_Vx(count1);error_Vy(count1);error_Vz(count1)];
end

RMSE_pos(k)=sqrt(sum_pos/(total_sim_time/prog_time));
RMSE_velocity(k)=sqrt(sum_vel/(total_sim_time/prog_time));

%%%%%---MORE RMSE CALCULATION OF EVERY BACK-PROG ITERATION BUT ONLY IN THE LAST 30 SECONDS OF SIMULATION---%%%%
if total_sim_time > 30
    sum_pos_30=0;
    sum_vel_30=0;
    lag=30/prog_time;
    
    pos_err_30=[error_x(end-lag:end)',error_y(end-lag:end)',error_z(end-lag:end)'];
    vel_err_30=[error_Vx(end-lag:end)',error_Vy(end-lag:end)',error_Vz(end-lag:end)'];
    
    for ct2=1:size(pos_err_30,1)
     sum_pos_30=sum_pos_30+pos_err_30(ct2)*pos_err_30(ct2)';
     sum_vel_30=sum_vel_30+vel_err_30(ct2)*vel_err_30(ct2)';
    end
    
    RMSE_30s_pos(k)=sqrt(sum_pos_30/(lag));
    RMSE_30s_velocity(k)=sqrt(sum_vel_30/(lag));
end
%%%%%------------------------------------------------------------%%%%

%%%%---------BACK PROPAGATIONS PROCESSS---------------------%%%%%

 if back==1
    [X,X1,P,X2]=ukf_predictor(X,P,Q,total_sim_time,-dt);
    P=P*10;  %This artificially increases the covariance matrix, for one observer is better to keep as P=P;
 end
  
%%%%------------------------------------------------------------%%%%

end


toc  %Finish of the algorithm 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Auxiliar functions


function r=sat_pos_gen(hmin,hmax)

% This randomize generates the initial point

Rt=6371000; %metre

h=hmin+(hmax-hmin)*rand;

a=h*1000+Rt;

phi=2*pi*rand;
elev= (pi/2)*(-pi/2 +pi*rand);


r=[a*cos(elev)*cos(phi); a*cos(elev)*sin(phi); a*sin(elev)];

end
