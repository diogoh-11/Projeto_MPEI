function [probCondicionada] = probCondicionadaColuna(valor,coluna, CX, classes)
    linhas_CX = classes == CX;
    coluna_CX = coluna(linhas_CX);
    coluna_unique = length(unique(coluna_CX));
    total = length(coluna_CX);
    casos_favoraveis = sum(cellfun(@(x) isequal(x, valor), coluna_CX));
    probCondicionada = (casos_favoraveis + 1) / (total + coluna_unique);
end