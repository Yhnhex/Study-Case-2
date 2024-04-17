function [y,FAI] = Sim_measurement(RSO,rt,qt,ro,qo,rsun,sig_err,n_observers)


y=zeros(3*n_observers,1);  %Initializes size of measurement vector

for i=1:n_observers

%previos calculations in target reference frame
rob=rot(ro(i,:)',qt,1);
rsunb=rot(rsun',qt,1);
rtb=rot(rt,qt,1);
robs=rob-rtb;
uobs=robs/norm(robs);

%vector, direction calculation

rtbo=rot(rt,qo(i,:)',1);  %in observer reference frame
robo=rot(ro(i,:)',qo(i,:)',1);

uobs_obs= (rtbo-robo)/norm(rtbo-robo);

phi=asin(uobs_obs(3)) + normrnd(0,sig_err(1));   % Cambiar error por componentes de velocidad y la principal fuente en la direccion que deberia ser desde el calculo del plano orbital
lambda= atan2(uobs_obs(2),uobs_obs(1))+ normrnd(0,sig_err(2));
%Appearent magnitude



dir_meas=[cos(phi)*cos(lambda); cos(phi)*sin(lambda); sin(phi)];

for j=1:6
       
     
       if RSO.Normals(j,:)*rsunb <=0 || RSO.Normals(j,:)*uobs <=0
       
         rho_spec(j)=0;
         rho_dif(j)=0;
         rho_total(j)=0;
         Fobs(j)=0; 
         
           
       elseif RSO.Normals(j,:)*rsunb >0 && RSO.Normals(j,:)*uobs >0
          
           
        rho_spec(j)=spec_calculation(RSO.Normals(j,:),RSO.alpha,RSO.Cesp(j),rsunb,uobs);  % Mirar esto....
        
        rho_dif(j)=RSO.Cdif(j)/pi;
        
        rho_total(j)=rho_dif(j)+rho_spec(j);
         
        
        Fobs(j)=rho_total(j)*RSO.Areas(j)*(RSO.Normals(j,:)*rsunb)*(RSO.Normals(j,:)*uobs);
       
        
       end
       
       FAI(i)=sum(Fobs);
       m=-26.7 -2.5*log10(sum(Fobs)/(norm(robs))^2)+ normrnd(0,sig_err(3));  %+NOISE
       
end

% Saving the measurements    

%y(1+(i-1)*4 :i*4 ,1)=[dir_meas', m];
y(1+(i-1)*3 :i*3 ,1)=[dir_meas'];

end


end

function dir=rot(r,q,transform_direction)

%Change a vector reference system given the quaterion

%Imput
%r vector to transform
%q quaternion
%transform_direction: Transformation direction 1== direc transformation 
                                              %-1== inverse transfor

%Output
%dir: Solution

Cbi=quat2rotm([q(4,1) q(1:3,1)']);
 
if transform_direction==1

 dir=Cbi*r;

else
    
    dir=Cbi'*r;
end

end


function  spec=spec_calculation(Normal,alpha,Cesp,rsun,uobs)

%This fuction calculates the speculr refelction

%INPUTS
%Normal: Normal direction of the area
%alpha % Absortaance
%Cesp especular coefficient
%rsun  sun vector
%uobs vector from satelite to observer

%OUTPUT
%Spec: Specular reflection value

uspec=2*(Normal*rsun)*Normal' -rsun;

if uobs'*uspec<0 
    spec=0;
else
spec=Cesp*((uobs'*uspec)^alpha)/(Normal*rsun);
end


end

