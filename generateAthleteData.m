function [data, labels] = generateAthleteData(numAthletes)
    % Define the number of athletes per class
    numHighRisk = round(numAthletes / 2);
    numLowRisk = numAthletes - numHighRisk;

    % Initialize data and labels
    data = zeros(numAthletes, 6); % 6 features
    labels = strings(numAthletes, 1);

    % Define ranges for features
    % [Age, Weight, Height, Previous Injuries, Training Intensity, Recovery Time]
    highRiskRanges = [
        28, 40;   % Age: Older players more at risk
        85, 120;  % Weight: Higher weight
        175, 200; % Height: Taller athletes
        2, 5;     % Previous Injuries: High previous injuries
        8, 10;    % Training Intensity: High intensity
        0, 2      % Recovery Time: Short recovery
    ];

    lowRiskRanges = [
        18, 27;   % Age: Younger players less at risk
        60, 84;   % Weight: Lower weight
        150, 174; % Height: Shorter athletes
        0, 1;     % Previous Injuries: Few or no previous injuries
        4, 7;     % Training Intensity: Moderate intensity
        3, 7      % Recovery Time: Longer recovery
    ];

    % Generate HIGH-risk athletes
    for i = 1:numHighRisk
        data(i, :) = arrayfun(@(col) ...
            rand * (highRiskRanges(col, 2) - highRiskRanges(col, 1)) + highRiskRanges(col, 1), ...
            1:6);
        labels(i) = 'Alto';
    end

    % Generate LOW-risk athletes
    for i = numHighRisk+1:numAthletes
        data(i, :) = arrayfun(@(col) ...
            rand * (lowRiskRanges(col, 2) - lowRiskRanges(col, 1)) + lowRiskRanges(col, 1), ...
            1:6);
        labels(i) = 'Baixo';
    end

    % Shuffle the dataset to mix HIGH and LOW classes
    perm = randperm(numAthletes);
    data = data(perm, :);
    labels = labels(perm);
    labels = categorical(labels);
end
