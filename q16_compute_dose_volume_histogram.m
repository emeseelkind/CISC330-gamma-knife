%{
16. Compute Dose Volume Histogram
Description: Compute the common cumulative dose volume histogram for both PTV and OAR.
Test: Plot the DVH in the standard form (see Figure 4) with marking DOAR and D100 and explain your findings with
respect to the treatment goal.
Hint: You may like to use MATLAB’s “histcounts (X,edges)” function, where X are the dose values and the bin
edges can go from 0, by increments of 1% of D100 - which then should yield a smooth curve. 
%}

function [] = q16_compute_dose_volume_histogram()
    ptv_doses = csvread('ptv_doses2.csv');
    oar_doses = csvread('oar_doses2.csv');
    % [ptv_doses, PTV_min_dose, PTV_max_dose] = q13_compute_dose_for_PTV();
    % [oar_doses, OAR_min_dose, OAR_max_dose] = q14_compute_dose_for_OAR();
    PTV_min_dose = 9.33;
    PTV_max_dose = 23.50;
    OAR_min_dose = 0.00;
    OAR_max_dose = 0.91;

    D100 = 20;  % Required PTV dose
    DOAR = 10;  % Maximum allowed OAR dose
    
    % Create bin edges from 0 to max dose
    bin_width = D100 * 0.01; % 1% of D100
    max_dose = max([D100 * 1.2, PTV_max_dose, OAR_max_dose]);
    edges = 0:bin_width:max_dose;
    
    % Remove any NaN or infinite values
    ptv_doses = ptv_doses(isfinite(ptv_doses));
    oar_doses = oar_doses(isfinite(oar_doses));
    
    % Compute histograms for PTV and OAR
    [ptv_counts, ~] = histcounts(ptv_doses, edges);
    [oar_counts, ~] = histcounts(oar_doses, edges);
    
    % Convert to cumulative and normalize to percentages
    ptv_cumulative = 100 * (length(ptv_doses) - cumsum(ptv_counts)) / length(ptv_doses);
    oar_cumulative = cumsum(oar_counts, 'reverse') / sum(oar_counts) * 100;
    
    % Create x-axis points for plotting (centers of bins)
    x_points = edges(1:end-1) + bin_width/2;
    
    % Create figure
    figure(16);
    clf;
    hold on;
    grid on;
    
    % Plot DVH curves
    plot(x_points, ptv_cumulative, 'r-', 'LineWidth', 2);
    plot(x_points, oar_cumulative, 'm-', 'LineWidth', 2);
    
    % Add vertical lines for D100 and DOAR
    plot([D100 D100], [0 100], 'k-', 'LineWidth', 1.5);
    plot([DOAR DOAR], [0 100], 'm--', 'LineWidth', 1.5);
    
    % Add markers for key points
    ptv_d100_idx = find(abs(x_points - D100) == min(abs(x_points - D100)));
    oar_doar_idx = find(abs(x_points - DOAR) == min(abs(x_points - DOAR)));
    
    plot(D100, ptv_cumulative(ptv_d100_idx), 'ko', 'MarkerSize', 10, 'LineWidth', 2);
    plot(DOAR, oar_cumulative(oar_doar_idx), 'mo', 'MarkerSize', 10, 'LineWidth', 2);
    
    % Customize plot
    xlabel('Dose');
    ylabel('Relative Volume (%)');
    title('Cumulative Dose Volume Histogram (DVH)');
    legend({'PTV', 'OAR', 'D_{100}', 'D_{OAR}'}, 'Location', 'northeast');
    
    % Set axis limits
    xlim([0 max_dose*1.1]);
    ylim([0 100]);
    
    % Add grid
    grid on;
    
    % Print analysis
    fprintf('\nDVH Analysis:\n');
    fprintf('PTV:\n');
    fprintf('  Minimum dose: %.2f\n', PTV_min_dose);
    fprintf('  Maximum dose: %.2f\n', PTV_max_dose);
    fprintf('  Coverage at D100 (%.1f): %.1f%%\n', D100, ptv_cumulative(ptv_d100_idx));
    
    fprintf('\nOAR:\n');
    fprintf('  Minimum dose: %.2f\n', OAR_min_dose);
    fprintf('  Maximum dose: %.2f\n', OAR_max_dose);
    fprintf('  Volume receiving >= DOAR (%.1f): %.1f%%\n', DOAR, oar_cumulative(oar_doar_idx));

end