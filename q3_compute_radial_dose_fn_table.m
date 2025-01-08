%{
3. Compute Radial Dose Function Table
Description: Write a function to compute radial dose function value according to according to the plot provided
earlier. Write the results into a table with some sensible resolution (such as 1 mm increments). You will use this
table for quick access during dose computation.
%}

function [] = q3_compute_radial_dose_fn_table()
    radial_distance = -22.5:0.1:22.5;  % Depth from skin in cm
    rdf_values = zeros(size(radial_distance));

    for i = 1:length(radial_distance)
        r = radial_distance(i);
        if r < -15
            % Rising slope from -22.5 to -15
            rdf_values(i) = 0.5 * (r + 22.5) / 7.5;
        elseif r < -7.5
            % Rising slope from -15 to -7.5
            rdf_values(i) = 0.5 + 0.5 * (r + 15) / 7.5;
        elseif r < 7.5
            % Constant peak value (flat section)
            rdf_values(i) = 1;
        elseif r < 15
            % Falling slope from 7.5 to 15
            rdf_values(i) = 1 - 0.5 * (r - 7.5) / 7.5;
        else
            % Falling slope from 15 to 22.5
            rdf_values(i) = 0.5 * (22.5 - r) / 7.5;
        end
    end
    rdf_table = table(radial_distance', rdf_values', 'VariableNames', {'Radial_Distance_mm', 'Radial_Dose_Function'});

    writetable(rdf_table, 'radial_dose_function.csv');
    
    % Create the plot
    figure(3);
    plot(radial_distance, rdf_values, 'b-o');
    title('Radial Dose Function');
    xlabel('Radial Distance (mm)');
    ylabel('Radial Dose Function');
    xlim([-23 23]);
    ylim([0 1]);
    grid on;

end