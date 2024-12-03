function [BF] = add_to_BF(atleta, BF, K, n)
% adiciona um atleta ao BF seguindo as k funções de hash;
% input: 
% -> atleta- atleta para adicionar
% -> BF- bloom filter array
% -> k- nº de funções de hash
% output: 
% BF- array BF atualizado; 

% repetir K vezes
    % aplicar função de hash a elemento
    % na posição indice do array colocar 1
count = 1;
for k= 1:K
    %fprintf("%d\n",count);
    count = count +1;
    hash_code = hash_function(atleta, k, n);
    BF(hash_code) = 1;
end

end