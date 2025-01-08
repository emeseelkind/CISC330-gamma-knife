%{
9. Compute Radial Distance
Description: Write a function to compute the radial distance between arbitrary 
point of interest and the beam central, for a given beam.
Input: point_of_interest, beam_index
Test: Construct ground truth tests with three “easy beams” along the x, y, and z axes and with a convenient
setting of the ”point_of_interest”. Show that your module works correctly.
Hint: Refer to the lecture notes.
%}

%radial_dist: Shortest distance from point to beam central line
function radial_dist = q9_compute_radial_distance(point_of_interest, beam_index)
    beam_vectors = csvread('beam_vectors.csv');
    isocenter = [30, 0, 15];
    beam_direction = beam_vectors(beam_index, :);
    
    % Compute radial distance using point-to-line distance function
    radial_dist = dist_of_point_from_line(point_of_interest, isocenter, beam_direction);
end

function distance = dist_of_point_from_line(A, P, v)
    
    PA = A - P;
    cross_prod = cross(PA, v);    
    distance = norm(cross_prod) / norm(v);
end
