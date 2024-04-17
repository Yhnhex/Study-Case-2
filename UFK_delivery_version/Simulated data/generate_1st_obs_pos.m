function [r, v] = generate_1st_obs_pos(rt, vt, d)
    % Initialize output arrays
    r = zeros(3, 1);
    v = zeros(3, 1);

    % Extract Keplerian elements from the target state vectors
    [a_t, ecc_t, inc_t, RAAN_t, argp_t, nu_t] = ijk2keplerian(rt, vt);

    % Constants, define as wanted
    radius_coverage_sph = 1000000; %this is a function of the magnitude
    initial_offset_o1_t = 10000;

    % Compute adjusted semi-major axis for observers
    a_obs = a_t + d;

    % Compute initial angular offset between the target and the first
    % observer
    ang = acosd((a_obs^2 + a_t^2 - initial_offset_o1_t^2) / (2 * a_obs * a_t));
    if ~isreal(ang)
        initial_angular_offset_o1t = 0;
    else
        initial_angular_offset_o1t = mod(acosd((a_obs^2 + a_t^2 - initial_offset_o1_t^2) / (2 * a_obs * a_t)), 360);
    end
    % Determine true anomaly for observer 1, with the offset stated
    % previously
    if a_obs > a_t
        nu_obs1 = mod(nu_t + initial_angular_offset_o1t, 360);
    else
        nu_obs1 = mod(nu_t - initial_angular_offset_o1t, 360);
    end

    % Convert observer 1's Keplerian elements to Cartesian coordinates
    [r, v] = keplerian2ijk(a_obs, ecc_t, inc_t, RAAN_t, argp_t, nu_obs1);
end
