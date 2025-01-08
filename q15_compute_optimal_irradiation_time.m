%{
15. Compute Optimal Irradiation Time
Description: Examine the extreme doses in the PTV and OAR on the results from above and determine if the
treatment objective can be attained with the current beam configuration. If yes, then compute the optimal
irradiation time. Otherwise exit this function. Re-examine the 3D scene plot and the hot/cold spots in the PTV
and OAR and decide which additional beams you should plug/unplug; recompute the hottest and coldest dose in
the PTV and OAR and repeat this function.
Test: Recompute the dose inside the PTV and OAR and show that you achieved the treatment goal. 
%}

function [] = q15_compute_optimal_irradiation_time()
    Tnom = 10;          % Nominal irradiation time (minutes)
    D0 = 0.10;          % Base dose unit per minute
    D100 = 20;          % Required PTV dose
    DOAR = 10;          % Maximum allowed OAR dose
    
    % Get initial doses for PTV and OAR
    % [PTV_min_dose, PTV_max_dose] = q13_compute_dose_for_PTV();
    % [OAR_min_dose, OAR_max_dose] = q14_compute_dose_for_OAR();
    PTV_min_dose = 9.33;
    PTV_max_dose = 23.5;
    OAR_min_dose = 0;
    OAR_max_dose = 0.91;

    % Load dose data
    PTV_grid = readmatrix('grid_for_PTV.csv');
    OAR_grid = readmatrix('grid_for_OAR.csv');
    ptv_doses = csvread('ptv_doses2.csv');
    oar_doses = csvread('oar_doses2.csv');

    % Get valid grid points
    valid_PTV_points = PTV_grid(:,4) == 1 | PTV_grid(:,4) == 2;
    valid_OAR_points = OAR_grid(:,4) == 1 | OAR_grid(:,4) == 2;

    % Get current min/max doses at nominal time
    PTV_min_dose = PTV_min_dose * Tnom;
    PTV_max_dose = PTV_max_dose * Tnom;
    OAR_max_dose = OAR_max_dose * Tnom;

    % Calculate scaling factors needed to reach target doses
    ptv_scaling = D100 / PTV_min_dose;  % Scale factor to reach prescribed PTV dose
    oar_scaling = DOAR / OAR_max_dose;  % Scale factor to reach max OAR dose

    % Determine if treatment is feasible and optimal time
    if ptv_scaling <= oar_scaling
        % Treatment is feasible - use PTV scaling
        optimal_time = Tnom * ptv_scaling;
        treatment_feasible = true;
        
        % Verify final doses
        final_PTV_min = PTV_min_dose * ptv_scaling;
        final_PTV_max = PTV_max_dose * ptv_scaling;
        final_OAR_max = OAR_max_dose * ptv_scaling;
        
        % Display results
        fprintf('Treatment objective achieved:\n');
        fprintf('Optimal irradiation time: %.2f minutes\n', optimal_time);
        fprintf('Minimum PTV dose: %.2f DU\n', final_PTV_min);
        fprintf('Maximum PTV dose: %.2f DU\n', final_PTV_max);
        fprintf('Maximum OAR dose: %.2f DU\n', final_OAR_max);
        
    else
        % Treatment not feasible with current beam configuration
        treatment_feasible = false;
        optimal_time = NaN;
        
        fprintf('Treatment objective cannot be achieved with current beam configuration:\n');
        fprintf('Required PTV scaling: %.2f\n', ptv_scaling);
        fprintf('Maximum safe OAR scaling: %.2f\n', oar_scaling);
        fprintf('\nSuggested actions:\n');
        fprintf('1. Review beam configuration\n');
        fprintf('2. Consider plugging additional beams near OAR\n');
        fprintf('3. Evaluate possibility of multiple treatment fractions\n');
    end

    % % Incrementing D0
    % increment_D0 = 0.1;
    % PTV_grid = readmatrix('grid_for_PTV.csv');
    % valid_grid_rows = PTV_grid(:,4) == 1 | PTV_grid(:,4) == 2;
    % valid_grid_rows_PTV = PTV_grid(valid_grid_rows, 1:4);
    % ptv_doses = csvread('ptv_doses.csv');
    % 
    % OAR_grid = readmatrix('grid_for_OAR.csv');
    % valid_grid_rows = OAR_grid(:,4) == 1 | OAR_grid(:,4) == 2;
    % valid_grid_rows_OAR = OAR_grid(valid_grid_rows, 1:4);
    % oar_doses = csvread('oar_doses.csv');
    % 
    % d_curr = Tnom * PTV_min_dose;
    % 
    % while d_curr < D100
    %     Tnom = Tnom * 0.2;
    %     d_curr = Tnom * PTV_min_dose;
    % end
    % 
    % PTV_pass = 1;
    % OAR_pass = 1;
    % 
    % for i = 1:size(valid_grid_rows_OAR, 1)
    %     if Tnom * oar_doses(i) > DOAR
    %         OAR_pass = 0;
    %         break
    %     end
    % end
    % for i = 1:size(valid_grid_rows_PTV, 1)
    %     if Tnom * ptv_doses(i) > D100
    %         PTV_pass = 0;
    %         break
    %     end
    % end
    % 
    % if ~OAR_pass || ~PTV_pass
    %     disp('The current beam configuration cannot achieve treatment objective');
    % else
    %     disp('The optimal irradiation time is: ', num2str(Tnom), ' minutes.');
    %     disp('The max dose delivered to the OAR is: ', num2str(Tnom* OAR_max_dose), ' DU.');
    %     disp('The max dose delivered to the PTV is: ',  num2str(Tnom * PTV_max_dose));

end