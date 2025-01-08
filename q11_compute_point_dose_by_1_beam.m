%{
11. Compute Point Dose by One Beam
Description: Write a function to compute the dose at a point of interest from a given beam.
Input: point_of_interest, beam_index
Test: Run the function for the same three “easy ground truth beams” as above. Show that your module works
correctly.
Hint: Refer to the lecture notes
%}

function dose = q11_compute_point_dose_by_1_beam(point_of_interest, beam_index)
    % beam_vectors = readmatrix('beam_vectors.csv');
    % beam_weights = readmatrix('beam_angles.csv');
    dose_absorption = readmatrix('dose_absorption_function.csv');
    radial_dose = readmatrix('radial_dose_function.csv');
    
    % Base dose value
    D0 = 0.10;  
    
    % Compute geometric parameters
    radial_dist = q9_compute_radial_distance(point_of_interest, beam_index);
    depth_from_skin = q10_compute_depth_from_skin(point_of_interest, beam_index);
    
    % Round values to match table indices
    radial_dist = round(radial_dist);
    depth_from_skin = round(abs(depth_from_skin)) / 10; 
    
    
    if radial_dist < -22.5 || radial_dist > 22.5
        RDF = 0;
    else
        RDF_index = find(radial_dose(:,1) == radial_dist);
        RDF = radial_dose(RDF_index, 2)*10;
    end 

    DAF_index = find(dose_absorption(:,1) == depth_from_skin);
    DAF = dose_absorption(DAF_index, 2);
    
    dose = D0 * DAF * RDF ;
   
end
