function p = probabilidade_Cx_dado_Teste(prob_caracteristica_dado_classe, p_classe, x)
    % Função para calcular P(Cx|x) para um exemplo
    %
    % Calcular probabilidade condicional P(x|Cx) usando distribuição normal
    p = p_classe;  % Começar com a probabilidade da classe
    for i = 1:length(x)
        % Multiplicar pela probabilidade da característica condicional
        p = p * prob_caracteristica_dado_classe(i, x(i));
    end
end