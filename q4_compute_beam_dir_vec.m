%{
4. Compute Beam Direction Vectors
Description: Write a function to compute the unit direction vector for each pencil beam’s centerline.
Test: Draw a 3D scene of the beams and coordinate axes, ascertain correctness; save and submit some
representative views.
%}
function [beam_vectors, beam_angles] = q4_compute_beam_dir_vec()
    longitude_angles = 0:30:330;  % 0 to 30 degrees in 30-degree steps
    latitude_angles = 0:30:90;    % 0 to 90 degrees in 30-degree steps
    
    beam_vectors = [];
    beam_angles = [];
    
    for lat = latitude_angles
        for lon = longitude_angles
            % Convert spherical coordinates to Cartesian
            % Theta (latitude) is from positive z-axis
            % Phi (longitude) is from positive x-axis
            theta = deg2rad(lat);
            phi = deg2rad(lon);
            x = sin(theta) * cos(phi);
            y = sin(theta) * sin(phi);
            z = cos(theta);
            
            beam_vector = [x, y, z];
            beam_vector = beam_vector / norm(beam_vector);
            %round the beam_vector to 3 decimal places
            beam_vector = round(beam_vector, 3);
            %add beam vector if it is unique
            if isempty(beam_vectors) || ~any(all(abs(beam_vectors - beam_vector) < 1e-6, 2))
                % Store beam vector and its angular coordinates
                beam_vectors(end+1, :) = beam_vector;
                beam_angles(end+1, :) = [lat, lon];
            end
            
        end
    end
    
    csvwrite('beam_vectors.csv', beam_vectors);
    csvwrite('beam_angles.csv', beam_angles);
end
