function [JD, JDE, T,TE,Tau]=Julian_date(y,m,d,h,min,s)

%Transform Date to Julian Date format truncated in 2000 0.5

%input

%y =year with 4 digits
%m=mothn
%d=day
%h=hour
%min=minute
%s=second (with decimals)

%output
%JD Julian Date
%JDE Julian Date Efemerids time
%T Century Julian Date
%TE Century Julian Date Efermerids time
%TAU Milenium Julina Date


%Valid until 28 february 2100



dec_hour=h+min/60+ s/(3600);


if m<=2 
    y=y-1;
    m=m+12;
end

%JD=367*y -floor(1.75*(y+floor((m+9)/12))) + floor(275*m/9)+ d +dec_hour/24 -730531.5;
A=floor(y/100);
B=2-A+floor(A/4);
JD=floor(365.25*(y+4716)) +floor(30.6001*(m+1)) +d +B-1524.5 +dec_hour/24 -2451545;  %Fecha juliano desde el año 2000 0.5



TAI_minus_UTC=37;  %Needs to be updated with latest value, or value of the date (maybe a function shall be called to automized this)


%UT1_minus_UTC =-160.188e-3 % Value to update
delta_T = 32.184 +TAI_minus_UTC;

%delta_T =32.184 +TAI_minus_UTC -UT1_minus_UTC; %Total delta T shall be
%actualized


JDE= JD +delta_T/86400;


%Julian centuris/ ephemerids/ milleans
T=JD/36525;
TE=JDE/36525;
Tau=0.1*TE;
end 