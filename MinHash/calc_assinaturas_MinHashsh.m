function MH = calc_assinaturas_MinHashsh(Set,k,R,p)
    
    Nu = length(Set);
    J = zeros(Nu,Nu);
    h = waitbar(0,'Calculating MinHash Distances');
    
    
    % 1 - calcular matriz minhash
    MH = zeros(k,Nu);
        
    % para cada função de hash
    for hf = 1:k
        % Barra de progresso
        waitbar(hf / k, h, sprintf('Calculating MinHash... (%d/%d)', hf, k));

        % para cada user (mais propriamente conjunto desse user)
        for user = 1:Nu
            conjunto = Set{user};
            hash_codes = zeros(1,length(conjunto));
            % aplicar função de hash a todos os elementos do conjunto
            for elem = 1:length(conjunto)
                hash_codes(elem) = hash_function(conjunto{elem},hf,R,p);
            end
            % obter minimo de hash codes gerados
            minhash = min(hash_codes);
            % guardar na matriz (posição = hash, user
            MH(hf,user) = minhash;
        end
    
    end
    delete(h);
end