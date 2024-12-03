import pandas as pd

def atualizar_likelihood_csv(arquivo_entrada, arquivo_saida):
    """
    Lê um arquivo CSV, atualiza a coluna 'Likelihood_of_Injury' com base em características realistas,
    e salva o resultado em um novo arquivo CSV.

    Parâmetros:
    - arquivo_entrada (str): Caminho para o arquivo CSV de entrada.
    - arquivo_saida (str): Caminho para o arquivo CSV de saída.
    """
    # Ler o arquivo CSV
    df = pd.read_csv(arquivo_entrada)
    
    def calcular_probabilidade(row):
        prob = 0
        # Aumenta a probabilidade para jogadores mais velhos
        if row['Player_Age'] > 35:
            prob += 0.2
        elif row['Player_Age'] < 30:
            prob -= 0.1

        # Peso alto em relação à altura (IMC acima de 25)
        bmi = row['Player_Weight'] / ((row['Player_Height'] / 100) ** 2)
        if bmi > 25:
            prob += 0.2
        elif bmi < 20:
            prob += 0.1
        elif bmi > 30:
            prob += 0.4


        #-------------------Risco Maximo-------------------------------------------------------
        # Histórico de lesões
        if (row['Previous_Injuries'] == 1) & (row['Recovery_Time'] < 2) & (row['Training_Intensity'] > 0.8):
            prob += 0.6

        # Intensidade do treino
        if (row['Training_Intensity'] > 0.8) & (row['Recovery_Time'] < 2) & (row['Player_Age'] > 32):
            prob += 0.4
        #----------------------------------------------------------------------------------------

        # Histórico de lesões
        if (row['Previous_Injuries'] == 1) & (row['Training_Intensity'] > 0.8):
            prob += 0.4
        


        # Manipulando idade
        if (row['Player_Age'] > 32) & (row['Training_Intensity'] > 0.8):
            prob += 0.6

        if (row['Player_Age'] > 32) & (row['Recovery_Time'] < 2):
            prob += 0.6

        if (row['Player_Age'] > 32) & (row['Previous_Injuries'] == 1):
            prob += 0.6

        
        # Manipulando altura
        if (row['Player_Height'] > 200) & (row['Training_Intensity'] > 0.8):
            prob += 0.6

        if (row['Player_Height'] > 200) & (row['Recovery_Time'] < 2):
            prob += 0.6

        if (row['Player_Height'] > 200) & (row['Previous_Injuries'] == 1):
            prob += 0.6
        


        # Recuperação insuficiente
        if row['Recovery_Time'] < 2:
            prob += 0.3
        
        # TI
        tI = row['Training_Intensity']
        if 0.7 > tI > 0.5:
            prob += 0.2
        elif tI > 0.7:
            prob += 0.3

        # Rt
        rT = row['Recovery_Time']
        if rT < 2:
            prob += 0.3
        elif 2 < rT < 0.4:
            prob += 0.2

        # Convertendo probabilidade para 0 ou 1
        return 1 if prob >= 0.5 else 0

    # Aplicar a função a cada linha
    df['Likelihood_of_Injury'] = df.apply(calcular_probabilidade, axis=1)

    # Salvar o DataFrame atualizado em um novo arquivo CSV
    df.to_csv(arquivo_saida, index=False)
    print(f"Arquivo atualizado salvo em: {arquivo_saida}")

# Exemplo de uso
arquivo_entrada = 'injury_data.csv'  # Substitua pelo nome do seu arquivo
arquivo_saida = 'injury_data2.csv'
atualizar_likelihood_csv(arquivo_entrada, arquivo_saida)
