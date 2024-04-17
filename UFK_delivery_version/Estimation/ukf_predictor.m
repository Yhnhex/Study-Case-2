function [Xmenos,X1,Pmenos,X2]=ukf_predictor(X,P,Q,sim_time,dt)

%%% Peforms prediction step %%%%%%%%%%%

%INPUT
%X:  state
%P: covariance matrix
%Q: Process noise matrix
% sim_time: total simulation time of prediction step
% dt: fundamental step time

%OUTPUT
%        Xmenos: predicted state
%        X1: Sigma points predicted state
%        Pmenos:  Predicted covariance matrix
%        X2: transformed deviations


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L=numel(X);                                 %numer of states                               
alpha=1e-3;                                 %default, tunable
ki=0.01;                                    %default, tunable
beta=2;                                     %default, tunable
lambda=alpha^2*(L+ki)-L;                    %scaling factor
c=L+lambda;                                 %scaling factor
Wm=[lambda/c 0.5/c+zeros(1,2*L)];           %weights for means
Wc=Wm;
Wc(1)=Wc(1)+(1-alpha^2+beta);               %weights for covariance
c=sqrt(c);

X_i=sigmas(X,P,c);                            %sigma points around x
[Xmenos,X1,Pmenos,X2]=ut(X_i,Wm,Wc,L,Q,sim_time,dt);          %unscented transformation of process


end

function [y,X1,P,X2]=ut(X,Wm,Wc,n,Q,sim_time,dt)

%Input:
%        X: sigma points
%       Wm: weights for mean
%       Wc: weights for covraiance
%        n: numer of outputs of f
%        Q: additive covariance (Process noise matrix)
% sim_time: total simulation time of prediction step
%       dt: fundamental step time


%OUTPUT
%        y: transformed mean
%        X1: transformed smapling points
%        P: transformed covariance
%       X2: transformed deviations

L=size(X,2);
y=zeros(n,1);
X1=zeros(n,L);
for k=1:L                   
    X1(:,k)=RG4(@(St)State_propagation(St),X(:,k),sim_time,dt);       
    y=y+Wm(k)*X1(:,k);       
end
X2=X1-y(:,ones(1,L));
P=X2*diag(Wc)*X2'+Q;   

end

function X_i=sigmas(X,P,c)
%Sigma points around reference point
%Inputs:
%       x: reference point
%       P: covariance
%       c: coefficient
%Output:
%       X: Sigma points
A = c*chol(P)';
Y = X(:,ones(1,numel(X)));
X_i = [X Y+A Y-A];

end