function [probCondicionada] = probsDistrNormal(valor, coluna, CX, classes)
    valor = cell2mat(valor);
    linhas_CX = classes == CX;
    coluna_CX = cell2mat(coluna(linhas_CX));
    mu = mean(coluna_CX);
    sigma = std(coluna_CX);
    if sigma == 0
        sigma = 1e-6;
    end
    probCondicionada = (1 / (sigma * sqrt(2 * pi))) * exp(-0.5 * ((valor - mu) / sigma)^2);
end