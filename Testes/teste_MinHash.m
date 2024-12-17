%% Script para teste de MinHash
addpath("../BloomFilter");
addpath("../NaiveBayes");
addpath("../MinHash");
addpath("../data");

% Calcular os shingles
celulas = readcell('athlete_injury_data.csv', 'Delimiter', ',');
dados = cell(size(celulas,1)-1,size(celulas,2)-1);

% Converter todos os dados para strings
for i = 1:size(celulas, 1)
    for j = 1:(size(celulas, 2) - 1)
        value = celulas{i, j};                     % Acede ao valor da célula

        if isnumeric(value)
            dados{i, j} = num2str(value);        % Converte de número para string
        elseif ischar(value) || isstring(value)
            dados{i, j} = char(value);           % Garante um formato consistente de string
        elseif isempty(value)
            dados{i, j} = '';                    % Substitui valores vazios por uma string vazia
        else
            dados{i, j} = 'UNKNOWN';             % Trata tipos de dados não suportados
        end
    end
end

% Inicializar armazenamento para os shingles
shingles = cell(size(celulas, 1) - 1, 1); 
k = 3;                                          % Comprimento dos shingles

% Gerar shingles para cada linha de celulas
for i = 2:size(celulas, 1) % Ignorar a primeira linha (assumida como cabeçalho)
    % Concatenar todas as colunas da linha em uma única string
    row_data = strjoin(dados(i, :), ' ');             % Junta as colunas com um separador de espaço
    shingle_list = {};                              % Armazenamento temporário para os shingles

    len = length(row_data);                         % Comprimento da string concatenada da linha

    if len >= k
        for ind = 1:(len - k + 1)                   % Gerar shingles
            shingle = row_data(ind:ind + k - 1);    % Extrai uma substring de comprimento k
            shingle_list{end + 1} = shingle;        % Adiciona à lista de shingles
        end
    end

    shingles{i-1} = shingle_list;                   % Armazena os shingles na célula de saída
end




% shingles = cell(size(celulas, 1) - 1, 1); % Cell array for shingles
% k = 4; % Length of shingles
% % Create shingles for each row in celulas
% for i = 2:size(celulas, 1) % Start from row 2 to skip header (if present)
%     shingle_list = {}; % Temporary storage for shingles
% 
%     for j = 1:size(celulas, 2) - 1 % Loop over each column
%         data = celulas{i, j}; % Get the data from the cell array
% 
%         % Convert all data to a string representation
%         if isnumeric(data)
%             str = num2str(data); % Convert numeric to string
%         elseif isstring(data) || ischar(data)
%             str = char(data); % Ensure consistent string format
%         else
%             str = ''; % Handle empty cells or unsupported types
%         end
% 
%         % Generate shingles only if the string length is >= k
%         len = length(str);
%         if len >= k
%             for ind = 1:(len - k + 1) % Loop to generate shingles
%                 shingle = str(ind:ind + k - 1); % Extract substring of length k
%                 shingle_list{end + 1} = shingle; % Append to the shingle list
%             end
%         end
%     end
% 
%     shingles{i-1} = shingle_list; % Store shingles in the output cell
% end
%% Primo grande
nhf = 300;

p = 123456789;
while ~isprime(p)
    p = p + 2;
end

rng(42); % Definir o estado do gerador de números aleatórios
% Matriz de 300 por 3 funções de hash para ter os hash_codes de cada shingle
R = randi(p,nhf,k);

%% Matriz de assinaturas
nhf = 300;
fprintf(1,"Usando %d funções de dispersão\n", k);
MA = calc_assinaturas_MinHashsh(shingles,nhf,R,p);
imagesc(MA);


%% Testar
string = 'Men 24 184 82.4 Football 13.2 High 3.4 2.1 3';
Set2 = {criar_conjuntos_string(string,k)};

% Criar matriz de assinaturas para a frase de input
MA2 = calc_assinaturas_MinHashsh(Set2,nhf,R,p);
imagesc(MA2)

%% Calcular as distancias


% Dimensões da matriz
[k, n] = size(MA); % k = funções hash, n = número de atletas

% Inicializar vetores valores teóricos e diferenças 
valores_teoricos = zeros(1, n);
diferencas = zeros(1, n);


% Jaccard(A,B) = |A∩B|/|AuB|
% Estimativa de Jaccard(A,B) = número de hashes iguais / k
% Distancia da estimativa de Jaccard(A,B) = 1 - (número de hashes iguais /
% k)
% Inicializar vetor de distâncias
distancias = zeros(1, n);

% Calcular a distância para cada atleta
for i = 1:n
    % Contar hashes iguais entre MA2 e cada coluna de MA
    hashes_iguais = sum(MA(:, i) == MA2(:, 1));
   
    % Calcular a distância estimada de Jaccard
    distancias(i) = 1 - (hashes_iguais / k);
    
    % Cálculo do valor teórico
    intersecao = length(intersect(unique(Set2{1}), unique(shingles{i})));
    uniao = length(union(unique(Set2{1}), unique(shingles{i})));
    valores_teoricos(i) = 1 - (intersecao / uniao);
    
    % Diferença entre valor teórico e estimativa
    diferencas(i) = abs(valores_teoricos(i) - distancias(i));
    
end

% Ordenar as distâncias em ordem crescente
[distancias_ordenadas, indices] = sort(distancias);

% Selecionar os 5 jogadores mais próximos
top5_indices = indices(1:5);
top5_distancias = distancias_ordenadas(1:5);



%% Exibir os jogadores mais próximos
fprintf('Os 5 atletas mais similares são:\n');
for i = 1:5
    
    % Extrair a linha correspondente
    linha_atleta = celulas(top5_indices(i) + 1, :);   % Linha do atleta
    
    % Converter cada elemento da linha em uma string
    linha_str = cellfun(@(x) num2str(x), linha_atleta, 'UniformOutput', false);
    
    % Concatenar os valores da linha em uma única string
    atleta_nome = strjoin(linha_str, ' ');          % Concatena com espaço entre valores


    fprintf('%s com distância %.4f (Diferença Teórica: %.4f)\n', ...
            atleta_nome, top5_distancias(i), diferencas(top5_indices(i)));
end


% Carregar os dados do arquivo CSV
celulas = readcell('athlete_injury_data.csv', 'Delimiter', ',');
dados = cell(size(celulas, 1) - 1, size(celulas, 2) - 1);

% Converter todos os dados para strings
for i = 1:size(celulas, 1)
    for j = 1:(size(celulas, 2) - 1)
        value = celulas{i, j}; % Acede ao valor da célula

        if isnumeric(value)
            dados{i, j} = num2str(value); % Converte de número para string
        elseif ischar(value) || isstring(value)
            dados{i, j} = char(value); % Garante um formato consistente de string
        elseif isempty(value)
            dados{i, j} = ''; % Substitui valores vazios por uma string vazia
        else
            dados{i, j} = 'UNKNOWN'; % Trata tipos de dados não suportados
        end
    end
end

% Definir intervalo de k e nhf para análise
k_values = 2:4; % Valores de k a serem analisados
nhf_values = 100:100:300; % Valores de nhf a serem analisados

% Encontrar um primo grande
p = 123456789;
while ~isprime(p)
    p = p + 2;
end

% Inicializar armazenamento para diferenças médias
diferencas_medias = zeros(length(k_values), length(nhf_values));

% Loop sobre valores de nhf
for nhf_idx = 1:length(nhf_values)
    nhf = nhf_values(nhf_idx);
    rng(42); % Define o gerador de números aleatórios
    R = randi(p, nhf, max(k_values)); % Matriz de coeficientes para hash

    % Loop sobre valores de k
    for k_idx = 1:length(k_values)
        k = k_values(k_idx);

        % Gerar shingles para cada linha de celulas
        shingles = cell(size(celulas, 1) - 1, 1); % Inicializar armazenamento
        for i = 2:size(celulas, 1) % Ignorar a primeira linha (assumida como cabeçalho)
            row_data = strjoin(dados(i, :), ' '); % Junta as colunas com espaço
            shingle_list = {}; % Armazenamento temporário para os shingles

            len = length(row_data);
            if len >= k
                for ind = 1:(len - k + 1) % Gerar shingles
                    shingle = row_data(ind:ind + k - 1); % Extrai substring de comprimento k
                    shingle_list{end + 1} = shingle; % Adiciona à lista de shingles
                end
            end

            shingles{i - 1} = shingle_list; % Armazena os shingles
        end

        % Calcular matriz de assinaturas
        MA = calc_assinaturas_MinHashsh(shingles, nhf, R(:, 1:k), p);

        % Testar com uma entrada específica
        string = 'Men 24 184 82.4 Football 13.2 High 3.4 2.1 3';
        Set2 = {criar_conjuntos_string(string, k)};

        % Criar matriz de assinaturas para a entrada
        MA2 = calc_assinaturas_MinHashsh(Set2, nhf, R(:, 1:k), p);

        % Calcular as distâncias de Jaccard
        [k, n] = size(MA);
        distancias = zeros(1, n);
        valores_teoricos = zeros(1, n);

        for i = 1:n
            % Contar hashes iguais
            hashes_iguais = sum(MA(:, i) == MA2(:, 1));

            % Distância estimada
            distancias(i) = 1 - (hashes_iguais / k);

            % Cálculo do valor teórico
            intersecao = length(intersect(unique(Set2{1}), unique(shingles{i})));
            uniao = length(union(unique(Set2{1}), unique(shingles{i})));
            valores_teoricos(i) = 1 - (intersecao / uniao);
        end

        % Calcular a diferença média para o valor atual de k e nhf
        diferencas_medias(k_idx, nhf_idx) = mean(abs(valores_teoricos - distancias));
    end
end


%% Teste 2 Mapa de calor melhor valor de k e nhf--------------------------

% Encontrar o melhor k e nhf
[min_diff, min_idx] = min(diferencas_medias(:)); % Menor diferença média
[melhor_k_idx, melhor_nhf_idx] = ind2sub(size(diferencas_medias), min_idx); % Índices do melhor k e nhf

% Validar se os índices estão dentro dos limites
if melhor_k_idx > length(k_values) || melhor_nhf_idx > length(nhf_values)
    error('Os índices calculados estão fora dos limites.');
end

melhor_k = k_values(melhor_k_idx); % Melhor valor de k
melhor_nhf = nhf_values(melhor_nhf_idx); % Melhor valor de nhf

% Plotar o gráfico de calor
figure;
imagesc(nhf_values, k_values, diferencas_medias); % Matriz como imagem
colorbar; % Adicionar barra de cor
xlabel('Número de Funções Hash (nhf)');
ylabel('Valor de k (Tamanho dos Shingles)');
set(gca, 'YDir', 'normal'); % Corrigir direção do eixo Y para heatmap
colormap(jet); % Mapa de cores ajustado
yticks(k_values); % Mostrar apenas os valores 2, 3, 4 no eixo Y
xticks(nhf_values); % Mostrar apenas os valores 100, 200, 300 no eixo X

% Indicar o melhor ponto no gráfico
hold on;

% Adicionar ponto representando o melhor k e nhf
plot(nhf_values(melhor_nhf_idx), k_values(melhor_k_idx), 'ko', ...
    'MarkerSize', 10, 'MarkerFaceColor', 'k');

% Exibir o texto de forma visível no gráfico
text(nhf_values(melhor_nhf_idx), k_values(melhor_k_idx), ...
    sprintf(' Melhor (k=%d, nhf=%d)', melhor_k, melhor_nhf), ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', 'k', 'FontWeight', 'bold', 'FontSize', 10);

% Adicionar o título após a modificação completa do gráfico
title('Diferença Média (Estimativa vs Teórica) para k e nhf');

% Exibir o melhor k e nhf no console
fprintf('O melhor valor de k é: %d\n', melhor_k);
fprintf('O melhor valor de nhf é: %d\n', melhor_nhf);
