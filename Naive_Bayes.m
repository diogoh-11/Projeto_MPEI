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
X(:, 2) = round(X(:, 2), 2);
% Arredondar altura às unidades
X(:, 3) = round(X(:, 3)); 

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
percentagem = 97;                          % 80% dos dados são utilizados para treino
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
% Abordagem Utlizando uma distribuição normal
% P(x|C) = [ 1/raiz(2 * pi * o^2) ] * e ^ (x -u)^2

% P(“caracteristicas_i”|classe) = 
% = P(classe|“caracteristicas_i”)*p(“caracteristicas_i”)/p(classe)

%---------------C1------------------

% Calcular probabilidade condicionada de C1
prob_caracteristica_dado_C1 = probCaractDadoClasse(TREINO,classes_TREINO,C1);

disp('Matriz de P(Caracteristica|C1):');
disp(prob_caracteristica_dado_C1);

%---------------C2------------------

% Calcular probabilidade condicionada de C2
prob_caracteristica_dado_C2 = probCaractDadoClasse(TREINO,classes_TREINO,C2);

disp('Matriz de P(Caracteristica|C2):');
disp(prob_caracteristica_dado_C2);

    
% p(A|B) = p(B|A)/P(B) * P(A)
% p(A=170|C1) = p(C1|A = 170)/P(C1) * P(A = 170)


%% Classificação dos exemplos de teste

resultadosMeus = categorical(zeros(size(TESTE,1),1));
for n = 1:size(TESTE,1)
    % Calcular probabilidades para cada classe
    p1 = probabilidade_Cx_dado_Teste(prob_caracteristica_dado_C1,p_C1,TESTE(n,:));  % probabilidade de ter Lesão
    p2 = probabilidade_Cx_dado_Teste(prob_caracteristica_dado_C2,p_C2,TESTE(n,:));  % probabilidade de não ter Lesão
    % Decidir a classe com maior probabilidade
    fprintf("--Atleta Teste %d--\nClasse teórica: %s\n", n, classes_TESTE(n))
    if p1 > p2 
        fprintf("Classe obtida: %s\n\n", C1);
        resultadosMeus(n) = C1;
    elseif p1 < p2
        fprintf("Classe obtida: %s\n\n", C2);
        resultadosMeus(n) = C2;
    else
        fprintf("Classe obtida: Nem sei\n\n");
        resultadosMeus(n) = 'Nem Sei';
    end
end


%% Determinar precisão, Recall, F1 do classificador de Bayes
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

% Calcular Precisão, Recall e F1-score
Precisao = TP / (TP + FP);
Recall = TP / (TP + FN);
F1 = 2 * (Precisao * Recall) / (Precisao + Recall);

% Exibir os resultados
fprintf('Precisão: %.2f%%\n', Precisao*100);
fprintf('Recall: %.2f%%\n', Recall*100);
fprintf('F1-score: %.2f%%\n', F1*100);
