%% Plotting propurses Only

figure(1)
subplot(2,2,1);
plot (sim_time,sim_rt(:,1)/1000,'b*-','LineWidth',2,'MarkerSize',4);
hold on;
plot (t_vec,x_estimate/1000, 'r+-','LineWidth',2,'MarkerSize',4);
%grid on;
ax=gca;
ax.FontSize=16;
xlabel ('Time [s]','FontSize', 20,'interpreter','latex');
ylabel ('True {\it x} /Estimated {\it x} [km]','FontSize', 20,'interpreter','latex');
legend('True','Estimated')

subplot(2,2,3);
hold on;
plot (t_vec,error_x/1000,'LineWidth',2, Color='k');
%grid on;
ax=gca;
ax.FontSize=16;
xlabel ('Time [s]','FontSize', 20,'interpreter','latex');
ylabel ('{\it x} error [km]','FontSize', 20,'interpreter','latex');


subplot(2,2,2);
hold on;
plot (sim_time,sim_rt(:,2)/1000, 'b*-','LineWidth',2,'MarkerSize',4);
plot (t_vec,y_estimate/1000, 'r+-','LineWidth',2,'MarkerSize',4);
%grid on;
ax=gca;
ax.FontSize=16;
xlabel ('Time [s]','FontSize', 16,'interpreter','latex');
ylabel ('True {\it y} / estimated {\it y} [km]','FontSize', 20,'interpreter','latex');
legend('True','Estimated')

subplot(2,2,4);
hold on;
plot (t_vec,error_y/1000,'LineWidth',2, Color='k');
%grid on;
ax=gca;
ax.FontSize=16;
xlabel ('Time [s]','FontSize', 20,'interpreter','latex');
ylabel ('{\it y} error  [km]','FontSize', 20,'interpreter','latex');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)
subplot(1,2,1);    % (2,2,1)
plot (sim_time,sim_rt(:,3)/1000,'b*-','LineWidth',2,'MarkerSize',4);
hold on;
plot (t_vec,z_estimate/1000, 'r+-','LineWidth',2,'MarkerSize',4);
%grid on;
ax=gca;
ax.FontSize=16;
xlabel ('Time [s] ','FontSize', 20,'interpreter','latex');
ylabel ('Real {\it z} / Estimated {\it z} [km]','FontSize', 20,'interpreter','latex');
legend('True','Estimated')

subplot(1,2,2);   % (2,2,1)
hold on;
plot (t_vec,error_z/1000,'LineWidth',2, Color='k');
%grid on;
ax=gca;
ax.FontSize=16;
xlabel ('Time [s] ','FontSize', 20,'interpreter','latex');
ylabel ('{\it z} error [km]','FontSize', 20,'interpreter','latex');

% This part ADD Magnitude result plot

% subplot(2,2,3:4);
% %plot (sim_time, FAI,'b*-');
% hold on;
% plot (t_vec, Sim_FAI_1, 'b+-','LineWidth',2,'MarkerSize',4);
% plot (t_vec, Sim_FAI_2, 'r*-','LineWidth',2,'MarkerSize',4);
% %grid on;
% ax=gca;
% ax.FontSize=16;
% xlabel ('Time [s] ','FontSize', 20,'interpreter','latex');
% ylabel ('FAI','FontSize', 20,'interpreter','latex');

% subplot(2,2,4);
% hold on;
% plot (t_vec, error_FAI);
% %grid on;
% xlabel ('Tiempo [s] ');
% ylabel ('Error en FAI [-]');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(3)
subplot(2,2,1);
plot (sim_time,sim_vt(:,1)/1000,'b*-','LineWidth',2,'MarkerSize',4);
hold on;
plot (t_vec, Vx_estimate/1000, 'r+-','LineWidth',2,'MarkerSize',4);
%grid on;
ax=gca;
ax.FontSize=16;
xlabel ('Time [s] ','FontSize', 20,'interpreter','latex');
ylabel ('Real {\it Vx} / Estimated {\it Vx}  [km/s]','FontSize', 20,'interpreter','latex');
legend('True','Estimated')

subplot(2,2,3);
hold on;
plot (t_vec, error_Vx/1000,'LineWidth',2, Color='k');
%grid on;
ax=gca;
ax.FontSize=16;
xlabel ('Time [s] ','FontSize', 20,'interpreter','latex');
ylabel ('{\it Vx} error [km/s]','FontSize', 20,'interpreter','latex');

subplot(2,2,2);
hold on;
plot (sim_time, sim_vt(:,2)/1000, 'b*-','LineWidth',2,'MarkerSize',4);
plot (t_vec,  Vy_estimate/1000, 'r+-','LineWidth',2,'MarkerSize',4);
%grid on;
ax=gca;
ax.FontSize=16;
xlabel ('Time [s] ','FontSize', 20,'interpreter','latex');
ylabel ('Real {\it Vy} /  Estimated {\it Vy} [km/s]','FontSize', 20,'interpreter','latex');
legend('True','Estimated')

subplot(2,2,4);
hold on;
plot (t_vec, error_Vy/1000,'LineWidth',2, Color='k');
%grid on;
ax=gca;
ax.FontSize=16;
xlabel ('Time [s] ','FontSize', 20,'interpreter','latex');
ylabel ('{\it Vy} Error [km/s]','FontSize', 20,'interpreter','latex');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4)
subplot(1,2,1);
plot (sim_time, sim_vt(:,3)/1000,'b*-','LineWidth',2,'MarkerSize',4);
hold on;
plot (t_vec,Vz_estimate/1000, 'r+-','LineWidth',2,'MarkerSize',4);
%grid on;
ax=gca;
ax.FontSize=16;
xlabel ('Time [s] ','FontSize', 20,'interpreter','latex');
ylabel ('Real {\it Vz} / Estimated {\it Vz} [km/s]','FontSize', 20,'interpreter','latex');
legend('True','Estimated')

subplot(1,2,2);
hold on;
plot (t_vec,error_Vz/1000,'LineWidth',2, Color='k');
%grid on;
ax=gca;
ax.FontSize=16;
xlabel ('Time [s] ','FontSize', 20,'interpreter','latex');
ylabel ('{\it Vz} Error [km/s]','FontSize', 20,'interpreter','latex');


%%%%%%%%
figure(5)
hold on
plot(iter_vec,RMSE_x/1000,'LineWidth',2,  Color='r');
plot(iter_vec,RMSE_y/1000,'LineWidth',2, Color='b');
plot(iter_vec,RMSE_z/1000,'LineWidth',2,  Color='k');
%plot(iter_vec,RMSE_vx);
%plot(iter_vec,RMSE_vy);
%plot(iter_vec,RMSE_vz);
ax=gca;
ax.FontSize=16;
xlabel ('Number of iterations','FontSize', 20,'interpreter','latex');
ylabel ('RMSE in postionon [km]','FontSize', 20,'interpreter','latex');
legend('{\it x} component','{\it y} component','{\it z} component')
