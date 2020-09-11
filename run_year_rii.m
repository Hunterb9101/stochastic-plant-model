function [plantN,plantS] = run_year_rii(plantN, plantS, rii)    
    % Looking for function with following properties:
    % 50% chance of either species winning at RII = 0
    % 100% chance of Native winning at RII = 1
    % 100% chance of Invasive winning at RII = -1
    % Symmetric at RII = 0
    prob = .5 * rii + .5;
    [plantN, plantS] = run_year_probability(plantN, plantS, prob);
end

