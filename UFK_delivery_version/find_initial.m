function init= find_initial(meassurements,obv_position,q,Dt_meass)

%Extracted from Gauss method of premliminary orbit determination from book:
% Howar D. Curtis, ORBITAL MECHANICS FOR ENGINEERING STUDENTS Third
% edition. 

%INPUT
%meassurements: Vector with measurements
%obv_position: Observer position
%q: Quaternion of observer position
%Dt_meass : dt between measurements

%OUTPUT
%init: Set of initial values

mu=3.986044418e14;

%rot(r,q,transform_direction)

rho1=rot(meassurements(1,:)',q(1,:)',-1)';
rho2=rot(meassurements(2,:)',q(2,:)',-1)';
rho3=rot(meassurements(3,:)',q(3,:)',-1)';

R1=obv_position(1,:);
R2=obv_position(2,:);
R3=obv_position(3,:);


tau1=-Dt_meass;
tau3=Dt_meass;

tau=2*Dt_meass;

%% lest star with algoritmh

p1=cross(rho2,rho3);
p2=cross(rho1,rho3);
p3=cross(rho1,rho2);

%zaaaaa=dot(p1,rho1)


D0=rho1*p1';
D11=R1*p1';
D12=R1*p2';
D13=R1*p3';
D21=R2*p1';
D22=R2*p2';
D23=R2*p3';
D31=R3*p1';
D32=R3*p2';
D33=R3*p3';




A=(1/D0)*(-D12*tau3/tau +D22 +D32*tau1/tau);
B=(1/6D0)*((D12*(tau3^2-tau^2)*tau3/tau +D32*(tau^2-tau1^2)*tau1/tau));

E=R2*rho2';

a=-(A^2 +2*A*E+ R2*R2');
b=-2*mu*B*(A + E);
c=-(mu*B)^2;


%r2_aux=roots([1 0 a 0 0 b 0 0 c])
%x=posroot(r2_aux)


r2_aux=fzero(@(x)x^8+a*x^6+b*x^3,(6378+500)*1e3)   %maybe roots
%r2_aux=fsolve(@(x)x^8+a*x^6+b*x^3,(6378+500)*1e3)


n_rho1=(1/D0)*(  (6*(D31*tau1/tau3 +D12*tau/tau3)*r2_aux^3 +mu*D31*(tau^2-tau1^2)*tau1/tau3 )/(6*r2_aux^3+mu*(tau^2-tau3^2)) -D11)
n_rho2=A+mu*B/r2_aux^3
n_rho3=(1/D0)*(  (6*(D13*tau3/tau1 -D23*tau/tau1)*r2_aux^3 +mu*D13*(tau^2-tau3^2)*tau3/tau1 )/(6*r2_aux^3+mu*(tau^2-tau1^2)) -D33)


r1= R1+n_rho1*rho1;
r2= R2+n_rho2*rho2
norm(r2)
%r2= R2+r2_aux*rho2
r3= R3+n_rho3*rho3;


f1= 1-1/2*mu*tau1^2/r2_aux^3;
f3=1-1/2*mu*tau3^2/r2_aux^3;
g1=tau1-mu*tau1^3/(6*r2_aux^3);
g3=tau3-mu*tau3^3/(6*r2_aux^3);

v2= (-f3*r1+f1*r3)/(f1*g3-f3*g1);


init=[r2';v2'];
end

function dir=rot(r,q,transform_direction)

%r vector to transform
%q quaternion
%transform_direction: Transformation direction 1== direc transformation 
                                              %-1== inverse transfor

%Cbi=[1-2*(q(2)^2+q(3)^2)   2*(q(1)*q(2)-q(4)*q(3))  2*(q(1)*q(3)+q(4)*q(2)) ;
 %    2*(q(1)*q(2)+q(4)*q(3))   1-2*(q(1)^2+q(3)^2)  2*(q(2)*q(3)-q(1)*q(4)) ;
  %   2*(q(1)*q(3)-q(4)*q(2))   2*(q(2)*q(3)+q(4)*q(1))  1-2*(q(1)^2+q(2)^2)];
 
Cbi=quat2rotm([q(4,1) q(1:3,1)']);
 
%det(Cbi) 

if transform_direction==1

 dir=Cbi*r;

else
    
    dir=Cbi'*r;
end

end
