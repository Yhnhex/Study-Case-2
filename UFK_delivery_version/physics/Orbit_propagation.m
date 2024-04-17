function [Xmenos] = Orbit_propagation(X)
%orbit_PROPAGATION Equations to propagate the orbit

%Input
%X Intial state
%Output
%Xmenos: Derivates of the  X

%Parameters
mu=3.986044418e14; %en metros
%Re=6378137; %m

r=X(1:3,1);

Xmenos(1:3,1)=X(4:6,1);
Xmenos(4:6,1)=-mu*r/(norm(r)^3);   %shall include perturbations as J2 at least or ar least other source of randon perturbations to enhance simulation 
 
        
end

