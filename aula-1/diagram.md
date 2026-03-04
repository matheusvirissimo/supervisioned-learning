flowchart LR

subgraph B1["Bloco 1 - Delineamento do problema"]
direction TB
b1-1["Objetivo geral: examinar a dinâmica de mutações virais e, a partir de um modelo de aprendizado supervisionado, predizer a evolução futura da frequência dos mesmos."]
b1-2["Resultado esperado: frequência de crescimento de mutações e possíveis vírus mais relevantes"]
end

b1-1 --> b1-2

subgraph B2["Bloco 2 - Construção do Banco de Dados"]
direction TB
    b2-1["Recorte de dados: 4.500 genonas coletados num perídoo de 5 anos (2020 a 2024), com múltiplos perídos epidêmicos, diferentes regiões geográficas e perfis demográficos"]
    b2-2["Organização de principal ativo de análise: amostra viral associada a um indivíduo em dado instante de tempo"]
    b2-3["Variação temporal: períodos epidemiológicos (alta demanda) e distribuição temporal irregular de observações (por picos em ondas)"]
end

b2-1 --> b2-2 --> b2-3

subgraph B3["Bloco 3 - Tratamento de ausência e padronização"]
direction TB
    b3-1["Diagnósticos de metadados: status vacinais faltantes, comorbidades autorreferidas (pode haver omissão)"]
    b3-2["Imputação múltipla: completar genomias virais quase completos"]
end

b3-1 --> b3-2

subgraph B4["Bloco 4 - Engenharia de atributos e hipóteses (tema)"]
direction TB
	b4-1["Interação entre variáveis: busca por correlação de idade, sexo, status vacinal, comorbidade e cenário de atendimento com incidência de mutações "]
    b4-2["Técnicas de redução de dimensionalidade: identificação e remoção de variáveis irredundantes e técnicas robustas como PCA, LDA"]
    b4-3["Flags: variável adicional para picos epidêmicos no período de amostragem"]
    b4-4["Comparabilidade: definir conjunto base de atributos (genoma, regiões) e ampliado (dados de paciente)"]
end

b4-1 --> b4-2 --> b4-3 --> b4-4

subgraph B5["Bloco 5 - Particionamento e validação interna"]
direction TB
    b5-1["Validação temporal com janelas expansíveis: treinamento com dados de um mês anterior para validar com o posterior e repetir o processo"]
	b5-2["Validação cruzada aninhada: "]
end

b5-1 --> b5-2

subgraph B6["Bloco 6 - Seleção e ajuste de modelos"]
direction TB
	B6_1["Modelos baseados em regressão: resistente a alta dimensionalidade"]
end

subgraph B7["Bloco 7 - Avaliação no teste"]
direction TB
	B7_1["Métricas de erro para regressão"]
    b7-2["Crescimento acelerado"]
end

subgraph B8["Bloco 8 - Consolidação, decisão e interação"]
direction TB
	B8_1["oi"]
end


B1 --> B2 --> B3 --> B4 --> B5 --> B6 --> B7 --> B8