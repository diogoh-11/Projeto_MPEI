% Leitura do arquivo CSV
M = readcell('athlete_injury_data.csv'); 

% Vetor das características
caracteristicas = categorical(M(1, 2:end-1));

% Matriz dos valores associados a cada característica
X = M(2:end, 1:end-1);

% Vetor coluna com as classes dos atletas
classes = categorical(M(2:end, end)); 

% Nomes das classes 
nomes_classes = unique(classes);

% C1 e C2 representam as classes (C1 = alto risco; C2 = Baixo risco)
C_high = nomes_classes(1);  
C_low = nomes_classes(2); 

% Vetor de strings para representar os atletas
atletas_str = strings(size(X, 1), 1);

% Construção de `atletas_str`
for i = 1:size(X, 1)
    str = "";
    for j = 1:size(X, 2)
        aux = X{i, j}; % Acessa o elemento individualmente
        if isnumeric(aux) % Verifica se é numérico
            aux = num2str(aux);
        elseif islogical(aux) % Verifica se é lógico
            aux = string(aux);
        end
        str = strcat(str, aux, " "); % Concatena com um espaço
    end
    atletas_str(i) = strtrim(str); % Remove espaços extras no final
end

% Exibição do vetor final
disp(atletas_str)

