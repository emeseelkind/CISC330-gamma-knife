%{
18. Compute Dose Surface Histogram for OAR
Description: Compute the cumulative Dose Surface Histogram (DSH) for the organ at risk.
Test: Plot the histogram in the standard form (refer to course notes) with marking DOAR and explain your findings
with respect to the treatment goal.
Hint: Having computed the dose for each patch on the OAR, you can assign the same dose value to each square
mm in the patch, so you can we use the “histcounts” function.
%}

function [] = q18_compute_dose_surface_histogram_for_OAR()
    oar_doses = csvread('oar_doses2.csv');

    OAR_min_dose = 0.00;
    OAR_max_dose = 0.91;

    DOAR = 10;  
    edges = 0:0.2:25;
    
    % Remove any NaN or infinite values
    oar_doses = oar_doses(isfinite(oar_doses));
    
    % Compute histograms for PTV and OAR
    [oar_counts, ~] = histcounts(oar_doses, edges);
    
    oar_cumulative = cumsum(oar_counts, 'reverse') / sum(oar_counts) * 100;

    % Create x-axis points for plotting (centers of bins)
    x_points = edges(1:end-1) + 0.2/2;
    
    figure(18);
    clf;
    hold on;
    grid on;
    
    % Plot DVH curves
    plot(x_points, oar_cumulative, 'r-', 'LineWidth', 2);
    
    % Add vertical lines for D100 and DOAR
    plot([DOAR DOAR], [0 100], 'r--', 'LineWidth', 1.5);
    
    % Add markers for key points
    oar_doar_idx = find(abs(x_points - DOAR) == min(abs(x_points - DOAR)));
    
    plot(DOAR, oar_cumulative(oar_doar_idx), 'mo', 'MarkerSize', 10, 'LineWidth', 2);
    
    xlabel('Dose');
    ylabel('Cumulative Volume (%)');
    title('Cumulative Dose Volume Histogram (DVH)');
    legend({'OAR',  'D_{OAR}'}, 'Location', 'northeast');
    xlim([0 12]);
    ylim([0 100]);
    grid on;
    
    fprintf('\nOAR:\n');
    fprintf('  Minimum dose: %.2f\n', OAR_min_dose);
    fprintf('  Maximum dose: %.2f\n', OAR_max_dose);
    fprintf('  Volume receiving >= DOAR (%.1f): %.1f%% \n', DOAR, oar_cumulative(oar_doar_idx));
end