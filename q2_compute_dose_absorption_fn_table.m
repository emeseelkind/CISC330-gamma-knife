%{
Description: Write a function to compute Dose Absorption Function according to the plot provided earlier. Write
the results into a table with some sensible resolution (such as 1 mm increments). You will use this table for quick
access during dose computation.
Test: Run the function, print the table, compare to the plot, ascertain correctness.
%}

function [] = q2_compute_dose_absorption_fn_table()
    depths = 0:0.1:16;  % Depth from skin in cm
    daf_values = zeros(size(depths));
    
    % Constants
    d0 = 1.0;  % Dose unit at max depth
    dmax = 2.0;  % Maximum depth

    % Compute DAF values
    for i = 1:length(depths)
        d = depths(i);
        if d <= dmax
            % Linear build-up region
            daf_values(i) = 0.5 + (d / dmax) * 0.5;
        elseif d > dmax && d <= 12
            % Linear attenuation region
            daf_values(i) = 1 - (d - dmax) / (12 - dmax) * 0.5;
        elseif d > 12 && d <= 16
            % Linear attenuation region
            daf_values(i) = 1 - (d - dmax) / (16 - dmax) * 0.7;
        else
            % Beyond 16 cm, dose is 0
            daf_values(i) = 0;
        end
    end

    daf_table = table(depths', daf_values', 'VariableNames', {'Depth_mm', 'Dose_Absorption_Function'});

    writetable(daf_table, 'dose_absorption_function.csv');
    
    % Create the plot
    figure(2);
    plot(depths, daf_values, 'b-o');
    title('Dose Absorption Function');
    xlabel('Depth from Skin (cm)');
    ylabel('Dose Absorption Function Value');
    xlim([0 16]);
    ylim([0 1]);
    grid on;
end