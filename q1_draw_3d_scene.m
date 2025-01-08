%{
Description: Draw the 3D scene with Head, PTV, OAR, isocenter, and the coordinate axes. Choose the
appropriate surface representations, colors, etc. for meaningful visual presentation. The purpose of this step is
to form some visual and spatial comprehension of the scene.
Output: None beyond the plots
Test: Run the function, and plot and save some representative views.
Hint: You could use MATLAB functions for sphere, ellipsoid, etc. as needed
%}

function [] = q1_draw_3d_scene()
    figure('Color', 'white', 'Position', [100, 100, 1200, 800]);
    
    % Plot coordinate axes
    hold on;
    quiver3(0,0,0, 100,0,0, 'r', 'LineWidth', 2, 'DisplayName', 'X-axis');
    quiver3(0,0,0, 0,100,0, 'g', 'LineWidth', 2, 'DisplayName', 'Y-axis');
    quiver3(0,0,0, 0,0,100, 'b', 'LineWidth', 2, 'DisplayName', 'Z-axis');
    
    % Plot head ellipsoid
    [X,Y,Z] = ellipsoid(0,0,0, 80, 100, 80, 30);
    surf(X, Y, Z, 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'FaceColor', 'cyan', 'DisplayName', 'Head');
    
    % Plot PTV sphere
    [X,Y,Z] = sphere(30);
    % ptv_radius = 15;     ptv_center = [30, 0, 15];
    X = X * 15 + 30;
    Y = Y * 15 + 0;
    Z = Z * 15 + 15;
    surf(X, Y, Z, 'FaceColor', 'yellow', 'FaceAlpha', 0.7, 'EdgeColor', 'none', 'DisplayName', 'PTV');
    
    % Plot OAR ellipsoid
    [X,Y,Z] = ellipsoid(0, 30, 45, 15, 25, 15, 30);
    surf(X, Y, Z, 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'FaceColor', 'red', 'DisplayName', 'OAR');
    
    % Plot isocenter point    Isocenter point (center of PTV)
    plot3(30, 0, 15, 'ko', 'MarkerFaceColor', 'black', 'MarkerSize', 10, 'DisplayName', 'Isocenter');
    
    % Formatting
    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');
    title('Gamma Knife Radiosurgery 3D Scene');
    grid on;
    axis equal;
    view(3);
    legend('Location', 'best');
end