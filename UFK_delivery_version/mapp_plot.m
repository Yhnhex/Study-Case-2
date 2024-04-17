clear all 
clc
close all


set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultLineLineWidth',1.25) % LineWidth
set(groot,'defaultAxesFontSize',20) % Fontsize



mode= 2;
% Initialize sun position according to current date
y=2023;
m=3;
d=19;
h=10;  
min=10;
s=54;

[JD, JDE, T,TE,Tau]=Julian_date(y,m,d,h,min,s); %Julian date transformation
[DECsun,RAsun, SDsun, HPsun]=Sun_Ephemerids(JD,T,TE,Tau);
    
rsun=[cosd(DECsun)*cosd(RAsun),cosd(DECsun)*sind(RAsun),sind(DECsun)]*1.496e+11;
    
 
% Simulation Parameters
%sim_params.sat_size = 1;  % Set your desired value
%sim_params.sub_cat = 1;   % Set your desired value
sim_params.deploy_panels = 0;  % Set your desired value
%sim_params.rt = [400, 0, 0]'*1000+6378000;
sim_params.qt = [-0.401437297624753;-0.578215887659600;0.239454457519217;0.668712229668289];
sim_params.ro = [500, 0, 0]*1000 + 6378000;

Hs =[400, 700, 1000, 1500, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]';

if mode == 1
    for i = 1:3
        sim_params.sat_size = i;  % Set your desired value
        for j = 1:3
            sim_params.sub_cat = j;   % Set your desired value
    %         RSO = Satellite;
    %          RSO=Sat_rand_generation(RSO,sim_params.sat_size, sim_params.sub_cat, sim_params.deploy_panels);
    
            for k = 1:size(Hs)
                sim_params.rt = [Hs(k), 0, 0]'*1000+6378000;
                %mapp(j,i, k) = real(magnitude_apparent1(sim_params.ro, sim_params.rt, rsun, sim_params.qt, RSO));
                d(k) = norm(sim_params.rt - sim_params.ro);
                for m = 1:100
                    RSO = Satellite;
                    RSO=Sat_rand_generation(RSO,sim_params.sat_size, sim_params.sub_cat, sim_params.deploy_panels);
    
                    mapp(m) = magnitude_apparent1(sim_params.ro, sim_params.rt, rsun, sim_params.qt, RSO);
                end
                mapp_map(j , i, k)=mean(real(mapp));
    
            end
        end
    end
    
    MAPP = reshape(mapp_map,9, 13);
    
    d=d/1000
    figure(3)
    hold on
    plot(d, MAPP(1,:))
    plot(d, MAPP(2,:))
    plot(d, MAPP(3,:))
    plot(d, MAPP(4,:))
    plot(d, MAPP(5,:))
    plot(d, MAPP(6,:))
    plot(d, MAPP(7,:))
    plot(d, MAPP(8,:))
    plot(d, MAPP(9,:))
    yline(4);
    title('Dependance between apparent magnitude and distance observer - RSO')
    ylabel('$m$ [-]')
    xlabel('$d$ [km]' )
    legend('1U', '3U','6U', 'Microsat 500mm' , 'Microsat 700mm', 'Microsat 1000mm', 'Sat 1250mm', 'Sat 1500mm', 'Sat 1800mm',Location='best')
    hold off
    
    figure(2)
    hold on
    plot(linspace(1,9,9),  MAPP( :, 1 ))
    plot(linspace(1,9,9),  MAPP( :, 2 ))
    plot(linspace(1,9,9),  MAPP( :, 3 ))
    plot(linspace(1,9,9),  MAPP( :, 4 ))
    plot(linspace(1,9,9),  MAPP( :, 5 ))
    plot(linspace(1,9,9),  MAPP( :, 6 ))
    plot(linspace(1,9,9),  MAPP( :, 7 ))
    plot(linspace(1,9,9),  MAPP( :, 8 ))
    plot(linspace(1,9,9),  MAPP( :, 9 ))
    plot(linspace(1,9,9),  MAPP( :, 10 ))
    plot(linspace(1,9,9),  MAPP( :, 11 ))
    plot(linspace(1,9,9),  MAPP( :, 12 ))
    plot(linspace(1,9,9),  MAPP( :, 13 ))
    title('Dependance between apparent magnitude and RSO size')
    ylabel('$m$ [-]')
    yline(4)
    xticks([1,2,3,4,5,6,7,8,9])
    xticklabels({'1U', '3U','6U', 'Microsat 500mm' , 'Microsat 700mm', 'Microsat 1000mm', 'Sat 1250mm', 'Sat 1500mm', 'Sat 1800mm'})
    legend('$d=$100 km', '$d=$200 km','$d=$500 km','$d=$1000 km','$d=$1500 km','$d=$2500 km','$d=$3500 km','$d=$4500 km','$d=$5500 km','$d=$6500 km','$d=$7500 km','$d=$8500 km','$d=$9500 km', Location='best')
    xlabel('RSO category' )
    hold off
elseif mode == 2
    % Simulation Parameters
    sim_params.ro = [600+ 6378, 0, 0]*1000 ;
    sim_params.rt = [500+ 6378, 0, 0]'*1000;


    RSO = Satellite;
    sim_params.sat_size =2;
    sim_params.sub_cat = 2;
    sim_params.deploy_panels = 0;
    RSO=Sat_rand_generation(RSO,sim_params.sat_size, sim_params.sub_cat, sim_params.deploy_panels);
    
    num_positions = 500;
    start_date = datetime(2023, 1, 1, 0, 0, 0);
    end_date = datetime(2023, 12, 31, 23, 59, 59);
    
    % Time vector
    time_vector = linspace(start_date, end_date, num_positions);
    
    % Preallocate matrix for Sun positions
    sun_positions = zeros(num_positions, 3);
    % Calculate Sun positions
    for i = 1:num_positions
        % Julian Date and other time parameters
        [JD, ~, T, TE, Tau] = Julian_date(time_vector(i).Year, time_vector(i).Month, ...
            time_vector(i).Day, time_vector(i).Hour, time_vector(i).Minute, time_vector(i).Second);
    
        % Calculate Sun ephemerides
        [DECsun, RAsun, ~, ~] = Sun_Ephemerids(JD, T, TE, Tau);
    
        % Convert polar coordinates to Cartesian coordinates
        sun_positions(i, :) = [cosd(DECsun) * cosd(RAsun), cosd(DECsun) * sind(RAsun), sind(DECsun)]*1.496e+11;
        p=(cross(sim_params.rt,sun_positions(1,:)));
        mapp(i) = real(magnitude_apparent1(sim_params.ro, sim_params.rt, sun_positions(i,:), sim_params.qt, RSO));
        costheta(i) = acos(dot(sun_positions(i,:),sim_params.rt)/(norm(sun_positions(i,:))*norm(sim_params.rt)));
        theta(i) = vec2angle360(sim_params.rt, sun_positions(i,:),p)
    end

% Assuming you already have the 'time_vector' and 'mapp' matrices

[sorted_theta,theta_index] = sort(theta,'ascend');
mapp_sorted = mapp(theta_index);
% Plot the apparent magnitude
figure(3)
hold on
grid on
plot(sorted_theta, mapp_sorted, Color='r')
xlim([0,360])

inf_indices = find(isinf(mapp));
xlabel('$\theta \quad [^\circ]$')
ylabel('$m$ [-]') 
yline(4)


figure(4)
hold on
plot(time_vector, mapp,Color='k')
grid on

inf_indices = find(isinf(mapp));
xlabel('Date')
ylabel('$m$ [-]') 
yline(4)

end


function a = vec2angle360(v1,v2,n)
x = cross(v1,v2);
c = sign(dot(x,n)) * norm(x);
a = atan2d(c,dot(v1,v2));
if a<0
    a=a+360;
end

end
