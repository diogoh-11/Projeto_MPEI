function data = generateData(numSamples)
    % Generate synthetic data to improve injury risk classification
    
    % Parameters
    sports = ["Soccer", "Basketball", "Running", "Swimming", "Cycling"];
    genders = ["Male", "Female"];
    
    % Pre-allocate
    data = table('Size', [numSamples, 11], ...
                 'VariableTypes', ["string", "double", "double", "double", ...
                                   "string", "double", "double", "double", ...
                                   "double", "double", "double"], ...
                 'VariableNames', ["Gender", "Age", "Height", "Weight", ...
                                   "Sport", "Weekly_Training_Hours", ...
                                   "Training_Intensity", "Physical_Conditioning", ...
                                   "Nutrition_Score", "Previous_Injuries", ...
                                   "Risk"]);
    
    for i = 1:numSamples
        % Gender and Sport
        gender = genders(randi(2));
        sport = sports(randi(length(sports)));
        
        % Age, Height, Weight (vary by sport and gender)
        age = randi([16, 40]); % Random age
        if gender == "Male"
            height = normrnd(175, 10); % Mean 175 cm, SD 10
            weight = normrnd(75, 12);  % Mean 75 kg, SD 12
        else
            height = normrnd(165, 8);  % Mean 165 cm, SD 8
            weight = normrnd(65, 10);  % Mean 65 kg, SD 10
        end
        
        % Weekly Training Hours & Intensity (related to sport)
        if sport == "Running" || sport == "Cycling"
            weeklyHours = normrnd(10, 3); % Higher training hours
        else
            weeklyHours = normrnd(6, 2);  % Lower training hours
        end
        trainingIntensity = normrnd(7, 1.5); % Scale 1-10
        
        % Physical Conditioning & Nutrition Score
        physicalConditioning = max(0, min(10, normrnd(7, 2))); % Scale 0-10
        nutritionScore = max(0, min(10, normrnd(7, 1.5))); % Scale 0-10
        
        % Previous Injuries (binary, related to sport and intensity)
        prevInjuries = rand < (0.2 + 0.02 * weeklyHours); % Base + hours factor
        
        % Risk Calculation (synthetic rule for demonstration)
        riskScore = 0.3 * age + 0.5 * weeklyHours + 0.7 * trainingIntensity ...
                    - 0.4 * physicalConditioning - 0.3 * nutritionScore ...
                    + 1.5 * prevInjuries + randn * 0.5; % Add noise
        risk = riskScore > 5; % Threshold for high risk
        
        % Populate table
        data(i, :) = {gender, age, height, weight, sport, weeklyHours, ...
                      trainingIntensity, physicalConditioning, ...
                      nutritionScore, prevInjuries, risk};
    end
end
