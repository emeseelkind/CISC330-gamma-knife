%{
13. Compute Dose for PTV
Description: Compute the dose delivered to the PTV over the dose grid. Compute the extreme doses.
Test: Add these to the 3D scene plot. Evaluate your findings with respect to treatment objective.
Hint: Refer to the lecture notes.
14. Compute Dose for OAR
Repeat the same for the OAR.
%}

function [oar_doses, min_dose, max_dose] = q14_compute_dose_for_OAR()
    [grid_points, grid_status] = q7_compute_grid_for_OAR(); 
    
    % Preallocate dose storage for inner points
    num_inner_points = sum(grid_status == 1 | grid_status == 2);
    oar_doses = zeros(num_inner_points, 1);
    
    % Only calculate dose for points inside the PTV
    inner_point_indices = find(grid_status == 1 | grid_status == 2);
    
    for i = 1:num_inner_points
        point_of_interest = grid_points(inner_point_indices(i), :);
        % Compute the point dose by all beams
        dose = q12_compute_point_dose_by_all_beams(point_of_interest);
        oar_doses(i) = dose;
    end
    
    % Compute extreme doses
    min_dose = min(oar_doses);
    max_dose = max(oar_doses);
    extreme_doses = [min_dose, max_dose];
    
    writematrix(oar_doses, 'oar_doses.csv');

    % Visualize results
    figure(14);
    hold on;
    
    % Plot PTV grid points
    scatter3(grid_points(inner_point_indices, 1), ...
             grid_points(inner_point_indices, 2), ...
             grid_points(inner_point_indices, 3), ...
             20, oar_doses, 'filled');
    colorbar;
    title('OAR Dose Distribution');
    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');
    axis equal;
    grid on;
    view(3);
    
    % Display extreme doses
    fprintf('Extreme Doses:\n');
    fprintf('Minimum Dose: %.2f\n', min_dose);
    fprintf('Maximum Dose: %.2f\n', max_dose);

end