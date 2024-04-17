function [Xmenos] = State_propagation(X)

%STATE_PROPAGATION Equations to propagate the state

%Input
%X Intial state
%Output
%Xmenos: Derivates of the  X



%Parameters
mu=3.986044418e14; %en metros
%Re=6378137; %m

r=X(1:3,1);

Xmenos(1:3,1)=X(4:6,1);
Xmenos(4:6,1)=-mu*r/(norm(r)^3);   %No mayor pertubation considered so far, becouse things is it possible to estimate?? Long term is possible 
%Xmenos(7,1)=0; 
        
end

