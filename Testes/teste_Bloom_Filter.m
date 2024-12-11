%% Script para testes do Bloom Filter

addpath("../BloomFilter");
addpath("../NaiveBayes");
addpath("../MinHash");
addpath("../data");

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