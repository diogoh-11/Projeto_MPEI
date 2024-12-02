# Projeto: Análise Preditiva de Lesões em Jogadores de Futebol

## Descrição do Projeto
Este projeto utiliza técnicas de Ciência de Dados para analisar dados de jogadores e prever a probabilidade de ocorrência de lesões. Por meio de uma combinação de métodos como o classificador **Naive Bayes**, **Bloom Filter** e **Minhash**, conseguimos identificar jogadores com alta propensão a lesões, considerando fatores históricos e padrões de similaridade entre atributos de diferentes jogadores.

---

## Estrutura e Métodos

1. **Naive Bayes**:
   - Utilizado para prever a probabilidade de um jogador sofrer lesões com base em atributos conhecidos (ex.: idade, peso, altura, histórico de lesões, lesões anteriores, intensidade de treino, tempo de recuperação, etc.).

2. **Bloom Filter**:
   - Um Bloom Filter é implementado para armazenar eficientemente o histórico de atributos de jogadores, permitindo verificar rapidamente se um conjunto de características já foi analisado.
   - Método probabilístico que pode retornar falsos positivos, mas nunca falsos negativos, ideal para filtrar rapidamente jogadores similares.

3. **Minhash**:
   - Utilizado para medir a similaridade entre jogadores, considerando subconjuntos de características.
   - Identifica padrões de atributos semelhantes, determinando grupos de risco de lesão baseados em casos históricos.

---

## Fluxo do Projeto

1. **Pré-processamento de Dados**:
   - Dados dos jogadores são limpos e normalizados.
   - Características-chave são selecionadas para o modelo.

2. **Treinamento e Classificação**:
   - O Naive Bayes é treinado com um conjunto de dados rotulado.
   - O modelo prevê a probabilidade de um jogador estar suscetível a lesões.

3. **Filtragem com Bloom Filter**:
  

4. **Comparação por Similaridade com Minhash**:
   

5. **Conclusão e Resultados**:
  

---