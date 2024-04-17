% Sim_config.m
clear all 
clc
close all

% Global Constants
mu=3.986044418e14;
Rt = 6878000;

% Debris Parameters
sim_params.sat_size = 2;   
sim_params.sub_cat = 3;    
sim_params.deploy_panels = 0;   
sim_params.rt_init = [500, 0, 0]*1000 + Rt;
sim_params.qt = [-0.401437297624753;-0.578215887659600;0.239454457519217;0.668712229668289];
sim_params.hmin = 400;
sim_params.hmax = 800;

% Observers Parameters
sim_params.n_observers = 2;  %
sim_params.d_1stObs_target = 200000;
sim_params.ro_init = [750, 0, 0] * 1000 + Rt;

% Simulation Parameters
sim_params.total_sim_time = 200%2* pi * sqrt (norm(sim_params.ro_init)^3/ mu) ;   
sim_params.Year = 2023;
sim_params.Month = 2;
sim_params.Day = 25;
sim_params.Hour = 15;
sim_params.Min = 0;
sim_params.Sec = 17;


    PLOT = 1;
MODE = 0;

if MODE == 0 % Just run the code once
    Main_Program

elseif MODE==1 % Run the code N times so that you get the mean of the t_vis
    tic
    N = 10;
    for ii = 1:N
        Main_Program
        T_VIS(ii, :)=t_vis;
        T_VIS_TOT (ii)=sum(t_vis);
        ss=ii
        MAPP(ii,:,:) = mapp(:,:);
    end
    T_VIS_MEAN = mean(T_VIS_TOT);
    toc
elseif MODE==2 % Run the code N times at M different observer altitudes
    tic
    h_obs = [550,600,650,700,750,800,850];
    sim_params.ro_init = [Hs(k), 0, 0]'*1000+6378000;
    N=5;
    for jj =1:length(h_obs)
        for ii = 1:N
            Main_Program
            T_VIS(ii, :)=t_vis;
            T_VIS_TOT (ii)=sum(t_vis);
            
        end
        T_VIS_MEAN(jj) = mean(T_VIS_TOT);
    end
    toc
end

% Call the main simulation code
% num_positions = 1000;
% 
% start_date = datetime(2023, 1, 1, 0, 0, 0);
% end_date = datetime(2023, 12, 31, 23, 59, 59);
% 
% % Time vector
% time_vector = linspace(start_date, end_date, num_positions);

% for ii = 1:num_positions
%         % Julian Date and other time parameters
%     sim_params.Year = time_vector(ii).Year;
%     sim_params.Month = time_vector(ii).Month;
%     sim_params.Day = time_vector(ii).Day;
%     sim_params.Hour = time_vector(ii).Hour;
%     sim_params.Min = time_vector(ii).Minute;
%     sim_params.Sec = time_vector(ii).Second;
%    
% Main_Program
% Mag_app(ii, :, :) = mapp(:,:);
% end


if PLOT == 1
    Figures
end
