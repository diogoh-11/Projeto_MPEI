addpath("./BloomFilter");
addpath("./NaiveBayes");
addpath("./MinHash");
addpath("./data");

%% Criação das matrizes e vetores de dados retirados do ficheiro

M = readcell('athlete_injury_data.csv'); 

% Vetor das características
caracteristicas = categorical(M(1, 2:end-1));

% Matriz dos valores associados a cada característica
TREINO = cell(M(2:end, 1:end-1));

% Vetor coluna com as classes dos atletas
classes = categorical(M(2:end, end)); 

% Nomes das classes 
nomes_classes = unique(classes);

% C1 e C2 representam as classes (C1 = alto risco; C2 = Baixo risco)
C_high = nomes_classes(1);  
C_low = nomes_classes(2);

clear M;


%% Dar load ou inicializar bloom filter com atletas C_high

% n=80000;
% m = 10000;
% BF = initialize_BF(n);
% % k_otimo = n * ln(2) / m
% K = round(n * log(2) / m);
% 
% fprintf("K ótimo: %d\n", K);
% 
% for i=1:length(TREINO)
%     if classes(i) == C_high               % Adicionar ao bloom filter atletas de risco para testar
%         atleta = TREINO(i, :);
%         BF = add_to_BF(atleta, BF, K, n);
%     end
% end
% 
% save('BF.mat', 'BF', 'n', 'm', 'K')
% %stem(BF);

load("BF.mat");

%% Recolher inputs do utilizador

prompt = { ...
    '  Athlete''s Gender:', ...
    '  Athlete''s Age:', ...
    '  Athlete''s Height (cm):', ...
    '  Athlete''s Weight (Kg):', ...
    '  Athlete''s Sport:', ...
    '  Athlete''s Weekly Training Hours:', ...
    '  Athlete''s Training Intensity (Low, Moderate, High):', ...
    '  Athlete''s Physical Conditioning [0, 10]:', ...
    '  Athlete''s Nutrition Score [0, 10]:', ...
    '  Athlete''s Previous Injuries:' ...
};

title = 'Athletes''s characteristics ';
dims = [1 50];
defaultInput = {'Men', '39', '187', '83', 'Football', '21', 'High', '10', '10', '0'};
athlete = (inputdlg(prompt, title, dims, defaultInput))';

if isempty(athlete)
    disp('No input was given. Exiting...');
    return;
end

% Verificar inputs e realizar conversões

% Gender
if strcmp(athlete{1}, 'Men') == 0 && strcmp(athlete{1}, 'Women') == 0
    fprintf("Invalid gender input!\n");
    return;
end

% age
try 
    age = str2double(athlete{2});
    if isnan(age) || age <= 0
        fprintf("Invalid age input!\n");
        return;
    end
    athlete{2} = age;
catch 
    fprintf("Invalid age input!\n");
    return;
end

% height
try 
    height = str2double(athlete{3});
    if isnan(height) || height <= 0
        fprintf("Invalid height input!\n");
        return;
    end
    athlete{3} = height;
catch 
    fprintf("Invalid height input!\n");
    return;
end

% weight
try 
    weight = str2double(athlete{4});
    if isnan(weight) || weight <= 0
        fprintf("Invalid weight input!\n");
        return;
    end
    athlete{4} = weight;
catch 
    fprintf("Invalid weight input!\n");
    return;
end

% weekly_training_hours
try 
    weekly_training_hours = str2double(athlete{6});
    if isnan(weekly_training_hours) || weekly_training_hours < 0
        fprintf("Invalid weekly_training_hours input!\n");
        return;
    end
    athlete{6} = weekly_training_hours;
catch 
    fprintf("Invalid weekly_training_hours input!\n");
    return;
end

% Training_Intensity
if strcmp(athlete{7}, 'Low') == 0 && strcmp(athlete{7}, 'Moderate') == 0 && strcmp(athlete{7}, 'High') == 0
    fprintf("Invalid training intensity input!\n");
    return;
end

% physical_conditioning
try 
    physical_conditioning = str2double(athlete{8});
    if isnan(physical_conditioning) || physical_conditioning < 0 || physical_conditioning > 10
        fprintf("Invalid physical conditioning input!\n");
        return;
    end
    athlete{8} = physical_conditioning;
catch 
    fprintf("Invalid physical conditioning input!\n");
    return;
end

% nutrition_score
try 
    nutrition_score = str2double(athlete{9});
    if isnan(nutrition_score) || nutrition_score < 0 || nutrition_score > 10
        fprintf("Invalid nutrition score input!\n");
        return;
    end
    athlete{9} = nutrition_score;
catch 
    fprintf("Invalid nutrition score input!\n");
    return;
end

% previous_injuries
try 
    previous_injuries = str2double(athlete{10});
    if isnan(previous_injuries) || previous_injuries < 0
        fprintf("Invalid previous injuries input!\n");
        return;
    end
    athlete{10} = previous_injuries;
catch 
    fprintf("Invalid previous injuries input!\n");
    return;
end



%% Verificar pertença ao Blomm Filter

athlete_in_BF = in_BF(BF, athlete, K, n);

if athlete_in_BF == 0
    msg = 'Athlete NOT found! Proceding with Naive Bayes...';
    title = 'Failure';
    m = msgbox(msg, title, 'error');
    uiwait(m);
    athlete_class = Naive_Bayes(athlete, TREINO, classes);
    if athlete_class == C_high
        msg = sprintf('Naive Bayes classifier result: %s.\nAthlete added to bloom filter.', athlete_class);
    else
        msg = sprintf('Naive Bayes classifier result: %s\n', athlete_class);
    end

    title = 'Results';
    m = msgbox(msg, title, 'help');
    uiwait(m);

    BF = add_to_BF(athlete, BF, K, n);
    save('BF.mat', 'BF', 'n', 'm', 'K');

else
    msg = 'Athlete found! Athlete will have HIGH probability of sustaining an injury.';
    title = 'Success';
    m = msgbox(msg, title, 'help');
    uiwait(m);
end

%% Min Hash

title = 'Similar athletes';
prompt = {'  Would you like to get a list of athletes with a similar profiles as the prompted athlete?', '  Number of athletes pretended: '};
dims = [1 90];
defaultInput = {'yes/no', 'number'};
answer = (inputdlg(prompt, title, dims, defaultInput))';

if isempty(answer)
    disp('No input was given. Exiting...');
    return;
end

if strcmpi(answer{1}, 'y') == 1 || strcmpi(answer{1}, 'yes') == 1
    % Chamar método minHash e dar output aos resultados num msgBox
    try 
        N = str2double(answer{2});
        if isnan(N) || N <= 0
            fprintf("Invalid ""N"" input!\n");
            return;
        end
        MinHash(athlete, N)
    catch 
        fprintf("Invalid ""N"" input or an error ocurred when calling MinHash!\n");
        return;
    end
end

msg = 'Programm ended. Thank you for using us!';
title = 'END';
m = msgbox(msg, title, 'help');
uiwait(m);