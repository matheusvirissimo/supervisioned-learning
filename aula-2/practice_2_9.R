# Importar dados
library(survival)
df <- lung

# Selecionar variáveis contínuas de interesse clínico presentes no conjunto de dados #nolint
str(df)
selected_cols <- c("age", "time")
df_subset <- df[, selected_cols]

# inspecionar estatísticas descritivas básicas das variáveis selecionadas nos dados originais #nolint
summary(df_subset)

# Aplicação de padronização
## z-score
media <- mean(df_subset$age)
desvio_padrao <- sd(df_subset$age)

z_score <- function(valor){
    x <- (valor - media) / desvio_padrao
    return(x)
}
teste_1 <- z_score(df_subset$age)
print(teste_1)
summary(teste_1)

## mediana e quartis
mediana_quartil <- function(valor){
    x <- (valor - median(valor))/IQR(valor)
    return(x)
}
teste_2 <- mediana_quartil(df_subset$time)
print(teste_2)
summary(teste_2)
