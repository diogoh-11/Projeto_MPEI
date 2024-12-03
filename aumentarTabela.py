import pandas as pd
import numpy as np

def gerar_dados(arquivo_entrada, arquivo_saida, n_linhas):
    """
    Gera novos dados baseados nas distribuições dos dados existentes e salva em um novo arquivo CSV.
    
    Parâmetros:
    - arquivo_entrada (str): Caminho do arquivo CSV com os dados originais.
    - arquivo_saida (str): Caminho do arquivo CSV onde os dados gerados serão salvos.
    - n_linhas (int): Número de novas linhas de dados a serem geradas.
    """
    # Ler os dados existentes
    dados = pd.read_csv(arquivo_entrada)
    
    # Gerar novos dados baseados nas distribuições dos dados existentes
    # Geração de Idades entre 20 e 40 anos
    novas_idades = np.random.randint(20, 41, size=n_linhas)
    
    # Geração de pesos com distribuição normal (média e desvio padrão dos dados originais)
    novas_pesos = np.random.normal(dados['Player_Weight'].mean(), dados['Player_Weight'].std(), size=n_linhas)
    
    # Geração de alturas com distribuição normal
    novas_alturas = np.random.normal(dados['Player_Height'].mean(), dados['Player_Height'].std(), size=n_linhas)
    
    # Geração de histórico de lesões (0 ou 1)
    novas_lesoes = np.random.randint(0, 2, size=n_linhas)
    
    # Geração de intensidade de treino entre 0 e 1
    novas_intensidades = np.random.rand(n_linhas)
    
    # Geração de tempos de recuperação entre 1 e 7 dias
    novos_tempos_recuperacao = np.random.randint(1, 7, size=n_linhas)
    
    # Inicializa a coluna de risco de lesão (geralmente 0, mas pode ser atualizado com algum critério)
    novos_riscos = np.zeros(n_linhas)
    
    # Cria um novo DataFrame com os dados gerados
    novos_dados = pd.DataFrame({
        'Player_Age': novas_idades,
        'Player_Weight': novas_pesos,
        'Player_Height': novas_alturas,
        'Previous_Injuries': novas_lesoes,
        'Training_Intensity': novas_intensidades,
        'Recovery_Time': novos_tempos_recuperacao,
        'Likelihood_of_Injury': novos_riscos
    })
    
    # Junta os dados originais com os novos dados
    dados_completos = pd.concat([dados, novos_dados], ignore_index=True)
    
    # Salva os dados completos em um novo arquivo CSV
    dados_completos.to_csv(arquivo_saida, index=False)
    
    print(f"Novos dados gerados e salvos em: {arquivo_saida}")

# Exemplo de uso
arquivo_entrada = 'injury_data2.csv'  # Caminho do arquivo de dados originais
arquivo_saida = 'injury_data2.csv'  # Caminho para salvar os novos dados
n_linhas = 500  # Número de novas linhas a serem geradas

gerar_dados(arquivo_entrada, arquivo_saida, n_linhas)
