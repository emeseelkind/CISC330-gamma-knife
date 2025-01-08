%{
5. Compute Skin Entry Points
Description: Write a function to compute the skin entry point for each beam’s central line. Also compute the
depth of the isocenter from the skin entry point.
Test: Plot the 3D scene with the head and centerline of each pencil beam. Add a marker to the computed skin
entry points. Check visually whether the markers coincide with the beams intersecting the head. If the plot is too
busy, randomly select fewer beams for testing; save and submit some representative views.
Hint: Write up the equation of the beam’s central line and intersect it with the head’s ellipse. 
%}
function [skin_entry_points, isocenter_depths] = q5_compute_skin_entry_point()
    beam_vectors = csvread('beam_vectors.csv');

    num_beams = size(beam_vectors, 1);
    skin_entry_points = [];
    isocenter_depths = [];

    % Ellipsoid head (a, b, c are semi-axes lengths)
    a = 80;
    b = 100; 
    c = 80;

    for i = 1:num_beams
        % Beam central line: P(t) = O + t * D
        % Direction vector
        D = beam_vectors(i, :); 
        O = [30, 0, 15];         
        % Parametrize the ellipsoid equation for intersection:
        % (x/a)^2 + (y/b)^2 + (z/c)^2 = 1
        % Substitute P(t) = O + t * D into the ellipsoid equation
        % Solve quadratic: At^2 + Bt + C = 0
        A = (D(1)/a)^2 + (D(2)/b)^2 + (D(3)/c)^2;
        B = 2 * ((O(1)*D(1)/a^2) + (O(2)*D(2)/b^2) + (O(3)*D(3)/c^2));
        C = (O(1)/a)^2 + (O(2)/b)^2 + (O(3)/c)^2 - 1;
        discriminant = B^2 - 4*A*C;

        if discriminant < 0
            % No real intersection
            skin_entry_points(end+1, :) = [NaN, NaN, NaN];
            isocenter_depths(end+1) = NaN;
            continue;
        end

        % Compute the two solutions for t
        t1 = (-B - sqrt(discriminant)) / (2 * A);
        t2 = (-B + sqrt(discriminant)) / (2 * A);

        % Select the smallest positive t (skin entry point)
        t = min(t1, t2);
        if t < 0
            t = max(t1, t2); % If the smallest is negative, choose the other
        end
        if t < 0
            % No valid intersection in positive direction
            skin_entry_points(end+1, :) = [NaN, NaN, NaN];
            isocenter_depths(end+1) = NaN;
            continue;
        end

        % Compute skin entry point P(t)
        skin_entry_point = O + t * D;
        skin_entry_points(end+1, :) = skin_entry_point;

        % Compute depth from skin entry to isocenter
        depth_vector = [30, 0, 15] - skin_entry_point;
        depth = norm(depth_vector);
        isocenter_depths(end+1) = depth;
    end

    csvwrite('skin_entry_points.csv', skin_entry_points);
    csvwrite('isocenter_depths.csv', isocenter_depths);
end

