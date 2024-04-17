function[rad]=norm_2pi_rad(rad)

%NORMALIZE ANGLES
        while (rad<0) 
        rad=rad +2*pi;
        end
end