function shingleList = criar_conjuntos_string(str, k)
    % Cria os shingles de uma string
    len = length(str);
    shingleList = cell(1, max(0, len - k + 1));
    for ind = 1:(len - k + 1)
        shingleList{ind} = str(ind:ind + k - 1);
    end
end