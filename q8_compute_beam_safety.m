%{
8. Compute Beam Safety
Description: Write a function to compute the volume of interaction between each beam and the OAR. (As you
should remember, a beam is generally unsafe when it has a direct hit on the OAR. In the initial treatment plan,
the unsafe beams will be excluded so they will not contribute any dose. But if the treatment objective cannot be
met with all safe beams, then we will unplug the “least unsafe” beams (i.e. beams with smallest intersection
with the OAR.) Make a sketch and explain your approach in comments – as you see it best.
Test: Plot the 3D scene with the unsafe beams and OAR; inspect and interpret; save and submit some
representative views.
Hint: While it is not simple to compute this analytically, you can discretize.
%}
% function [unsafe_beams, beam_intersections] = q8_compute_beam_safety()

function unsafe_beams = q8_compute_beam_safety()

    oar_center = [0, 30, 45];
    oar_semi_axes = [15, 25, 15]; 
    ptv_center = [30, 0, 15];
    beam_vectors = csvread('beam_vectors.csv');
    beam_intersections = zeros(size(beam_vectors, 1), 1);
    unsafe_beams = [];
    
    beam_sampling_resolution = 1.0;  % mm 
    max_beam_length = 300;  % mm 
    beam_diameter = 30; % mm
    num_radial_points = 8;

    figure(8);
    clf;
    hold on;
    % Plot coordinate axes
    quiver3(0, 0, 0, 100, 0, 0, 'r', 'LineWidth', 2, 'DisplayName', 'X-axis');
    quiver3(0, 0, 0, 0, 100, 0, 'g', 'LineWidth', 2, 'DisplayName', 'Y-axis');
    quiver3(0, 0, 0, 0, 0, 100, 'b', 'LineWidth', 2, 'DisplayName', 'Z-axis');

    % Plot head ellipsoid
    [X,Y,Z] = ellipsoid(0,0,0, 80, 100, 80, 30);
    surf(X, Y, Z, 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'FaceColor', 'cyan');

    % Plot PTV sphere
    [X,Y,Z] = sphere(30);
    % ptv_radius = 15;     ptv_center = [30, 0, 15];
    X = X * 15 + 30;
    Y = Y * 15 + 0;
    Z = Z * 15 + 15;
    surf(X, Y, Z, 'FaceColor', 'yellow', 'FaceAlpha', 0.7, 'EdgeColor', 'none');
    
    % Plot OAR ellipsoid
    [X,Y,Z] = ellipsoid(0, 30, 45, 15, 25, 15, 30);
    surf(X, Y, Z, 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'FaceColor', 'red');
    
    num_beams = size(beam_vectors, 1);

    for i = 1:num_beams
        beam_dir = beam_vectors(i, :);
        beam_dir = beam_dir / norm(beam_dir); % Normalize direction vector
        
        % Calculate two perpendicular vectors to beam_dir for circular cross section
        [v1, v2] = get_perpendicular_vectors(beam_dir);
        
        % Generate points along beam path
        t = 0:beam_sampling_resolution:max_beam_length;
        intersects_oar = false;
        
        % Check multiple points along beam path
        for j = 1:length(t)
            center_point = ptv_center + beam_dir * t(j);
            
            % Check points around beam circumference
            for k = 1:num_radial_points
                angle = 2 * pi * (k-1) / num_radial_points;
                offset = (beam_diameter/2) * (cos(angle)*v1 + sin(angle)*v2);
                point = center_point + offset;
                
                % Check if point is inside OAR ellipsoid
                inside_oar = ((point(1) - oar_center(1))^2 / oar_semi_axes(1)^2 + ...
                             (point(2) - oar_center(2))^2 / oar_semi_axes(2)^2 + ...
                             (point(3) - oar_center(3))^2 / oar_semi_axes(3)^2) <= 1;
                
                if inside_oar
                    intersects_oar = true;
                    break;
                end
            end
            if intersects_oar
                break;
            end
        end
        
        % Plot beam with appropriate color using quiver3
        scaled_beam = beam_vectors(i, :) * 150;
        if intersects_oar
            unsafe_beams = [unsafe_beams; i];
            quiver3(30, 0, 15, scaled_beam(1), scaled_beam(2), scaled_beam(3), ...
                   'Color', 'red', 'LineWidth', 0.5, 'MaxHeadSize', 0.5);
        else
            quiver3(30, 0, 15, scaled_beam(1), scaled_beam(2), scaled_beam(3), ...
                   'Color', 'black', 'LineWidth', 0.5, 'MaxHeadSize', 0.5);
        end
    end

    title('Beam Safety Analysis');
    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');
    axis equal;
    grid on;
    view(3);
    
    % Print beam safety summary
    fprintf('Beam Safety Analysis:\n');
    fprintf('Total Beams: %d\n', size(beam_vectors, 1));
    fprintf('Unsafe Beams: %d\n', length(unsafe_beams));
    fprintf('Unsafe Beam Indices: ');
    fprintf('%d ', unsafe_beams);
    fprintf('\n');
end



function [v1, v2] = get_perpendicular_vectors(v)
    % Generate two vectors perpendicular to input vector v
    if abs(v(3)) < abs(v(1))
        v1 = [-v(2), v(1), 0];
    else
        v1 = [0, -v(3), v(2)];
    end
    v1 = v1 / norm(v1);
    v2 = cross(v, v1);
    v2 = v2 / norm(v2);
end

