%{
7. Compute Grid for OAR
Description: Develop a function to compute in a uniform cartesian grid around the structure, flag the inner and
outer grid points.
Test: Plot the grid and a structure in 3D, mark the inner and outer grid points with different color, inspect the
outcome visually.
Hint: Compute the smallest box around the structure and subdivide the box into a grid. Make the grid size (i.e.
voxel size) variable, because you may like to use a coarser grid size (such as 5.0 mm) to speed up development
and testing of other functions, and then refine later to a finer grid (such as 1.0 mm) for dosimetric analysis.
%}

function [grid_points, grid_status] = q7_compute_grid_for_OAR()
    voxel_size = 5.0;
    oar_center = [0, 30, 45];
    oar_semi_axes = [15, 25, 15];  

    % Compute bounding box for the OAR
    % Expand the box slightly to ensure full coverage
    min_coords = oar_center - (oar_semi_axes + voxel_size);
    max_coords = oar_center + (oar_semi_axes + voxel_size);

    [X, Y, Z] = meshgrid(...
        min_coords(1):voxel_size:max_coords(1), ...
        min_coords(2):voxel_size:max_coords(2), ...
        min_coords(3):voxel_size:max_coords(3));

    % Flatten grid points
    grid_points = [X(:), Y(:), Z(:)];

    % Determine point status
    grid_status = zeros(size(grid_points, 1), 1);

    % Classify grid points using scaled ellipsoid equation
    for i = 1:size(grid_points, 1)
        % Compute normalized distance to OAR center
        point = grid_points(i, :);
        scaled_point = (point - oar_center) ./ oar_semi_axes;
        dist = norm(scaled_point);
        
        % Classify points
        if dist <= 1
            % Inside OAR (inner points)
            grid_status(i) = 1;
        elseif dist <= (1 + voxel_size/max(oar_semi_axes))
            % Surface or near-surface points (boundary)
            grid_status(i) = 2;
        else
            % Outside OAR (outer points)
            grid_status(i) = 0;
        end
    end

    % Visualization
    figure(7);
    hold on;

    % Plot coordinate axes
    quiver3(0, 0, 0, 100, 0, 0, 'r', 'LineWidth', 2, 'DisplayName', 'X-axis');
    quiver3(0, 0, 0, 0, 100, 0, 'g', 'LineWidth', 2, 'DisplayName', 'Y-axis');
    quiver3(0, 0, 0, 0, 0, 100, 'b', 'LineWidth', 2, 'DisplayName', 'Z-axis');

    % Plot OAR ellipsoid
    [X, Y, Z] = ellipsoid(oar_center(1), oar_center(2), oar_center(3), ...
        oar_semi_axes(1), oar_semi_axes(2), oar_semi_axes(3), 30);
    surf(X, Y, Z, 'FaceColor', 'red', 'FaceAlpha', 0.3, 'EdgeColor', 'none', 'DisplayName', 'OAR');

    % Plot grid points
    % Inner points (blue)
    inner_points = grid_points(grid_status == 1, :);
    scatter3(inner_points(:,1), inner_points(:,2), inner_points(:,3), ...
        2, 'b', 'filled','MarkerFaceAlpha', 0.5, 'DisplayName', 'Inner Points');

    % Boundary points (green)
    boundary_points = grid_points(grid_status == 2, :);
    scatter3(boundary_points(:,1), boundary_points(:,2), boundary_points(:,3), ...
        2, 'g', 'filled','MarkerFaceAlpha', 0.5, 'DisplayName', 'Boundary Points');

    % Outer points (red)
    outer_points = grid_points(grid_status == 0, :);
    scatter3(outer_points(:,1), outer_points(:,2), outer_points(:,3), ...
        2, 'r', 'filled','MarkerFaceAlpha', 0.5, 'DisplayName', 'Outer Points');

    % Formatting
    title(sprintf('OAR Grid (Voxel Size: %.1f mm)', voxel_size));
    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');
    legend show;
    axis equal;
    grid on;
    view(3);

    csvwrite('grid_for_OAR.csv', [grid_points, grid_status]);
    % %Print grid statistics
    % fprintf('Grid Statistics (Voxel Size: %.1f mm):\n', voxel_size);
    % fprintf('Total Grid Points: %d\n', size(grid_points, 1));
    % fprintf('Inner Points: %d\n', sum(grid_status == 1));
    % fprintf('Boundary Points: %d\n', sum(grid_status == 2));
    % fprintf('Outer Points: %d\n', sum(grid_status == 0));
end