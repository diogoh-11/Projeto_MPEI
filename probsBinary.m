function [probCondicionada] = probsBinary(coluna,valor, CX, classes)
linhas_CX = classes == CX;
colunaCX = coluna(linhas_CX);

total = length(colunaCX);
casos_favoraveis = sum(colunaCX == valor);
probCondicionada = (casos_favoraveis + 1)/(total + 2);
end