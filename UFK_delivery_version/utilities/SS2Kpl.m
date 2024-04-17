function kep_param=SS2Kpl(X)

%Transform from position and velocity to keplerian parameters

mu=3.986004415e14;       %pensar en archivo de constantes??
r(1:3,1)=X(1:3);
v(1:3,1)=X(4:6);

 h=cross(r,v);
 
 n=cross([0; 0; 1],h);

 e_vec=((norm(v)^2-mu/norm(r))*r -(r'*v)*v)/mu;
 e=norm(e_vec);
 
 Energy=norm(v)^2/2-mu/norm(r);
 
 a=-mu/(2*Energy);
 
 p=a*(1-e^2);
 
 i=acos(h(3)/norm(h));
 Raan=acos(n(1)/norm(n));
 if n(2)<0
     Raan=2*pi-Raan;
 end
 
 argpe=acos((n'*e_vec)/(norm(n)*norm(e)));
 
 if e_vec(3)<0
     argpe=2*pi-argpe;
 end
 
 nu=acos(e_vec'*r/(norm(r)*norm(e)));
 
 if r'*v<0
     nu=2*pi-nu;
 end
 
kep_param=[a;e;i;Raan;argpe;nu];
 
end

