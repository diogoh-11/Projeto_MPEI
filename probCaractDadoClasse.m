function prob_caracteristicas_dado_Cx = probCaractDadoClasse(TREINO, classes, Cx)
    % Usage:
    % Função para calcular P(x|Cx) para características contínuas
    % Entrada:
    %   TREINO - Matriz de características
    %   classes - Vetor de classes correspondentes ao TREINO
    %   Cx - Classe específica (ex.: C1 ou C2)
    % Saída:
    %   prob_caracteristicas_dado_Cx - Probabilidade P(x|Cx) para cada característica
    
    % Selecionar as linhas do TREINO pertencentes à classe Cx
    linhas_Cx = classes == Cx; 
    TREINO_Cx = TREINO(linhas_Cx, :);
    
    % Calcular média e desvio padrão para cada característica em cada classe
    mu_Cx = mean(TREINO_Cx, 1);
    sigma_Cx = std(TREINO_Cx, 0, 1);
    
    %------------------Dar mais peso a caracteristicas especifica--------
    % Mais peso para a caracteristica 
    fator_peso = 2;  % Exemplo: multiplicar a média por 2 e dividir o desvio padrão por 2
    
    mu_Cx(4) = mu_Cx(4) * fator_peso;  % Multiplica a média da primeira característica
    sigma_Cx(4) = sigma_Cx(4) / fator_peso;  % Divide o desvio padrão da primeira característica
    
    % Garantir que o desvio padrão não seja zero (para evitar divisão por zero)
    sigma_Cx(sigma_Cx == 0) = 1e-6;
    
    % Calcular P(x|Cx) para cada característica (distribuição normal)
    % P(x_i | Cx) = (1 / sqrt(2 * pi * sigma_i^2)) * exp(-(x_i - mu_i)^2 / (2 * sigma_i^2))
    prob_caracteristicas_dado_Cx = struct('mu', mu_Cx, 'sigma', sigma_Cx);
end
