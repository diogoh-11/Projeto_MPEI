function [hash_code] = hash_function(athlete, k, n)
% Função que cria um código hash que representa o atleta
% Input:
% athlete- cell array com as caracteristicas do atleta
% k- representa a vez que esta a ser aplicada a funcao de hash para que haja diferencição de realização da função de hash k vezes no mesmo atleta
% n- indice máximo do bloom filter;
% Outpt:
% BF- bloom filtr atualizado

gender = athlete{1}; % string
age = double(athlete{2}); % número
height = double(athlete{3}); % número
weight = double(athlete{4}); % número
sport = athlete{5}; % string
Weekly_Training_Hours = double(athlete{6}); % número
Training_Intensity = athlete{7}; % string
Physical_Conditioning = double(athlete{8}); % número
Nutrition_Score = double(athlete{9}); % número
Previous_Injuries = double(athlete{10}); % número

% calcular hashcode
hash_code = string2hash(gender) + age * 1229 + height * 1231 + round(weight * 10) * 1237 + string2hash(sport) + round(Weekly_Training_Hours * 10) * 1249 + string2hash(Training_Intensity) + round(Physical_Conditioning * 10) * 1259 + round(Nutrition_Score * 10) * 1277 + Previous_Injuries * 1279;

% somar k * primo grande para diferenciar a vez que está a ser aplicada a função de hash
hash_code = hash_code + k * 1283;      

% adaptar codigo às dimensões do BF
hash_code = mod(hash_code, n) + 1;
    


end