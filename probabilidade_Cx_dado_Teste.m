function p = probabilidade_Cx_dado_Teste(prob_caracteristicas_dado_Cx, p_classe, x)
    % Função para calcular P(Cx|x) para um exemplo
    %
    % Calcular probabilidade condicional P(x|Cx) usando distribuição normal
    p = p_classe;  % Começar com a probabilidade da classe

    for i = 1:length(x)
        % Obter média e desvio padrão para a característica i
        mu = prob_caracteristicas_dado_Cx.mu(i);
        sigma = prob_caracteristicas_dado_Cx.sigma(i);
        
        % Calcular a probabilidade da característica i dada a classe (usando a fórmula normal)
        prob = (1 / (sigma * sqrt(2 * pi))) * exp(-0.5 * ((x(i) - mu) / sigma)^2);
        
        
        % Multiplicar a probabilidade da classe com a probabilidade da característica
        p = p * prob;
    end
end