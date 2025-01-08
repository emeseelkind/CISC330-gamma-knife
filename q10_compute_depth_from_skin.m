%{
10. Compute Depth from Skin
Description: Write a function to compute the skin depth along the beam central belonging to an arbitrary point
of interest, for a given pencil beam.
Input: point_of_interest, beam_index
Test: Run the function for the same ground truth tests as above. Show that your module works correctly.
Hint: Refer to the lecture notes.
%}

function depth = q10_compute_depth_from_skin(point_of_interest, beam_index)
    beam_vectors = csvread('beam_vectors.csv');
    skin_entry_points = csvread('skin_entry_points.csv');
    %PTV_center = [30,0,15];
    
    % Extract the specific beam direction and skin entry point for the beam index
    D = beam_vectors(beam_index, :);
    skin_entry_point = skin_entry_points(beam_index, :);

    % Compute vector from skin entry point to the point of interest
    vector_to_point = point_of_interest - skin_entry_point;

    % Project the vector onto the beam direction to find the depth
    % depth = dot(vector_to_point, D) / norm(D);
    depth = dot(vector_to_point, D);
    depth = abs(depth);
end