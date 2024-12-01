function [hash_code] = hash_function(atleta, k, n)
% Função que cria um código hash que representa o atleta
% Input:
% atleta- array com as caracteristicas do atleta
% k- representa a vez que esta a ser aplicada a funcao de hash para que haja diferencição de realização da função de hash k vezes no mesmo atleta
% n- indice máximo do bloom filter;
% Outpt:
% BF- bloom filtr atualizado

age = atleta(1);        % int
weight = atleta(2);     % double
height = atleta(3);     % double
previous_injuries = atleta(4);      % 1 ou 0
training_intensity = atleta(5);     % double [0,1]
recovery_time = atleta(6);          % int

hash_code = age * 31 + round(weight * 100) * 37 + height * 41 + previous_injuries * 43 + round(training_intensity * 1e7) * 47 + recovery_time * 53;
hash_code = hash_code + k * 59;      

% adaptar codigo às dimensões do BF
hash_code = mod(hash_code, n) + 1;
    


end