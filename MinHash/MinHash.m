%% MinHash

% step 1 calcular os shingles
dic2 = readcell('athlete_injury_data.csv', 'Delimiter', ',');

% Convert entire dataset to string format
for i = 1:size(dic2, 1)
    for j = 1:size(dic2, 2) - 1
        value = dic2{i, j}; % Get the cell value

        if isnumeric(value)
            dic2{i, j} = num2str(value); % Convert numeric to string
        elseif ischar(value) || isstring(value)
            dic2{i, j} = char(value); % Ensure consistent string format
        elseif isempty(value)
            dic2{i, j} = ''; % Replace empty values with an empty string
        else
            dic2{i, j} = 'UNKNOWN'; % Handle unsupported data types
        end
    end
end

% Initialize shingles storage
shingles = cell(size(dic2, 1) - 1, 1); % Cell array for shingles
k = 3; % Length of shingles

% Generate shingles for each row in dic2
for i = 2:size(dic2, 1) % Skip the first row (assumed header)
    % Concatenate all columns of the row into a single string
    row_data = strjoin(dic2(i, :), ''); % Join columns with a space separator
    shingle_list = {}; % Temporary storage for shingles

    len = length(row_data); % Length of the concatenated row string

    if len >= k
        for ind = 1:(len - k + 1) % Generate shingles
            shingle = row_data(ind:ind + k - 1); % Extract substring of length k
            shingle_list{end + 1} = shingle; % Append to the shingle list
        end
    end

    shingles{i-1} = shingle_list; % Store shingles in the output cell
end



% shingles = cell(size(dic2, 1) - 1, 1); % Cell array for shingles
% k = 3; % Length of shingles
% % Create shingles for each row in dic2
% for i = 2:size(dic2, 1) % Start from row 2 to skip header (if present)
%     shingle_list = {}; % Temporary storage for shingles
% 
%     for j = 1:size(dic2, 2) - 1 % Loop over each column
%         data = dic2{i, j}; % Get the data from the cell array
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

% Matriz de 200 por 3 funções de hash para ter os hash_codes de cada shingle
R = randi(p,nhf,k);

%% Matriz de assinaturas
nhf = 200;
fprintf(1,"Usando %d funções de dispersão\n", k);
MA = calc_assinaturas_MinHashsh(shingles,nhf,R,p);
imagesc(MA);


%% Testar
string = 'Female 20 150 80.2 Soccer 8.2 Low 5.1 7 2';
Set2 = {criar_conjuntos_string(string,k)};

% Criar matriz de assinaturas para a frase de input
MA2 = calc_assinaturas_MinHashsh(Set2,nhf,R,p);
imagesc(MA2)

%% Calcular as distancias

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
end

% Ordenar as distâncias em ordem crescente
[distancias_ordenadas, indices] = sort(distancias);

% Selecionar os 3 filmes mais próximos
top10_indices = indices(1:10);
top3_distancias = distancias_ordenadas(1:10);



% Exibir os filmes mais próximos
fprintf('Os 3 atletas mais similares são:\n');
for i = 1:10
    
    % Extrair a linha correspondente
    linha_atleta = dic2(top10_indices(i) + 1, :); % Linha do atleta
    
    % Converter cada elemento da linha em uma string
    linha_str = cellfun(@(x) num2str(x), linha_atleta, 'UniformOutput', false);
    
    % Concatenar os valores da linha em uma única string
    atleta_nome = strjoin(linha_str, ' '); % Concatena com espaço entre valores


    fprintf('%s com distância %.4f\n', atleta_nome, top3_distancias(i));
end





