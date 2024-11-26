function prob_caracteristicas_dado_Cx = probCaractDadoClasse(TREINO,classes, Cx)
    
    linhas_Cx = classes == Cx; 
    TREINO_Cx = TREINO(linhas_Cx, :);

    % casos favoráveis e possiveis
    contagem = sum(TREINO_Cx);
    total = size(TREINO_Cx,1);

    % calcular quociente
    prob_caracteristicas_dado_Cx = contagem/total;

    fprintf('Matriz de P(Caracteristica|C%d):\n', Cx);
end