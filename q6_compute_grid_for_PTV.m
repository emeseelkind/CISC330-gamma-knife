%{
5. Compute Skin Entry Points
Description: Write a function to compute the skin entry point for each beam’s central line. Also compute the
depth of the isocenter from the skin entry point.
Test: Plot the 3D scene with the head and centerline of each pencil beam. Add a marker to the computed skin
entry points. Check visually whether the markers coincide with the beams intersecting the head. If the plot is too
busy, randomly select fewer beams for testing; save and submit some representative views.
Hint: Write up the equation of the beam’s central line and intersect it with the head’s ellipse. 
%}
function [grid_points, grid_status] = q6_compute_grid_for_PTV()
    voxel_size = 5.0;
    ptv_center = [30, 0, 15];
    ptv_radius = 15;

    % Compute bounding box for the PTV
    % Expand the box slightly to ensure full coverage
    min_coords = ptv_center - (ptv_radius + voxel_size);
    max_coords = ptv_center + (ptv_radius + voxel_size);

    [X, Y, Z] = meshgrid(min_coords(1):voxel_size:max_coords(1), ...
        min_coords(2):voxel_size:max_coords(2), ...
        min_coords(3):voxel_size:max_coords(3));
    grid_points = [X(:), Y(:), Z(:)];

    % Determine point status
    grid_status = zeros(size(grid_points, 1), 1);

    % Classify grid points
    for i = 1:size(grid_points, 1)
        % Distance from point to PTV center
        dist = norm(grid_points(i, :) - ptv_center);
        
        if dist <= ptv_radius
            % Inside PTV (inner points)
            grid_status(i) = 1;
        elseif dist <= (ptv_radius + voxel_size)
            % Surface or near-surface points (boundary)
            grid_status(i) = 2;
        else
            % Outside PTV (outer points)
            grid_status(i) = 0;
        end
    end

    figure(6);
    hold on;

    % coordinate axes
    quiver3(0,0,0, 100,0,0, 'r', 'LineWidth', 2, 'DisplayName', 'X-axis');
    quiver3(0,0,0, 0,100,0, 'g', 'LineWidth', 2, 'DisplayName', 'Y-axis');
    quiver3(0,0,0, 0,0,100, 'b', 'LineWidth', 2, 'DisplayName', 'Z-axis');

    % Plot PTV sphere
    [X, Y, Z] = sphere(30);
    X = X * ptv_radius + ptv_center(1);
    Y = Y * ptv_radius + ptv_center(2);
    Z = Z * ptv_radius + ptv_center(3);
    surf(X, Y, Z, 'FaceColor', 'yellow', 'FaceAlpha', 0.3, 'EdgeColor', 'none','DisplayName', 'PTV');

    % Plot grid points
    % Inner points (blue)
    inner_points = grid_points(grid_status == 1, :);
    scatter3(inner_points(:,1), inner_points(:,2), inner_points(:,3), 2, 'b', 'filled', 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Inner Points');

    % Boundary points (green)
    boundary_points = grid_points(grid_status == 2, :);
    scatter3(boundary_points(:,1), boundary_points(:,2), boundary_points(:,3), 2, 'g', 'filled', 'MarkerFaceAlpha', 0.5,'DisplayName', 'Boundary Points');

    % Outer points (red)
    outer_points = grid_points(grid_status == 0, :);
    scatter3(outer_points(:,1), outer_points(:,2), outer_points(:,3), 2, 'r', 'filled', 'MarkerFaceAlpha', 0.5,'DisplayName', 'Outer Points');

    title(sprintf('PTV Grid (Voxel Size: %.1f mm)', voxel_size));
    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');
    legend show;
    axis equal;
    grid on;
    view(3);
    
    csvwrite('grid_for_PTV.csv', [grid_points, grid_status]);
    % Print grid statistics
    % fprintf('Grid Statistics (Voxel Size: %.1f mm):\n', voxel_size);
    % fprintf('Total Grid Points: %d\n', size(grid_points, 1));
    % fprintf('Inner Points: %d\n', sum(grid_status == 1));
    % fprintf('Boundary Points: %d\n', sum(grid_status == 2));
    % fprintf('Outer Points: %d\n', sum(grid_status == 0));
end