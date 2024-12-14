%% Script para teste de MinHash

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
nhf = 200;

p = 123456789;
while ~isprime(p)
    p = p + 2;
end

rng(42); % Definir o estado do gerador de números aleatórios
% Matriz de 200 por 3 funções de hash para ter os hash_codes de cada shingle
R = randi(p,nhf,k);

%% Matriz de assinaturas
nhf = 200;
fprintf(1,"Usando %d funções de dispersão\n", k);
MA = calc_assinaturas_MinHashsh(shingles,nhf,R,p);
imagesc(MA);


%% Testar
string = 'Women 20 184 72.2 Basketball 7.2 Moderate 2.8 2.1 2';
Set2 = {criar_conjuntos_string(string,k)};

% Criar matriz de assinaturas para a frase de input
MA2 = calc_assinaturas_MinHashsh(Set2,nhf,R,p);
imagesc(MA2)

%% Calcular as distancias

% Inicializar vetores valores teóricos e diferenças 
valores_teoricos = zeros(1, n);
diferencas = zeros(1, n);

% Dimensões da matriz
[k, n] = size(MA); % k = funções hash, n = número de filmes

% Jaccard(A,B) = |A∩B|/|AuB|
% Estimativa de Jaccard(A,B) = número de hashes iguais / k
% Distancia da estimativa de Jaccard(A,B) = 1 - (número de hashes iguais /
% k)
% Inicializar vetor de distâncias
distancias = zeros(1, n);

% Calcular a distância para cada filme
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