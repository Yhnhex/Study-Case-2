function R = R_matrix_formation(n_observers,sigmas)

%Forms Measurement noise matrix based on number of observer

%INPUTS 
%n_observers : Number of observers
%sigmas: Standar deviation of every component of the measurement


%Outpus
%R: Noise matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:n_observers

    vec(1,1+(i-1)*3:i*3)=sigmas.^2;

end
R=diag(vec);



end

