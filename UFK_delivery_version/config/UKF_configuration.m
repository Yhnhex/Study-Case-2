classdef UKF_configuration
    
    properties
        dt %inner temporal step
        Q  % Uncertainty matrix
        R_sigma  % Measurement matrix
        Decimation  % Number of data point to save (based on )
        max_iter  %maximum number of back propagations

    end
    
    methods
        function obj = UKF_configuration()  %Defoult config
            
            %data
            vel = (0.1*dt)^2; 
            pos = (0.05*dt^2)^2; 
           


            %intialization
            obj.dt = 0.1;
            obj.Q = [pos 0 0 0 0 0 ;
                    0 pos 0 0 0 0 ;
                    0 0 pos 0 0 0 ;
                    0 0 0 vel 0 0 ;
                    0 0 0 0 vel 0 ;
                    0 0 0 0 0 vel];

            obj.R_sigma= 0.01;

            obj.Decimation = 100;
            obj.max_iter = 5;


        end
        
        %function outputArg = method1(obj,inputArg)  % por si toca cambiar
         %cosas de la configuracion en mitas
            
        %end
    end
end

