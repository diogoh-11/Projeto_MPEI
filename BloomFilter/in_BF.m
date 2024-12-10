function in_filter = in_BF(BF, atleta, K, n)
% Verificar se um atleta pertence ao bloom filter
% Input: 
% BF- Filtro de bloom;
% Atleta- array com as características do atleta a verificar pertença;
% k- Número de funções de hash a aplicar
% Output- 
% variable that represents if the item is in the BF(1 -> in
% BF, 0 -> not in array) 

in_filter = 1;

for k=1:K
    hash_code = hash_function(atleta, k, n);

    if BF(hash_code) == 0
        in_filter = 0;
        break;
    end

end

end