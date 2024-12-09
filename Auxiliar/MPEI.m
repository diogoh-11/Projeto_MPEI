%% Criação das matrizes e vetores de dados retirados do ficheiro

M = readcell('injury_data.csv'); 

% Substituir os 1s e 0s por Alto e Baixo, respetivamente
ultima_coluna = M(2:end, end);

for i = 1:length(ultima_coluna)
    if isequal(ultima_coluna{i}, 1)
        ultima_coluna{i} = 'Alto';        
    elseif isequal(ultima_coluna{i}, 0)
        ultima_coluna{i} = 'Baixo';
    end
end

M(2:end, end) = ultima_coluna;

% Vetor das características
caracteristicas = categorical(M(1, 2:end-1));

% Matriz dos valores associados a cada característica
X = cell2mat(M(2:end, 1:end-1)); 
% Arredondar peso com duas casas decimais
X(:, 2) = round(X(:, 2));
% Arredondar altura às unidades
X(:, 3) = round(X(:, 3)); 
% Arredondar ESFORCO às unidades
X(:, 5) = round(X(:, 5),2); 

% Vetor coluna com as classes dos atletas
classes = categorical(M(2:end, end)); 



% Nomes das classes 
nomes_classes = unique(classes);

% C1 e C2 representam as classes (C1 = alto risco; C2 = Baixo risco)
C1 = nomes_classes(1);  
C2 = nomes_classes(2); 

clear M; clear ultima_coluna; 

%% Realizar divisão dos dados do ficherio para treino e teste

permutacao = randperm(size(X,1));
percentagem = 70;       % 90% dos dados são utilizados para treino
num_linhas_treino = percentagem/100 * size(X, 1);

TREINO = X(permutacao(1:num_linhas_treino),:);
TESTE = X(permutacao(num_linhas_treino+1:end),:);

classes_TREINO = classes(1:num_linhas_treino);
classes_TESTE = classes(num_linhas_treino+1:end);

atletas_C1 = sum(classes_TREINO == C1);    % Número de atletas de C1         
atletas_C2 = sum(classes_TREINO == C2);    % Número de atletas de C2           
total_atletas = length(classes_TREINO);    % Número total de atletas

%% Calcular P(C1) e P(C2)

% P(C1)
p_C1 = atletas_C1/total_atletas;
fprintf("P(C1) = %f\n", p_C1);

% P(C2)
p_C2 = atletas_C2/total_atletas;
fprintf("P(C2) = %f\n", p_C2);

%% Calculos probabilidades condicionadas
% Esta parte não funciona pk aquilo que fizemos na aula usava
% características com valores de 0 ou 1 e ent a soma delas a dividir pelo
% total dava as probabilidades de cada caracteristica sabendo que pertnce à
% classe X, neste caso como usamos valores que não são binários em maior
% parte das caracteristicas dá a média... 

% P(“caracteristicas_i”|classe) = 
% = P(classe|“caracteristicas_i”)*p(“caracteristicas_i”)/p(classe)
resultadosMeus = categorical(zeros(size(TESTE,1),1));

for a = 1:length(TESTE)
    P_C1_dado_caract = p_C1;
    P_C2_dado_caract = p_C2;
    atleta = TESTE(a,:);
    age = atleta(1);        % int
    weight = atleta(2);     % double
    height = atleta(3);     % double
    previous_injuries = atleta(4);      % 1 ou 0
    training_intensity = atleta(5);     % double [0,1]
    recovery_time = atleta(6);          % int

    P_C1_dado_caract = P_C1_dado_caract * probCondicionadaColuna(age, TREINO(:,1), C1,classes_TREINO) * probCondicionadaColuna(weight, TREINO(:,2), C1,classes_TREINO) * probCondicionadaColuna(height, TREINO(:,3), C1,classes_TREINO) * probsBinary(TREINO(:,4), previous_injuries,C1, classes_TREINO) * probCondicionadaColuna(training_intensity, TREINO(:, 5), C1, classes_TREINO) * probCondicionadaColuna(recovery_time, TREINO(:,6), C1,classes_TREINO);
    P_C2_dado_caract = P_C2_dado_caract * probCondicionadaColuna(age, TREINO(:,1), C2,classes_TREINO) * probCondicionadaColuna(weight, TREINO(:,2), C2,classes_TREINO) * probCondicionadaColuna(height, TREINO(:,3), C2,classes_TREINO) * probsBinary(TREINO(:,4), previous_injuries,C2, classes_TREINO) * probCondicionadaColuna(training_intensity, TREINO(:, 5), C2, classes_TREINO) * probCondicionadaColuna(recovery_time, TREINO(:,6), C2,classes_TREINO);
    
    fprintf("--Atleta Teste %d--\nClasse teórica: %s\n", a, classes_TESTE(a))
    if P_C1_dado_caract > P_C2_dado_caract 
        fprintf("Classe obtida: %s\n\n", C1);
        resultadosMeus(a) = C1;
    elseif P_C1_dado_caract < P_C2_dado_caract
        fprintf("Classe obtida: %s\n\n", C2);
        resultadosMeus(a) = C2;
    else
        fprintf("Classe obtida: Nem sei\n\n");
        resultadosMeus(a) = 'Nem Sei';
    end
end

% Determinar precisão, Recall, F1 do classificador de Bayes
% Verificar se existem exemplos suficientes de cada classe no conjunto de teste
if sum(classes_TESTE == C1) == 0 || sum(classes_TESTE == C2) == 0
    disp('Aviso: uma das classes não está presente no conjunto de teste!');
end

% Inicializar contadores para TP, FP, TN, FN
TP = 0;
FP = 0;
TN = 0;
FN = 0;

for j = 1:length(resultadosMeus)
    if resultadosMeus(j) == C1 && classes_TESTE(j) == C1
        TP = TP + 1;  % True Positive
    elseif resultadosMeus(j) == C1 && classes_TESTE(j) == C2
        FP = FP + 1;  % False Postive
    elseif resultadosMeus(j) == C2 && classes_TESTE(j) == C1
        FN = FN + 1;  % False Negative
    elseif resultadosMeus(j) == C2 && classes_TESTE(j) == C2
        TN = TN + 1;  % True Negative
    end
end


fprintf("P(C1) = %f\n", p_C1);
fprintf("P(C2) = %f\n", p_C2);


fprintf("TP: %d\n", TP);
fprintf("TN: %d\n", TN);
fprintf("FP: %d\n", FP);
fprintf("FN: %d\n", FN);

% Calcular Precisão, Recall e F1-score
Precisao = TP / (TP + FP);
Recall = TP / (TP + FN);
F1 = 2 * (Precisao * Recall) / (Precisao + Recall);

% Exibir os resultados
fprintf('Precisão: %.2f%%\n', Precisao*100);
fprintf('Recall: %.2f%%\n', Recall*100);
fprintf('F1-score: %.2f%%\n', F1*100);



%% Implementação Bloom Filter
n=15000;
m = 500;
BF = initialize_BF(n);
% k_otimo = n * ln(2) / m

K = round(n * log(2) / m);
fprintf("K ótimo: %d\n", K);

for i=1:length(X)
    if classes(i) == C1                 % Adicionar ao bloom filter atletas de risco para testar
        atleta = X(i, :);
        BF = add_to_BF(atleta, BF, K, n);
    end
end

stem(BF);

count = 0;
falsos_positivos = 0;
for i=1:length(X)
    if classes(i) == C2                         % procurar se atletas de baixo estao no BF, N deviam. Podemos ter falsos positicos
        atleta_teste = X(i, :);
        in_filter = in_BF(BF, atleta_teste, K, n);
        count = count + 1;

        %fprintf("Atleta %d: ", count)

        if in_filter == 1
            %fprintf("Atleta pertence ao BF\n")
            falsos_positivos = falsos_positivos + 1;
        else
            %fprintf("Atleta NÃO pertence ao BF\n")
        end
    end
end

fprintf("Falsos positivos: %d\n", falsos_positivos);

percentagem_erro = falsos_positivos/500 * 100;

fprintf("Percentagem de erro: %.2f%%\n", percentagem_erro);





