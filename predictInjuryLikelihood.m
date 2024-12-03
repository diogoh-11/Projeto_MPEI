function injuryLikelihood = predictInjuryLikelihood(data)
    % Normalize data to bring all features to a similar scale
    data = normalize(data, 'range', [0, 1]); % Scales each column to the range [0, 1]

    % Extract normalized features
    Player_Age = data(:, 1);
    Player_Weight = data(:, 2);
    Player_Height = data(:, 3);
    Previous_Injuries = data(:, 4);
    Training_Intensity = data(:, 5);
    Recovery_Time = data(:, 6);

    % Adjusted weights for the factors
    weight_Age = 0.4;              
    weight_Weight = 0.15;          
    weight_Height = 0.05;          
    weight_Previous_Injuries = 0.6; 
    weight_Training_Intensity = 0.5; 
    weight_Recovery_Time = -0.3;    

    % Linear combination of factors
    raw_score = weight_Age * Player_Age + ...
                weight_Weight * Player_Weight + ...
                weight_Height * Player_Height + ...
                weight_Previous_Injuries * Previous_Injuries + ...
                weight_Training_Intensity * Training_Intensity + ...
                weight_Recovery_Time * Recovery_Time;

    % Normalize the raw score to a 0-1 range using a sigmoid function
    injuryLikelihood = 1 ./ (1 + exp(-raw_score));

    % Print likelihood for verification
    % fprintf('Injury likelihood for each athlete:\n');
    % disp(injuryLikelihood);
end
