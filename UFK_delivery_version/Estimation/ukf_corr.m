function [X,P]=ukf_corr(Xmenos,Pmenos,X1,X2,z,R,observer_data,n_observers)

%Performs correction step

%INPUT
%Xmenos Predicted state
%Pmenos %Predicted covariance matrix
%X1 %Simga points of predicted state
%X2 transformed deviations
%z  Measuerement vector
%R % Measurement noise matrix
%measurement_data: Aditional data needed to compute expeted measurement (quaternion observer posiriotn etc)
%n_observers: Number of observers

%OUTPUT
%X Corrected state
%P Corrected covarince matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parameter initialization

L=numel(Xmenos);                            %numer of states
m=numel(z);                                 %numer of measurements
alpha=1e-3;                                 %default, tunable
ki=0.01;                                       %default, tunable
beta=2;                                     %default, tunable
lambda=alpha^2*(L+ki)-L;                    %scaling factor
c=L+lambda;                                 %scaling factor
Wm=[lambda/c 0.5/c+zeros(1,2*L)];           %weights for means
Wc=Wm;
Wc(1)=Wc(1)+(1-alpha^2+beta);               %weights for covariance
% c=sqrt(c);


[z1,Z1,P2,Z2]=ut(X1,Wm,Wc,m,R,observer_data,n_observers); %unscented transformation of measurments
P12=X2*diag(Wc)*Z2';                            %transformed cross-covariance
K=P12*inv(P2);
X=Xmenos+K*(z-z1);                              %state update
P=Pmenos-K*P12';                               %covariance update

end


function [y,Y,P,Y1]=ut(X,Wm,Wc,n,R,observer_data,n_observers)   


%Unscented Transformation
%Input:
%        
%        X: sigma points
%       Wm: weights for mean
%       Wc: weights for covraiance
%        n: numer of outputs of f
%        R: additive covariance
%   measurement_data: Additional data needed to calculate expteted measurement (POSITION, quaternion)
%   n_observer: Number of observers


%Output:
%        y: transformed mean
%        Y: transformed smapling points
%        P: transformed covariance
%       Y1: transformed deviations
L=size(X,2);
y=zeros(n,1);
Y=zeros(n,L);


ro=observer_data.sim_ro;
quat=observer_data.sim_qo;

for obv=1:n_observers

for k=1:L                   
    Y(1+(obv-1)*3:3*obv,k)=meassurement_function(X(:,k),ro(obv,:),quat(obv,:)); 
          
end

end

for k=1:L
  y=y+Wm(k)*Y(:,k);  
end

Y1=Y-y(:,ones(1,L));
P=Y1*diag(Wc)*Y1'+R;   

end

