%{
17. Compute Surface Dose for OAR
Description: Write a function to compute the dose on the surface of the OAR. Compute the hottest and coldest
dose and locations.
Test: Plot the result as a colored surface with a ‘colorbar’ showing a color scale, mark the extremes on the
surface plot. Analyze your findings with respect to dosimetric objectives.
Hint: Consider using the “ellipsoid” function to get surface points and patches on the ellipsoid. Consider “surf”
or “mesh” with “colorbar” for plotting.
%}

function [] = q17_compute_surface_dose_for_OAR()
    oar_center = [0, 30, 45];       % Center of the OAR
    oar_semi_axes = [15, 25, 15];   % Semi-axes of the ellipsoid
    dose_center = [0, 0, 0];        % Isocenter (for simplicity)
    % [oar_doses, OAR_min_dose, OAR_max_dose] = q14_compute_dose_for_OAR();
    OAR_min_dose = 0.00;
    OAR_max_dose = 0.91;
    OAR_grid = readmatrix('grid_for_OAR.csv');
    oar_doses = csvread('oar_doses2.csv');

    % Generate OAR surface points
    [X, Y, Z] = ellipsoid(oar_center(1), oar_center(2), oar_center(3), ...
                          oar_semi_axes(1), oar_semi_axes(2), oar_semi_axes(3), 50);

    % Flatten surface points into a list
    surface_points = [X(:), Y(:), Z(:)];
    num_points = size(surface_points, 1);

    % Compute dose at each surface point
    D0 = 100; % Base dose at the isocenter
    alpha = 0.05;
    dose = zeros(num_points, 1);

    for i = 1:num_points
        % Compute distance from the beam center (isocenter)
        r = norm(surface_points(i, :) - dose_center);
        % Compute dose using an exponential decay model
        dose(i) = D0 * exp(-alpha * r);
    end

    % Find hottest and coldest doses
    [max_dose, max_idx] = max(dose);
    [min_dose, min_idx] = min(dose);
    hottest_point = surface_points(max_idx, :);
    coldest_point = surface_points(min_idx, :);

    % Visualize the OAR with dose distribution
    figure(17);
    surf(X, Y, Z, reshape(dose, size(X))); % Reshape dose for surface plot
    colorbar;
    colormap jet;
    title('Surface Dose Distribution on OAR');
    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');
    shading interp;

    % Mark hottest and coldest dose locations
    hold on;
    scatter3(hottest_point(1), hottest_point(2), hottest_point(3), ...
             100, 'r', 'filled', 'DisplayName', 'Hottest Point');
    scatter3(coldest_point(1), coldest_point(2), coldest_point(3), ...
             100, 'b', 'filled', 'DisplayName', 'Coldest Point');
    legend show;

    % Display results
    fprintf('Hottest Dose: %.2f at [%f, %f, %f]\n', max_dose, hottest_point);
    fprintf('Coldest Dose: %.2f at [%f, %f, %f]\n', min_dose, coldest_point);

end