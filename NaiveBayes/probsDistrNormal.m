function probCondicionada = probsDistrNormal(valor, coluna, CX, classes)
    % Função que calcula p(valor|Cx)
    % realizar conversão para números
    valor = cell2mat(valor);
    % linhas correspondentes à classe Cx
    linhas_CX = classes == CX;
    % vetor coluna com os valores de Cx
    coluna_CX = cell2mat(coluna(linhas_CX));
    % calcular média e desvio padrão
    mu = mean(coluna_CX);
    sigma = std(coluna_CX);
    % impedir que desvio padrao seja 0 para evitar devisão por 0
    if sigma == 0
        sigma = 1e-6;
    end
    % aplicar fórmula para descobrir probabilidade condicionada
    probCondicionada = (1 / (sigma * sqrt(2 * pi))) * exp(-0.5 * ((valor - mu) / sigma)^2);
end