function [X_data,P_matrix] = Debri_tracking(UKF_cong,Sim_params,X0,P0, measurement, obsever_data,save_iter)   %SEPARAR MEASUREMENT DE OBSERVER_DATA



%De la Sim_config (Sim_params)  n_observers, Dt_medidas

%Initialization 

 n_observers=Sim_params.n_observers;
 sigmas=[UKF_cong.R_sigma, UKF_cong.R_sigma, UKF_cong.R_sigma];
 R = R_matrix_formation(n_observers,sigmas);

 if Dt_medidas<UKF_cong.Decimation*UKF_conf.dt
     prog_time=Dt_medidas;
 else
     prog_time=UKF_cong.Decimation;
 end

X=X0;
P=P0;

%UKF loop 
j=0;
L=1;

for k=1:UKF_cong.max_iter


    if k==max_iter
        back=0;
    else 
        back=1;
    end


    for i=1:floor(sim_params.total_sim_time/prog_time)   


        [Xminus,X1,Pmenos,X2]=ukf_predictor(X,P,UKF.conQ,prog_time,UKF_cong.dt);
        
         j=j+1;
        
        if (j==DtMeas/prog_time)   
        
            j=0;
            [X,P]=ukf_corr(Xminus,Pmenos,X1,X2,measurement(:,L),R,obsever_data(1+(L-1)*n_observers:i*n_observers,:),n_observers);  %me he quedao en measurement data cambiar por observer data
            L=L+1;
        
        else
        
         X = Xminus;
         P = Pmenos;
        end

    if save_iter==1
    X_data(:,i,k) = X;
    P_matrix(:,:,i,k) = P;
    else

        if back==0
             X_data(:,i) =X;
             P_matrix(:,:,i) =P;
        else
        end
    end

    end

%Performs_back_propagation (if needed)
 if back==1
    [X,X1,P,X2]=ukf_predictor(X,P,Q, sim_params.total_sim_time,-UKF_conf.dt);
    P=P*10;  %This artificially increases the covariance matrix, for one observer is better to keep as P=P;
 end

end

