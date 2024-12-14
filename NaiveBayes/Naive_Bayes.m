function athelete_class = Naive_Bayes(athlete, TREINO, classes)

    % Nomes das classes 
    nomes_classes = unique(classes);
    
    % (C_high = alto risco; C_low = Baixo risco)
    C_high = nomes_classes(1);
    C_low = nomes_classes(2);

    atletas_C_high = sum(classes == C_high);    % Número de atletas de C1         
    atletas_C_low = sum(classes == C_low);      % Número de atletas de C2           
    total_atletas = length(classes);            % Número total de atletas

        
    % Calcular P(C_low), P(C_high)
    % P(C_high)
    p_C_high = atletas_C_high/total_atletas;

    % P(C_low)
    p_C_low = atletas_C_low/total_atletas;

    %Calculos probabilidades condicionadas
    gender = athlete(1);
    age = athlete(2);        
    height = athlete(3);     
    weight = athlete(4);     
    sport = athlete(5);
    Weekly_Training_Hours = athlete(6);
    Training_Intensity = athlete(7);
    Physical_Conditioning = athlete(8);
    Nutrition_Score = athlete(9);
    Previous_Injuries = athlete(10);
    
    P_C_high_dado_caract = p_C_high * probCondicionadaColuna(gender, TREINO(:,1),C_high, classes) * probsDistrNormal(age, TREINO(:,2), C_high, classes) * probsDistrNormal(height, TREINO(:,3), C_high, classes) * probsDistrNormal(weight, TREINO(:,4), C_high, classes) * probCondicionadaColuna(sport, TREINO(:,5), C_high, classes) * probsDistrNormal(Weekly_Training_Hours, TREINO(:,6), C_high, classes) * probCondicionadaColuna(Training_Intensity, TREINO(:,7), C_high, classes) * probsDistrNormal(Physical_Conditioning, TREINO(:,8), C_high, classes) * probsDistrNormal(Nutrition_Score, TREINO(:,9), C_high, classes) * probsDistrNormal(Previous_Injuries, TREINO(:,10), C_high, classes);
    P_C_low_dado_caract = p_C_low * probCondicionadaColuna(gender, TREINO(:,1),C_low, classes) * probsDistrNormal(age, TREINO(:,2), C_low, classes) * probsDistrNormal(height, TREINO(:,3), C_low, classes) * probsDistrNormal(weight, TREINO(:,4), C_low, classes) * probCondicionadaColuna(sport, TREINO(:,5), C_low, classes) * probsDistrNormal(Weekly_Training_Hours, TREINO(:,6), C_low, classes) * probCondicionadaColuna(Training_Intensity, TREINO(:,7), C_low, classes) * probsDistrNormal(Physical_Conditioning, TREINO(:,8), C_low, classes) * probsDistrNormal(Nutrition_Score, TREINO(:,9), C_low, classes) * probsDistrNormal(Previous_Injuries, TREINO(:,10), C_low, classes);
    
    % atribuição das classes
    if P_C_high_dado_caract > P_C_low_dado_caract 
        athelete_class = 'high';
    elseif P_C_high_dado_caract < P_C_low_dado_caract
        athelete_class = 'low';
    else
        athelete_class = 'inconclusive';
    end
end