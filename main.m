%% Criação das matrizes e vetores de dados retirados do ficheiro

M = readcell('athlete_injury_data.csv'); 

% Vetor das características
caracteristicas = categorical(M(1, 2:end-1));

% Matriz dos valores associados a cada característica
X = cell(M(2:end, 1:end-1));

% Vetor coluna com as classes dos atletas
classes = categorical(M(2:end, end)); 

% Nomes das classes 
nomes_classes = unique(classes);

% C1 e C2 representam as classes (C1 = alto risco; C2 = Baixo risco)
C_high = nomes_classes(1);  
C_low = nomes_classes(2); 

%clear M;

%% Realizar divisão dos dados do ficherio para treino e teste

resultados = [];
h = waitbar(0, 'Calculating');

for n=1:50
    waitbar(n/50, h, 'Calculating');
    permutacao = randperm(size(X,1));
    percentagem = 95;       % 90% dos dados são utilizados para treino
    num_linhas_treino = percentagem/100 * size(X, 1);

    TREINO = X(permutacao(1:num_linhas_treino),:);
    TESTE = X(permutacao(num_linhas_treino+1:end),:);

    classes_TREINO = classes(1:num_linhas_treino);
    classes_TESTE = classes(num_linhas_treino+1:end);

    atletas_C_high = sum(classes_TREINO == C_high);    % Número de atletas de C1         
    atletas_C_low = sum(classes_TREINO == C_low);    % Número de atletas de C2           
    total_atletas = length(classes_TREINO);    % Número total de atletas

    %% Calcular P(C_low), P(C_high)

    % P(C_high)
    p_C_high = atletas_C_high/total_atletas;
    %fprintf("P(C_high) = %f\n", p_C_high);

    % P(C_low)
    p_C_low = atletas_C_low/total_atletas;
    %fprintf("P(C_low) = %f\n", p_C_low);

    %% Calculos probabilidades condicionadas

    resultadosMeus = categorical(zeros(size(TESTE,1),1));

    for a = 1:length(TESTE)
        athlete = TESTE(a,:);

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
        
        P_C_high_dado_caract = p_C_high * probCondicionadaColuna(gender, X(:,1),C_high, classes_TREINO) * probsDistrNormal(age, X(:,2), C_high, classes_TREINO) * probsDistrNormal(height, X(:,3), C_high, classes_TREINO) * probsDistrNormal(weight, X(:,4), C_high, classes_TREINO) * probCondicionadaColuna(sport, X(:,5), C_high, classes_TREINO) * probsDistrNormal(Weekly_Training_Hours, X(:,6), C_high, classes_TREINO) * probCondicionadaColuna(Training_Intensity, X(:,7), C_high, classes_TREINO) * probsDistrNormal(Physical_Conditioning, X(:,8), C_high, classes_TREINO) * probsDistrNormal(Nutrition_Score, X(:,9), C_high, classes_TREINO) * probsDistrNormal(Previous_Injuries, X(:,10), C_high, classes_TREINO);
        P_C_low_dado_caract = p_C_low * probCondicionadaColuna(gender, X(:,1),C_low, classes_TREINO) * probsDistrNormal(age, X(:,2), C_low, classes_TREINO) * probsDistrNormal(height, X(:,3), C_low, classes_TREINO) * probsDistrNormal(weight, X(:,4), C_low, classes_TREINO) * probCondicionadaColuna(sport, X(:,5), C_low, classes_TREINO) * probsDistrNormal(Weekly_Training_Hours, X(:,6), C_low, classes_TREINO) * probCondicionadaColuna(Training_Intensity, X(:,7), C_low, classes_TREINO) * probsDistrNormal(Physical_Conditioning, X(:,8), C_low, classes_TREINO) * probsDistrNormal(Nutrition_Score, X(:,9), C_low, classes_TREINO) * probsDistrNormal(Previous_Injuries, X(:,10), C_low, classes_TREINO);
        

        %fprintf("--Atleta Teste %d--\nClasse teórica: %s", a, classes_TESTE(a))
        if P_C_high_dado_caract > P_C_low_dado_caract 
            %fprintf("Classe obtida: %s\n\n", C_high);
            resultadosMeus(a) = C_high;
        elseif P_C_high_dado_caract < P_C_low_dado_caract
            %fprintf("Classe obtida: %s\n\n", C_low);
            resultadosMeus(a) = C_low;
        else
            %fprintf("Classe obtida: Nem sei\n\n");
            resultadosMeus(a) = 'Nem Sei';
        end
    end

    % Determinar precisão, Recall, F1 do classificador de Bayes
    % Verificar se existem exemplos suficientes de cada classe no conjunto de teste
    if sum(classes_TESTE == C_high) == 0 || sum(classes_TESTE == C_low) == 0
        disp('Aviso: uma das classes não está presente no conjunto de teste!');
    end

    % Inicializar contadores para TP, FP, TN, FN
    TP = 0;
    FP = 0;
    TN = 0;
    FN = 0;

    for j = 1:length(resultadosMeus)
        if resultadosMeus(j) == C_high && classes_TESTE(j) == C_high
            TP = TP + 1;  % True Positive
        elseif resultadosMeus(j) == C_high && classes_TESTE(j) == C_low
            FP = FP + 1;  % False Postive
        elseif resultadosMeus(j) == C_low && classes_TESTE(j) == C_high
            FN = FN + 1;  % False Negative
        elseif resultadosMeus(j) == C_low && classes_TESTE(j) == C_low
            TN = TN + 1;  % True Negative
        end
    end


    
%{
    fprintf("P(C1) = %f\n", p_C_high);
    fprintf("P(C2) = %f\n", p_C_low);


    fprintf("TP: %d\n", TP);
    fprintf("TN: %d\n", TN);
    fprintf("FP: %d\n", FP);
    fprintf("FN: %d\n", FN); 
%}


    % Calcular Precisão, Recall e F1-score
    Precisao = TP / (TP + FP);
    Recall = TP / (TP + FN);
    F1 = 2 * (Precisao * Recall) / (Precisao + Recall);

    resultados(n, 1) = Precisao;
    resultados(n, 2) = Recall;
    resultados(n, 3) = F1;
end

delete(h);
Precisao_media = sum(resultados(:,1)/n);
Recall_media = sum(resultados(:,2)/n);
F1_media = sum(resultados(:,3)/n);


% Exibir os resultados
fprintf('Precisão: %.2f%%\n', Precisao_media*100);
fprintf('Recall: %.2f%%\n', Recall_media*100);
fprintf('F1-score: %.2f%%\n', F1_media*100);


%% Implementação Bloom Filter
n = 22000;
m = 3000;
BF = initialize_BF(n);
% k_otimo = n * ln(2) / m
K = round(n * log(2) / m);

fprintf("K ótimo: %d\n", K);
counter = 0;

for i=1:length(X)
    if classes(i) == C_high               % Adicionar ao bloom filter atletas de risco para testar
        atleta = X(i, :);
        BF = add_to_BF(atleta, BF, K, n);
        counter = counter + 1;
    end
end

stem(BF);

count = 0;
falsos_positivos = 0;
for i=1:length(X)
    if classes(i) == C_low                       % procurar se atletas de baixo estao no BF, N deviam. Podemos ter falsos positicos
        atleta_teste = X(i, :);
        in_filter = in_BF(BF, atleta_teste, K, n);
        count = count + 1;
        %fprintf("Atleta %d: ", count)
        if in_filter
            %fprintf("Atleta pertence ao BF\n")
            falsos_positivos = falsos_positivos + 1;
        else
            %fprintf("Atleta NÃO pertence ao BF\n")
        end
    end
end

fprintf("Falsos positivos: %d\n", falsos_positivos);
fprintf("Percentagem de falsos positivos: %.2f%%\n", falsos_positivos/counter * 100)

    
    
    

