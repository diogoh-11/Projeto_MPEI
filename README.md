# Projeto: Análise Preditiva de Lesões em Desportistas

## Descrição do Projeto
Este projeto utiliza técnicas de Ciência de Dados para analisar dados de atletas e prever a probabilidade de ocorrência de lesões. Através de uma combinação de métodos como o classificador **Naive Bayes**, **Bloom Filter** e **Minhash**, conseguimos identificar atletas com alta propensão a lesões, considerando fatores históricos e padrões de similaridade entre atributos de diferentes atletas.

---

## Estrutura e Métodos

1. **Naive Bayes**:
   - Utilizado para prever a probabilidade de um atleta sofrer lesões com base em atributos conhecidos (ex.: idade, peso, altura, histórico de lesões, lesões anteriores, intensidade de treino, tempo de recuperação, etc.).

2. **Bloom Filter**:
   - O **Bloom Filter** é implementado para armazenar eficientemente o histórico de atributos de atletas, permitindo verificar rapidamente se um conjunto de características já foi analisado.
   - É um método probabilístico que pode retornar falsos positivos, mas nunca falsos negativos, sendo ideal para filtrar rapidamente atletas semelhantes.

3. **Minhash**:
   - O **Minhash** é utilizado para medir a similaridade entre atletas, considerando subconjuntos de características.
   - Identifica padrões de atributos semelhantes, determinando grupos de risco de lesão baseados em casos históricos.

---

## Fluxo do Projeto

1. **Pré-processamento de Dados**
   - O programa começa com a inicialização do **Filtro de Bloom**, que contém os atletas com alto risco de lesão. Caso o filtro precise ser reinicializado, isso pode ser feito facilmente no código.
   - O utilizador insere um conjunto de valores para as características do atleta, como **gênero**, **idade**, **altura**, **peso**, **esporte praticado**, **horas de treino semanais**, **intensidade do treino**, **condição física**, **índice de nutrição** e **número de lesões anteriores**.
   - Esses dados são verificados e armazenados, garantindo que estejam prontos para análise e classificação.

2. **Filtragem com Bloom Filter**
   - O **Filtro de Bloom** é utilizado para armazenar os atletas de alto risco de lesão de maneira eficiente, permitindo a verificação rápida de pertencimento. Quando um atleta é classificado como de alto risco, ele é adicionado ao filtro para evitar classificações repetidas.
   - A técnica do filtro de Bloom oferece uma solução de baixo custo computacional para armazenar e consultar grandes volumes de dados de forma eficiente, com uma taxa muito baixa de falsos positivos (atletas que não estão realmente no filtro, mas são identificados como pertencentes).

3. **Treinamento e Classificação com Naive Bayes**
   - Após a inserção dos dados do atleta, o programa verifica se ele já está presente no Filtro de Bloom. Se o atleta estiver no filtro, é rapidamente concluído que ele tem alto risco de lesão, embora com uma margem de erro devido à natureza probabilística do filtro.
   - Caso o atleta não esteja no Filtro de Bloom, o sistema recorre ao **classificador Naive Bayes**, que foi treinado com um conjunto de dados rotulado (70% dos dados para treinamento e 30% para teste). O classificador então prevê a classe de risco do atleta (alto ou baixo risco de lesão).
   - Quando um atleta é classificado como de alto risco, ele é adicionado ao Filtro de Bloom para futuras verificações rápidas.

4. **Comparação por Similaridade com MinHash**
   - Após a classificação do atleta, o programa permite ao utilizador solicitar um conjunto de atletas com perfil semelhante. O módulo **MinHash** é utilizado para calcular a similaridade entre os atletas, com base nas características inseridas (ex.: altura, peso, intensidade do treino, etc.).
   - **MinHash** é uma técnica eficiente para comparar grandes conjuntos de dados utilizando "shingles" (sequências de tamanho \(k = 3\)) extraídos dos dados. Ela gera uma assinatura compacta para os atributos dos atletas, permitindo calcular a distância de Jaccard entre eles e identificar atletas com características semelhantes.
   - O usuário pode definir a quantidade de atletas a serem retornados, e o sistema exibe os resultados mais relevantes, mostrando a distância de Jaccard entre os atletas, além da diferença teórica dessa distância.

---

## Conclusão e Resultados

### **Capacidade do Sistema**
   - O sistema integra diferentes técnicas para classificar e comparar atletas com base em dados reais e contínuos, como altura, peso, idade e outras características físicas. Isso torna o sistema útil para gestão de risco de lesões e identificação de atletas com perfis semelhantes.
   - Mesmo com dados reais, a previsão do risco de lesão tem limitações, pois os dados utilizados são genéricos e não capturam nuances importantes, como histórico médico detalhado, tipo de treino específico ou fatores externos influentes.

### **Limitações**
   - A principal limitação do sistema reside na falta de detalhes profundos sobre os atletas. Sem informações como a biomecânica de cada atleta, o tipo de treino específico, a genética ou o histórico médico detalhado, o modelo é incapaz de fazer previsões altamente precisas sobre o risco de lesão.
   - A previsão de lesões é complexa e multifatorial, sendo influenciada por uma série de fatores difíceis de quantificar. Mesmo utilizando ferramentas como Naive Bayes, Filtro de Bloom e MinHash, a precisão das previsões é limitada pela natureza dos dados disponíveis.

### **Reflexão Realista**
   - Este cenário reflete a realidade, onde prever lesões com alta precisão é extremamente desafiador. Lesões são influenciadas por uma combinação de fatores internos e externos, como a intensidade do treino, a genética e o ambiente esportivo, que não são capturados facilmente com dados simples e genéricos.
   - Apesar das limitações, o sistema serve como uma ferramenta útil para análise de risco e agrupamento de atletas com base em suas características, sendo uma boa base para futuras melhorias com dados mais granulares e especializados.

### **Resultados Gerais**
   - Embora o sistema não seja capaz de prever lesões com alta precisão devido à natureza dos dados, ele oferece uma solução eficiente para identificar atletas com risco de lesão e sugerir outros atletas com perfis semelhantes, auxiliando na gestão e análise de atletas em diferentes contextos esportivos.


