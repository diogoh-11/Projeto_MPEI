% Read the data from the CSV file
M = readcell('injury_data.csv');

% substituir 1s e 0s por alto e baixo
ultima_coluna = M(2:end, end);

for i = 1:length(ultima_coluna)
    if isequal(ultima_coluna{i}, 1)
        ultima_coluna{i} = 'alto';
    elseif isequal(ultima_coluna{i}, 0)
        ultima_coluna{i} = 'baixo';
    end
end

M(2:end, end) = ultima_coluna;

caracteristicas = categorical(M(1, 2:end-1));

TREINO = cell2mat(M(2:end, 2:end-1)); 
TREINO(:, 1) = round(TREINO(:, 1), 2); 
TREINO(:, 2) = round(TREINO(:, 2));

classes = categorical(M(2:end, end)); 
nomes_classes = unique(classes);

C1 = nomes_classes(1);  % alto risco
C2 = nomes_classes(2);  % baixo risco

atletas_C1 = sum(classes == C1);           
atletas_C2 = sum(classes == C2);                  
total_atletas = length(classes);

% P(C1)
p_C1 = atletas_C1/total_atletas;
fprintf("\nP(C1) = %f\n", p_C1);

% P(C2)
p_C2 = atletas_C2/total_atletas;
fprintf("\nP(C2) = %f\n", p_C2);

% P(“caracteristicas_i”|classe) = 
% = P(classe|“caracteristicas_i”)*p(“caracteristicas_i”)/p(classe)
%---------------C1------------------

linhas_C1 = classes == C1;
TREINO_C1 = TREINO(linhas_C1, :);

%casos favoráveis e possiveis
contagem = sum(TREINO_C1);
total = size(TREINO_C1, 1);

% calcular quociente
prob_caracteristica_dado_C1 = contagem/total;

disp('Matriz de P(Caracteristica|C1):');
disp(prob_caracteristica_dado_C1);

%---------------C2------------------

linhas_C2 = classes == C2;
TREINO_C2 = TREINO(linhas_C2, :);

%casos favoráveis e possiveis
contagem = sum(TREINO_C2);
total = size(TREINO_C2, 1);

% calcular quociente
prob_caracteristica_dado_C2 = contagem/total;

disp('Matriz de P(Caracteristica|C2):');
disp(prob_caracteristica_dado_C2);






