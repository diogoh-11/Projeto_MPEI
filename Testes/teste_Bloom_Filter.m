%% Script para testes do Bloom Filter
addpath("../BloomFilter");
addpath("../NaiveBayes");
addpath("../MinHash");
addpath("../data");

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


%% Implementação Bloom Filter
n = 100000;
m = 8000;
BF = initialize_BF(n);
% k_otimo = n * ln(2) / m
K = round(n * log(2) / m);

erro_teorico = (1 - (1 - 1/n)^(K*m))^K
limite_inferior = 2^-K

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

fprintf("Falsos positivos: %d (em %d)\n", falsos_positivos, count);
fprintf("Percentagem de falsos positivos: %.2f%%\n", falsos_positivos/counter * 100)

count = 0;
falsos_negativos = 0;
for i=1:length(X)
    if classes(i) == C_high                       % procurar se atletas de alto estao no BF, deviam. N devem haver falsos negativos
        atleta_teste = X(i, :);
        in_filter = in_BF(BF, atleta_teste, K, n);
        count = count + 1;
        %fprintf("Atleta %d: ", count)
        if ~in_filter
            %fprintf("Atleta pertence ao BF\n")
            falsos_negativos = falsos_negativos + 1;
        else
            %fprintf("Atleta NÃO pertence ao BF\n")
        end
    end
end

fprintf("Falsos negativos: %d (em %d)\n", falsos_negativos, count);
fprintf("Percentagem de falsos negativos: %.2f%%\n", falsos_negativos/counter * 100)