%{
main function for my code to run all the test functions
%}

function [] = main
    fprintf("Test for Question 1\n");
    q1_draw_3d_scene;
    fprintf("Check figure 1 \n");
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 2\n");
    q2_compute_dose_absorption_fn_table;
    fprintf("Check figure 2 \n");
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 3\n");
    q3_compute_radial_dose_fn_table;
    fprintf("Check figure 3 \n");
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 4\n");
    test_q4();
    fprintf("Check figure 4 \n");
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 5\n");
    test_q5;
    fprintf("Check figure 5 \n");
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 6\n");
    q6_compute_grid_for_PTV;
    fprintf("Check figure 6 \n");
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 7\n");
    q7_compute_grid_for_OAR;
    fprintf("Check figure 7 \n");
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 8\n");
    q8_compute_beam_safety;
    fprintf("\n Check figure 8 \n");
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 9\n");
    test_radial_distance_q9;
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 10\n");
    test_q10;
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 11\n");
    test_q11;
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 12\n");
    test_q12;
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 13\n");
    q13_compute_dose_for_PTV;
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 14\n");
    q14_compute_dose_for_OAR;
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 15\n");
    q15_compute_optimal_irradiation_time;
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 16\n");
    q16_compute_dose_volume_histogram;
    fprintf("Check figure 16 \n");
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 17\n");
    q17_compute_surface_dose_for_OAR;
    fprintf("Check figure 17 \n");
    fprintf("\n-----------------------------------------------------\n");
    fprintf("Test for Question 18\n");
    q18_compute_dose_surface_histogram_for_OAR;
    fprintf("Check figure 18 \n");
    fprintf("\n-----------------------------------------------------\n");
end
function [] = test_q4()
    [beam_vectors, ~] = q4_compute_beam_dir_vec();
    figure(4);
    hold on;
    
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
    
    for i = 1:size(beam_vectors, 1)
        % Scale vector for visibility
        scaled_vector = beam_vectors(i, :) * 150;
        % plot beams so they all go to the PTV
        quiver3(30, 0, 15, scaled_vector(1), scaled_vector(2), scaled_vector(3), ...
            'Color', 'black', 'LineWidth', 0.5, 'MaxHeadSize', 0.5);
    end
    
    % Plot isocenter point    Isocenter point (center of PTV)    Target (tumor center)
    plot3(30, 0, 15, 'ko', 'MarkerFaceColor', 'black', 'MarkerSize', 10);


    title('Beam Direction Vectors');
    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');
    axis equal;
    grid on;
    view(3);
end

function [] = test_q5()
    skin_entry_points = csvread('skin_entry_points.csv');
    isocenter_depths = csvread('isocenter_depths.csv');
    beam_vectors = csvread('beam_vectors.csv');
    num_beams = size(beam_vectors, 1);

    figure(5);
    hold on;
    quiver3(0, 0, 0, 100, 0, 0, 'r', 'LineWidth', 2, 'DisplayName', 'X-axis');
    quiver3(0, 0, 0, 0, 100, 0, 'g', 'LineWidth', 2, 'DisplayName', 'Y-axis');
    quiver3(0, 0, 0, 0, 0, 100, 'b', 'LineWidth', 2, 'DisplayName', 'Z-axis');
    % Plot head ellipsoid
    [X, Y, Z] = ellipsoid(0, 0, 0, 80, 100, 80, 30);
    surf(X, Y, Z, 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'FaceColor', 'cyan');

    % Plot all beams and their skin entry points
    for i = 1:num_beams
        % Scale beam for visibility
        scaled_beam = beam_vectors(i, :) * 150;
        quiver3(30, 0, 15, scaled_beam(1), scaled_beam(2), scaled_beam(3), ...
            'Color', 'black', 'LineWidth', 0.5, 'MaxHeadSize', 0.5);

        % Plot skin entry point
        if ~any(isnan(skin_entry_points(i, :)))
            plot3(skin_entry_points(i, 1), skin_entry_points(i, 2), skin_entry_points(i, 3), ...
                'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 2);
        end
    end
    
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
    
    % Plot the isocenter isocenter = ;
    plot3(30, 0, 15, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8);

    title('Skin Entry Points and Beam Central Lines');
    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');
    axis equal;
    grid on;
    view(3);
    hold off;
end


function test_radial_distance_q9()
    beam_vectors = csvread('beam_vectors.csv');
    
    % Find indices of beams exactly along x, y, and z axes
    x_axis_beam_index = find(all(abs(beam_vectors - [1,0,0]) < 1e-6, 2));
    y_axis_beam_index = find(all(abs(beam_vectors - [0,1,0]) < 1e-6, 2));
    z_axis_beam_index = find(all(abs(beam_vectors - [0,0,1]) < 1e-6, 2));
    
    % Select the first found index for each axis
    x_axis_beam_index = x_axis_beam_index(1);
    y_axis_beam_index = y_axis_beam_index(1);
    z_axis_beam_index = z_axis_beam_index(1);
    
    % Test 1: Point off X-axis beam
    fprintf('Test 1: Point off X-axis beam\n');
    point1 = [10, 0, 0];
    rad1 = q9_compute_radial_distance(point1, x_axis_beam_index);
    fprintf('Radial distance: %f \n', rad1);
    
    % Test 2: Point off Y-axis beam
    fprintf('\nTest 2: Point off Y-axis beam\n');
    point2 = [10, 5, 0];
    rad2 = q9_compute_radial_distance(point2, y_axis_beam_index);
    fprintf('Radial distance: %f \n', rad2);
    
    % Test 3: Point off Z-axis beam
    fprintf('\nTest 3: Point off Z-axis beam\n');
    point3 = [30, 20, 10];
    rad3 = q9_compute_radial_distance(point3, z_axis_beam_index);
    fprintf('Radial distance: %f \n',  rad3);
    
end

function test_q10()
    beam_vectors = csvread('beam_vectors.csv');
    
    % Find indices of beams exactly along x, y, and z axes
    x_axis_beam_index = find(all(abs(beam_vectors - [1,0,0]) < 1e-6, 2));
    y_axis_beam_index = find(all(abs(beam_vectors - [0,1,0]) < 1e-6, 2));
    z_axis_beam_index = find(all(abs(beam_vectors - [0,0,1]) < 1e-6, 2));
    
    % Select the first found index for each axis
    x_axis_beam_index = x_axis_beam_index(1);
    y_axis_beam_index = y_axis_beam_index(1);
    z_axis_beam_index = z_axis_beam_index(1);
    
    % Test 1: Point off X-axis beam
    fprintf('Test 1: X-axis beam\n');
    point1 = [10, 0, 0];
    depth1 = q10_compute_depth_from_skin(point1, x_axis_beam_index);
    fprintf('Depth from Skin: %f \n', depth1);
    
    % Test 2: Point off Y-axis beam
    fprintf('\nTest 2: Y-axis beam\n');
    point2 = [15, 10, 5];
    depth2 = q10_compute_depth_from_skin(point2, y_axis_beam_index);
    fprintf('Depth from Skin: %f \n', depth2);
    
    % Test 3: Point off Z-axis beam
    fprintf('\nTest 3: Z-axis beam\n');
    point3 = [30, 20, 10];
    depth3 = q10_compute_depth_from_skin(point3, z_axis_beam_index);
    fprintf('Depth from Skin: %f \n',  depth3);
    
end
function test_q11()
    beam_vectors = csvread('beam_vectors.csv');
    
    % Find indices of beams exactly along x, y, and z axes
    x_axis_beam_index = find(all(abs(beam_vectors - [1,0,0]) < 1e-6, 2));
    y_axis_beam_index = find(all(abs(beam_vectors - [0,1,0]) < 1e-6, 2));
    z_axis_beam_index = find(all(abs(beam_vectors - [0,0,1]) < 1e-6, 2));
    
    % Select the first found index for each axis
    x_axis_beam_index = x_axis_beam_index(1);
    y_axis_beam_index = y_axis_beam_index(1);
    z_axis_beam_index = z_axis_beam_index(1);
    
    % Test 1: Point off X-axis beam
    fprintf('Test 1: X-axis beam\n');
    point1 = [10, 2, 8];
    dose1 = q11_compute_point_dose_by_1_beam(point1, x_axis_beam_index);
    fprintf('Point Dose by One Beam: %f \n', dose1);
    
    % Test 2: Point off Y-axis beam
    fprintf('\nTest 2: Y-axis beam\n');
    point2 = [15, 10, 5];
    dose2 = q11_compute_point_dose_by_1_beam(point2, y_axis_beam_index);
    fprintf('Point Dose by One Beam: %f \n', dose2);
    
    % Test 3: Point off Z-axis beam
    fprintf('\nTest 3: Z-axis beam\n');
    point3 = [10, 5, 10];
    dose3 = q11_compute_point_dose_by_1_beam(point3, z_axis_beam_index);
    fprintf('Point Dose by One Beam: %f \n',  dose3);
    
end

function test_q12()
    point_of_interest = [30, 0, 15];
    
    % Compute the total dose at this point
    total_dose = q12_compute_point_dose_by_all_beams(point_of_interest);
    
    % Display results
    fprintf('Total dose at the center of the PTV (isocenter): %.4f\n', total_dose);
end