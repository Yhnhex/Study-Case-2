function [y] = meassurement_function(Xmenos,ro,quat)
%MEASSUREMENT_FUNCTION: Just calculate the expected measurements

%INPUT

%Xmenos= predicted state of RSO
%ro= observer position
%Quat= quaternion of observed


%OUTPUT
%y expected meassurements

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
robs=Xmenos(1:3,1)-ro';

uobs=robs/norm(robs);

y(1:3,1)=rot(uobs,quat',1);


% Simple form FAI based on estimation no contempling realtive position, the
% complex shall contemplate the relative postiion in the change of at least
% difused sPHERE. 


%y(4)=-26.7-2.5*log10(Xmenos(7)/(norm(robs)^2));

%y(4)=-26.7-2.5*log10(Xmenos(7)*f(rsun*uobs)/(norm(robs)^2));
end







function dir=rot(r,q,transform_direction)

%r vector to transform
%q quaternion
%transform_direction: Transformation direction 1== direc transformation 
                                              %-1== inverse transfor

Cbi=quat2rotm([q(4,1) q(1:3,1)']);
 

if transform_direction==1

 dir=Cbi*r;

else
    
    dir=Cbi'*r;
end

end



