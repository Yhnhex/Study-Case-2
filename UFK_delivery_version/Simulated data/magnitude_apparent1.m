function mapp = magnitude_apparent1(ro_vir, rt, rsun, qt, SO)
    phi_sun_vis = 455;
    alpha = 1;
    Rt=6378e3;

    % Number of observers
    n_observers = size(ro_vir, 1);

    for j = 1:n_observers
        % Convert Cartesian to spherical coordinates
        [az, el, z] = cart2sph(ro_vir(j, 1), ro_vir(j, 2), ro_vir(j, 3));

        % Vector from observer to target
        d = rt' - ro_vir(j, :);
        % Rotate vector to observer's local frame
        %rho_obs_uen = eul2rotm([az, el, 0]) * d';
        rho_obs_uen = d';
        % Normalize vectors
        u_obs_I = normr(-d);
        u_sun_I = normr(rsun - rt');

        % Check if the target is in eclipse
        angle_target_sun = real(acos(dot(rt, rsun)/(norm(rsun) * norm (rt))));
        eclipse_angle = asin(Rt/norm(rt));
        if angle_target_sun > (pi-eclipse_angle) || (angle_target_sun < (eclipse_angle + pi) && angle_target_sun > (pi-eclipse_angle))
            % Target is in eclipse, set solar flux to zero
            fobs = 0;
            
        else
            % Initialize apparent magnitude
            fobs = 0;

            % Loop over surface elements
            for k = 1:6
                % Rotate surface normal to inertial frame
                u_n_I = (quat2rotm(qt') * SO.Normals(k, :)')';

                % Compute angles between surface normal, observer's direction, and Sun direction
                angle_obs = acos(dot(u_n_I, u_obs_I));
                angle_sun = acos(dot(u_n_I, u_sun_I));

                % Check if either angle is greater than π/2
%                 if (angle_obs > pi/2 && angle_obs < 3*pi/2) || (angle_sun > pi/2 && angle_sun < 3*pi/2)
%                     % No light reflected toward the observer
%                     fsun = 0;
%                     break
%                 else
                    % Compute reflected and diffuse components
                    u_esp_I = 2 * dot(u_n_I, u_sun_I) * u_n_I - u_sun_I;
                    rho_esp = SO.Cesp(k) * dot(u_obs_I, u_esp_I)^alpha / dot(u_sun_I, u_n_I);
                    rho_dif = SO.Cdif(k) / pi;

                    % Compute solar flux
                    fsun = phi_sun_vis * (rho_dif + rho_esp) * dot(u_n_I, u_sun_I);
%                 end

                % Accumulate flux from each surface element
                fobs = fsun * SO.Areas(k) * dot(u_n_I, u_obs_I) / norm(d)^2 + fobs;
            end
        end

        % Calculate apparent magnitude for the observer
        mapp(j) = -26.7 - 2.5 * log10(fobs / phi_sun_vis);
    end
end
