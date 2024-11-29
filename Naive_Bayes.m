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
X = cell2mat(M(2:end, 2:end-1)); 
% Arredondar peso com duas casas decimais
X(:, 1) = round(X(:, 1), 2);
% Arredondar altura às unidades
X(:, 2) = round(X(:, 2)); 

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
percentagem = 90;       % 90% dos dados são utilizados para treino
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

%---------------C1------------------

linhas_C1 = classes_TREINO == C1;
TREINO_C1 = TREINO(linhas_C1, :);

% Casos favoráveis e possiveis
contagem = sum(TREINO_C1);
total = size(TREINO_C1, 1);

% Calcular quociente
prob_caracteristica_dado_C1 = contagem/total;

disp('Matriz de P(Caracteristica|C1):');
disp(prob_caracteristica_dado_C1);

%---------------C2------------------

linhas_C2 = classes_TREINO == C2;
TREINO_C2 = TREINO(linhas_C2, :);

% Casos favoráveis e possiveis
contagem = sum(TREINO_C2);
total = size(TREINO_C2, 1);

% Calcular quociente
prob_caracteristica_dado_C2 = contagem/total;

disp('Matriz de P(Caracteristica|C2):');
disp(prob_caracteristica_dado_C2);
    
% p(A|B) = p(B|A)/P(B) * P(A)
% p(A=170|C1) = p(C1|A = 170)/P(C1) * P(A = 170)