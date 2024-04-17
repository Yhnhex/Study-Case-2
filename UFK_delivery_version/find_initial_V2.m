function init= find_initial_V2(meassurements,obv_position,q,n_observers,Dt_meass)

%Calculate initial vlues with intersection method

%INPUT
%meassurements: Vector with measurements
%obv_position: Observer position
%q: Quaternion of observer position
%n_observer: number of observers
%Dt_meass : dt between measurements

%OUTPUT
%init: Set of initial values


if n_observers==2

rho1_ob1=rot(meassurements(1:3,1),q(1,:)',-1)';
rho1_ob2=rot(meassurements(4:6,1),q(2,:)',-1)';

rho2_ob1=rot(meassurements(1:3,2),q(1+n_observers,:)',-1)';
rho2_ob2=rot(meassurements(4:6,2),q(2+n_observers,:)',-1)';

rho3_ob1=rot(meassurements(1:3,3),q(1+n_observers*2,:)',-1)';
rho3_ob2=rot(meassurements(4:6,3),q(2+n_observers*2,:)',-1)';

R1_ob1=obv_position(1,:);
R1_ob2=obv_position(2,:);

R2_ob1=obv_position(1+n_observers,:);
R2_ob2=obv_position(2+n_observers,:);

R3_ob1=obv_position(1+n_observers*2,:);
R3_ob2=obv_position(2+n_observers*2,:);

%%%% lest star with algoritmh

%First  point equation calculation

inter_point1=Line_intersec(rho1_ob1,R1_ob1,rho1_ob2,R1_ob2);
inter_point2=Line_intersec(rho2_ob1,R2_ob1,rho2_ob2,R2_ob2);
inter_point3=Line_intersec(rho3_ob1,R3_ob1,rho3_ob2,R3_ob2);

v=((inter_point2-inter_point1)/Dt_meass + (inter_point3-inter_point2)/Dt_meass)/2

r1=inter_point1;
r2=inter_point2;
r3=inter_point3;

r1_nor=norm(r1);
r2_ror=norm(r2);
r3_nor=norm(r3);

C12=cross(r1,r2);
C23=cross(r2,r3);
C31=cross(r3,r1);

%norm(r1/r1_nor)

check=dot(r1/r1_nor,C23);

%v=[0;0;0];
init=[inter_point1;v];
else


end




end

%%%%%% Auxiliar functions

function dir=rot(r,q,transform_direction)

%r vector to transform
%q quaternion
%transform_direction: Transformation direction 1== direc transformation 
                                              %-1== inverse transfor
 
Cbi=quat2rotm([q(4,1) q(1:3,1)']);
 
%det(Cbi) 


if transform_direction==1

 dir=Cbi*r;

else
    
    dir=Cbi'*r;
end

end


function inter_point=Line_intersec(vec1,point1,vec2,point2)

%Compute the intersection point given a line using a point and a direction
%vector

[A_line1,B_line1]=line_equation(vec1,point1);
[A_line2,B_line2]=line_equation(vec2,point2);

%Creation of system of equation

A_sys= [A_line1;
        A_line2(1,:)];
B_sys=[B_line1;
       B_line2(1,:)];


inter_point = linsolve(A_sys,B_sys);

end

function [A,B]=line_equation(vec,point)


%It change the equation of a line form the point a direction to equation as
%the intersection of two planes using the following system of equaitons
%
% a1x+b1y+c1z+D1=0
% a2x+b2y+c2z+D2=0
%
% The output is A wichc is a matrix conteinin the folowing values
%  A=[a1,b1,c1;
%    a2,b2,c2]
%
% B=[-D1;
%    -D2]
%


rand_vec= -1 +2*rand(1,3);

rand_vec=rand_vec/(norm(rand_vec));

while norm(cross (vec,rand_vec))<1e-3

    rand_vec= -1 +2*rand(1,3);

    rand_vec=rand_vec/(norm(rand_vec));

end

normal_1=cross(vec,rand_vec)/norm(cross(vec,rand_vec));
normal_2=cross(vec,normal_1);

D1=-dot(point,normal_1);
D2=-dot(point,normal_2);

A=[normal_1; normal_2];
B=[-D1;-D2];


end