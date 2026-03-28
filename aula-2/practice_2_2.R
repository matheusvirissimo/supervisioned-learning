# install.packages("NHANES")

# Carregar dados
# %%
library(NHANES)
data("NHANES")
dados <- NHANES

# ===========================================
# 1 selecionar um subconjunto do banco de dados do NHANES
names(dados)
colnames(dados)
# selecionarei Age, Weight, Height, BMI
df_subset <- dados[, c("Age", "Weight", "Height", "BMI")]
teste <- c("Age", "Weight", "Height", "BMI")

library(tidyverse)
glimpse(df_subset)

# %%
# tendência central 
# o sapply é parecidissimo com o map() do py
media <- sapply(df_subset, mean, na.rm = TRUE) # média
cat("======= Média ======\n",
    "Idade: ", media["Age"], "\n", # nolint
    "Peso: ", media["Weight"], "\n",
    "Altura: ", media["Height"], "\n",
    "IMC: ", media["BMI"], "\n"
)
mediana <- sapply(df_subset, median, na.rm = TRUE) # mediana
cat("======= Mediana ======\n",
    "Idade: ", mediana["Age"], "\n", # nolint
    "Peso: ", mediana["Weight"], "\n",
    "Altura: ", mediana["Height"], "\n",
    "IMC: ", mediana["BMI"], "\n"
)

# medidas de dispersão
variancia <- sapply(df_subset, var, na.rm = TRUE) # VARIANCIA
cat("======= Variância ======\n",
    "Idade: ", variancia["Age"], "\n", # nolint
    "Peso: ", variancia["Weight"], "\n",
    "Altura: ", variancia["Height"], "\n",
    "IMC: ", variancia["BMI"], "\n"
)

desvio_padrao <- sapply(
  X = df_subset, # vetor
  FUN = sd, # função a ser aplicado
  na.rm = TRUE
) #desvio standar
cat("======= desvio_padrao ======\n",
    "Idade: ", desvio_padrao["Age"], "\n", # nolint
    "Peso: ", desvio_padrao["Weight"], "\n",
    "Altura: ", desvio_padrao["Height"], "\n",
    "IMC: ", desvio_padrao["BMI"], "\n"
)

# minimo, máximo e intervalos
cat("======= Minimo e Máximo ======\n",
    "Idade mínima: ", min(df_subset$Age), " e máxima: ", max(df_subset$Age), "\n", # nolint
    "Peso mínima: ", min(df_subset$Height, na.rm = TRUE), " e máxima: ", max(df_subset$Height, na.rm = TRUE), "\n", # nolint
    "Altura mínima: ", min(df_subset$Weight, na.rm = TRUE), " e máxima: ", max(df_subset$Weight, na.rm = TRUE), "\n", # nolint
    "IMC mínima: ", min(df_subset$BMI, na.rm = TRUE), " e máxima: ", max(df_subset$BMI, na.rm = TRUE), "\n" # nolint
)

# %% 
# ================================
# 2 - Encontrar os quartis e interquartis 

cat("======= Quartis e Interquartis ======\n",
    "Idade Q1: ", quantile(df_subset$Age, probs = 0.25), "\n",
    "Peso Q1: ", quantile(df_subset$Weight, probs = 0.25, na.rm = TRUE), "\n",
    "Altura Q1: ", quantile(df_subset$Height, probs = 0.25, na.rm = TRUE), "\n",
    "IMC Q1: ", quantile(df_subset$BMI, probs = 0.25, na.rm = TRUE), "\n\n",

    "Idade Q2: ", quantile(df_subset$Age, probs = 0.25), "\n",
    "Peso Q2: ", quantile(df_subset$Weight, probs = 0.25, na.rm = TRUE), "\n",
    "Altura Q2: ", quantile(df_subset$Height, probs = 0.25, na.rm = TRUE), "\n",
    "IMC Q2: ", quantile(df_subset$BMI, probs = 0.25, na.rm = TRUE), "\n\n",

    "Idade Q3: ", quantile(df_subset$Age, probs = 0.25), "\n",
    "Peso Q3: ", quantile(df_subset$Weight, probs = 0.25, na.rm = TRUE), "\n",
    "Altura Q3: ", quantile(df_subset$Height, probs = 0.25, na.rm = TRUE), "\n",
    "IMC Q3: ", quantile(df_subset$BMI, probs = 0.25, na.rm = TRUE), "\n\n",

    "Idade Q3 - Q1: ", IQR(df_subset$Age), "\n",
    "Peso Q3 - Q1: ", IQR(df_subset$Weight, na.rm = TRUE), "\n",
    "Altura Q3 - Q1: ", IQR(df_subset$Height, na.rm = TRUE), "\n",
    "IMC Q3 - Q1: ", IQR(df_subset$BMI, na.rm = TRUE), "\n\n"
)
