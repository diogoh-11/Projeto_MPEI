function [probCondicionada] = probsDistrNormal(valor, coluna, CX, classes)
linhas_CX = classes == CX;
coluna_CX = coluna(linhas_CX);
mu = mean(coluna_CX);
sigma = std(coluna_CX);
probCondicionada = (1 / (sigma * sqrt(2 * pi))) * exp(-0.5 * ((valor - mu) / sigma)^2);
end