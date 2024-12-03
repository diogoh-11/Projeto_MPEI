% Load and preprocess the dataset
M = readcell('injury_data.csv');

% Replace 1s and 0s in the last column with 'alto' and 'baixo'
ultima_coluna = M(2:end, end);
for i = 1:length(ultima_coluna)
    if isequal(ultima_coluna{i}, 1)
        ultima_coluna{i} = 'alto';
    elseif isequal(ultima_coluna{i}, 0)
        ultima_coluna{i} = 'baixo';
    end
end
M(2:end, end) = ultima_coluna;

% Extract features and labels
TREINO = cell2mat(M(2:end, 1:end-1));         % Features
TREINO(:, 1) = round(TREINO(:, 1), 2);        % Round age
TREINO(:, 2) = round(TREINO(:, 2));           % Round weight
classes = categorical(M(2:end, end));         % Labels ('alto', 'baixo')

% Nomes das classes 
nomes_classes = unique(classes);

% C1 e C2 representam as classes (C1 = alto risco; C2 = Baixo risco)
C1 = nomes_classes(1);  
C2 = nomes_classes(2); 

% Manually split the data (80% training, 20% testing)
num_samples = size(TREINO, 1);
train_size = round(0.8 * num_samples);

% Randomize the data order
rng(42); % For reproducibility
indices = randperm(num_samples);

% Training and testing sets
X_train = TREINO(indices(1:train_size), :);
y_train = classes(indices(1:train_size), :);
X_test = TREINO(indices(train_size+1:end), :);
y_test = classes(indices(train_size+1:end), :);

% Train a Naive Bayes classifier
NB_model = fitcnb(X_train, y_train, 'DistributionNames', 'normal');

% Predict the labels for the test set
y_pred = predict(NB_model, X_test);

% Evaluate the model
accuracy = sum(y_pred == y_test) / length(y_test);
fprintf('Accuracy: %.2f%%\n', accuracy * 100);

% Display the confusion matrix
confusionchart(y_test, y_pred);

% Predict the likelihood of injury for a new athlete
new_athlete = [30, 75, 180, 1, 0.5, 3]; % Example: Age, Weight, Height, Injuries, Intensity, Recovery Time
new_prediction = predict(NB_model, new_athlete);
fprintf('Predicted likelihood of injury: %s\n', new_prediction);

TP = 0;
FP = 0;
TN = 0;
FN = 0;

for j=1:length(y_pred)
    if y_pred(j) == C1 && y_test(j) == C1
        TP = TP + 1;  % True Positive
    elseif y_pred(j) == C1 && y_test(j) == C2
        FP = FP + 1;  % False Postive
    elseif y_pred(j) == C2 && y_test(j) == C1
        FN = FN + 1;  % False Negative
    elseif y_pred(j) == C2 && y_test(j) == C2
        TN = TN + 1;  % True Negative
    end
end

fprintf("TP: %d\n", TP);
fprintf("TN: %d\n", TN);
fprintf("FP: %d\n", FP);
fprintf("FN: %d\n", FN);

% Calcular Precisão, Recall e F1-score
Precisao = TP / (TP + FP);
Recall = TP / (TP + FN);
F1 = 2 * (Precisao * Recall) / (Precisao + Recall);

% Exibir os resultados
fprintf('Precisão: %.2f%%\n', Precisao*100);
fprintf('Recall: %.2f%%\n', Recall*100);
fprintf('F1-score: %.2f%%\n', F1*100);
