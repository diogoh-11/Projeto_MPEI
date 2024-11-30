function prob_caracteristicas_dado_Cx = probCaractDadoClasse(TREINO,classes, Cx)
    % Usage:
    % Função para calcular P(x|Cx) para características contínuas
    % Entrada:
    %   TREINO - Matriz de características
    %   classes - Vetor de classes correspondentes ao TREINO
    %   Cx - Classe específica (ex.: C1 ou C2)
    % Saída:
    %   prob_caracteristicas_dado_Cx - Probabilidade P(x|Cx)
    
    % Selecionar as linhas do TREINO pertencentes à classe Cx
    linhas_Cx = classes == Cx; 
    TREINO_Cx = TREINO(linhas_Cx, :);

    % Calcular média e desvio padrão para cada característica em cada classe
    mu_Cx = mean(TREINO_Cx, 1);
    sigma_Cx = std(TREINO_Cx, 0, 1);


    % Garantir que o desvio padrão não seja zero (para evitar divisão por zero)
    sigma_Cx(sigma_Cx == 0) = 1e-6;

    
    % Calcular P(x|Cx) para cada característica e multiplicar as probabilidades
    prob_caracteristicas_dado_Cx = struct('mu', mu_Cx, 'sigma', sigma_Cx);
    

end