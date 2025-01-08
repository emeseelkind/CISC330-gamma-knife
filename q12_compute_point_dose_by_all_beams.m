%{
12. Compute Point Dose by All Beams
Description: Write a function to compute the so called “point dose”, which is the dose delivered to a given point
of interest by all allotted beams. (Remember, beams that we designated ‘unsafe’ will be excluded.).
Input: point_of_interest
Test: Full testing this function is not easy. For partial testing, set the “point_of_interest” in the center of the PTV.
Hint: Refer to the lecture notes
%}

function dose = q12_compute_point_dose_by_all_beams(point_of_interest)
    beam_vectors = readmatrix('beam_vectors.csv');

    unsafe_beam = q8_compute_beam_safety();

    % Initialize total dose
    dose = 0;

    % Loop through all beams and compute contribution
    for beam_index = 1:size(beam_vectors, 1)
        % Exclude unsafe beams
        if ~ismember(beam_index, unsafe_beam) 
            % Compute dose from this beam
            beam_dose = q11_compute_point_dose_by_1_beam(point_of_interest, beam_index);
            % Add to total dose
            dose = dose + beam_dose;
        end
    end
end