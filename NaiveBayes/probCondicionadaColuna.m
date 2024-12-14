function probCondicionada = probCondicionadaColuna(valor,coluna, CX, classes)
    % Função que calcula p(valor|Cx)
    % linhas correspondentes à classe Cx
    linhas_CX = classes == CX;
    % valores referentes à classe Cx
    coluna_CX = coluna(linhas_CX);
    % valores únicos
    coluna_unique = length(unique(coluna_CX));
    % total de valores
    total = length(coluna_CX);
    % casos favoráveis
    casos_favoraveis = sum(cellfun(@(x) isequal(x, valor), coluna_CX));
    % calculo probabilidade com suavozação para impedir porobabilidades de 0
    probCondicionada = (casos_favoraveis + 1) / (total + coluna_unique);
end