function[DECsun,RAsun, SDsun, HPsun]=Sun_Ephemerids(JD,T,TE,Tau)

%Calculates the sun vector

%Input
%JD Julian Date
%T Century Julian Date
%TE Century Julian Date ephemerids time
%Tau Milenium Julian Date

%Output
%DECsun Declination of the Sun (ECI)
%RAsun  Right ascension of the Sun(ECI)
%SDsun  Semidiameter of Sun
%HPsun  Horizontal paralax of the Sun 

T2=T*T;
T3=T2*T;
TE2=TE*TE;
TE3=TE2*TE;
Tau2=Tau*Tau;
Tau3=Tau2*Tau;
Tau4=Tau3*Tau;
Tau5=Tau4*Tau;



%Nutacion 
[delta_psi,delta_eps, eps_0,eps]= Nutation(TE);

%introducir Aries
GHAAmean = norm_360_deg(280.46061837+ 360.98564736629*(JD)+0.000387933*T2-T3/38710000);
GHAAtrue = norm_360_deg(GHAAmean+delta_psi*cosd(eps));


%mean_longitude_sun
Lsun_mean=norm_360_deg(280.4664567+360007.6982779*Tau+0.03032028*Tau2+Tau3/49931-Tau4/15299-Tau5/1988000);
%Heliocentric longitude of Earth %Heliocentric latitude of Earth %Distance Earth_Sun(AU)
[Le,Be,Re]=Earth_parameters(Tau);
%Geocentric longitude of the Sun
Lsun_true=norm_360_deg(Le+180-0.000025);

%Geocentric laltitude of thew Sun
 beta=norm_360_deg(-Be);
 
%correction
Lsun_prime =norm_360_deg(Le+180-1.397*TE-0.00031*TE2);
beta = beta+0.000011*(cosd(Lsun_prime)-sind(Lsun_prime));

%Distance Earth_Sun

% dES = 149597870.691*Re;
    
%Apparent longitude of the Sun
lambda_sun = norm_360_deg(Lsun_true+delta_psi-0.005691611/Re);
	
%Right ascension of the Sun, apparent
	RAsun = (180/pi)*norm_2pi_rad(atan2((sind(lambda_sun)*cosd(eps)-tand(beta)*sind(eps)),cosd(lambda_sun)));
	
%Declination of the Sun, apparent 
	DECsun = (180/pi)*asin(sind(beta)*cosd(eps)+cosd(beta)*sind(eps)*sind(lambda_sun));
	
%GHA of the Sun
	%GHAsun = norm_360_deg(GHAAtrue-RAsun);
		
    
%Semidiameter of the Sun
	SDsun = (959.63/Re)/3600;

%Horizontal parallax of the Sun
	HPsun = (8.794/Re)/3600;    
    



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
end
