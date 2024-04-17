function init= find_initial_V3(meassurements,obv_position,q,n_observers,Dt_meass)

%Calculate initial vlues with less distance method

%INPUT
%meassurements: Vector with measurements
%obv_position: Observer position
%q: Quaternion of observer position
%n_observer: number of observers
%Dt_meass : dt between measurements

%OUTPUT
%init: Set of initial values


mu=3.986044418e14;


% Loop to pass the measurements form body to ECI frame.
for i=1:3  %Possible change to n points
    for j=1:n_observers
        rho_obv(1+n_observers*(i-1)+(j-1),:)=rot(meassurements(1+3*(j-1):3*j,i),q(1+n_observers*(i-1)+(j-1),:,:)',-1)';
    end
end


%Loop to obtain the intersection position of the observer estate
for i=1:3

x0=obv_position(1+n_observers*(i-1),:);

inter_point(i,:)=fminsearch(@(x)cost_fuction(rho_obv(1+n_observers*(i-1):n_observers*i,:),obv_position(1+n_observers*(i-1):n_observers*i,:),x),x0);

end

%inter_point

% Now speed calculation:

 r1=inter_point(1,:);
 r2=inter_point(2,:);
 r3=inter_point(3,:);
% 
 r1_nor=norm(r1);
 r2_nor=norm(r2);
 r3_nor=norm(r3);
% 
 C12=cross(r1,r2);
 C23=cross(r2,r3);
 C31=cross(r3,r1);
% 


N= r1_nor*C23 +r2_nor*C31 +r3_nor*C12;
D=C12 +C23 +C31;
S=r1*(r2_nor-r3_nor) + r2*(r3_nor-r3_nor) +r3*(r1_nor-r2_nor);

v2=sqrt(mu/(norm(N)*norm(D)))*(cross(D,r2)/r2_nor +S);


v2= ((r2-r1)/Dt_meass +(r3-r2)/Dt_meass +(r3-r1)/(2*Dt_meass) )/3;

 %v=[0;0;0];
 %v=(r2-r1)/Dt_meass
 init=[r2';v2']; 
 end

 %% Auxiliar functions

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


function J=cost_fuction(rho_obv,obv_position,P)


%Calculates cost function

%INPUT
%rho_obv: observation vector
%obv_position: Observer position
%P: Candidate to intersection point


%OUTPUT
%J cost function value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=size(rho_obv,1);
sum=0;

for i=1:n
sum=sum+ norm(cross(P-obv_position(i,:),rho_obv(i,:)))/(norm(rho_obv(i,:)));
end

J=sum/n;

end
