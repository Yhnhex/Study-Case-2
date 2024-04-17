function [r, v] = generate_Nobs_pos(ro_last, vo_last, rt, vt)
    % Initialize output arrays
    r = zeros(3, 1);
    v = zeros(3, 1);

    % Extract Keplerian elements from the target state vectors. Necessary
    % to to know if the target is in a higher or lower orbit than the
    % constellation (may be changed by another input)
    [a_t, ~, ~, ~, ~, ~] = ijk2keplerian(rt, vt);

    % Extract Keplerian elements from the last observer state vectors
    [a_last, ecc_last, inc_last, RAAN_last, argp_last, nu_last] = ijk2keplerian(ro_last, vo_last);

    % Constants, define as wanted
    radius_coverage_sph = 1000000; %this is a function of the magnitude
    offset_obs_obs = 1.5 * radius_coverage_sph;
    angular_offset_obs = mod(acosd(1 - ((offset_obs_obs)^2) / (2 * a_last^2)), 360);

    % Generate positions for additional observer
    
    if a_last > a_t
        nu_new = mod(nu_last + angular_offset_obs, 360);
    else
        nu_new = mod(nu_last - angular_offset_obs, 360);
    end
    [r, v] = keplerian2ijk(a_last, ecc_last, inc_last, RAAN_last, argp_last, nu_new);

end
