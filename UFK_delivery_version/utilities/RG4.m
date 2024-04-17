function [Xsol] = RG4(funct,X,sim_time,dt)

%Runge Kutta 4 scheme for propagation

%Input
%funct Fuction to propagte
%X :Intial state
%sim_time: total time of propagation 
%dt  fundamental step time

%Output
%Xsol

n=floor(sim_time/abs(dt));

if n<1 
   dt=sim_time;
   n=1;
end



for i=1:n

%i;
  
k1=funct(X);
k2=funct(X+0.5*k1*dt);
k3=funct(X+0.5*k2*dt);
k4=funct(X+k3*dt);

Xsol= X + (dt/6)*(k1+2*k2+2*k3+k4);

X=Xsol;

end

%disp('job done')



end

