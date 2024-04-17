
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultLineLineWidth',1.25) % LineWidth
set(groot,'defaultAxesFontSize',20) % Fontsize
   
o550 = load("500_550_offset_0.mat");
o600 = load("500_600_offset_0.mat");
o650 = load("500_650_offset_0.mat");
o700 = load("500_700_offset_0.mat");
o750 = load("500_750_offset_0.mat");
o800 = load("500_800.mat");
o850 = load("500_850.mat");
o550_2 = load("500_550_offset_0.mat");
o600_2 = load("500_600_offset_0.mat");
o650_2 = load("500_650_offset_0.mat");
o700_2 = load("500_700_offset_0.mat");
o750_2 = load("500_750_offset_0.mat");
o550_1 = load("500_550_1obs.mat");
o750_1 = load("500_750_1obs.mat");
TVIS_VECT = [o550.T_VIS_MEAN, o600.T_VIS_MEAN, o650.T_VIS_MEAN, o700.T_VIS_MEAN-200, o750.T_VIS_MEAN, o800.T_VIS_MEAN-600, o850.T_VIS_MEAN]
TVIS_VECT_2 = [o550_2.T_VIS_MEAN, o600_2.T_VIS_MEAN, o650_2.T_VIS_MEAN, o700_2.T_VIS_MEAN, o750_2.T_VIS_MEAN ]

period_vect = [o550.sim_params.total_sim_time,o600.sim_params.total_sim_time,o650.sim_params.total_sim_time,o700.sim_params.total_sim_time,o750.sim_params.total_sim_time]
distance = [50, 100, 150, 200, 250, 300, 350];
figure (1)
hold on
grid on
% plot( TVIS_VECT,LineStyle="none",Marker="+",Color='k')
plot( TVIS_VECT_2,LineStyle="none",Marker="X",Color='r')

%plot( period_vect,LineStyle="none",Marker="o",Color='k')
legend('$t_{vis}$')
%plot(d, TVIS_VECT./period_vect,LineStyle="none",Marker="diamond",Color='b')
xlabel('$d$ [km]')
ylabel('$t$ [s]')


hold off

figure(2)
hold on
grid on

plot(TVIS_VECT_2./period_vect*100,LineStyle="none",Marker="diamond",Color='b')
xlabel('$d$ [km]')
ylabel('$\frac{t_{vis}}{T_{orbit}}$ [\%]')


hold off


