function r=sat_pos_gen(hmin,hmax)

%Generates random satellite position

Rt=6371000; %metre

h=hmin+(hmax-hmin)*rand;

a=h*1000+Rt;

phi=2*pi*rand;
elev= (pi/2)*(-pi/2 +pi*rand);


r=[a*cos(elev)*cos(phi); a*cos(elev)*sin(phi); a*sin(elev)];

end