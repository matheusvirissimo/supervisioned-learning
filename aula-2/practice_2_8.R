library(mlbench)

# Importar os dados 
data(PimaIndiansDiabetes)
df <- PimaIndiansDiabetes
str(df)

# Seleção de variáveis continuas
selected_cols <- c("glucose", "pressure", "insulin", "mass")
df_subset <- df[, selected_cols]
str(df_subset)

# Inspecionar os intervalos originais de variação dessas variáveis;
summary(df_subset)
cat(
  "======= Minimo e Máximo ======\n",
  "Glicose mínima: ", min(df_subset$glucose), " e máxima: ", max(df_subset$glucose), "\n", # nolint
  "Pressão mínima: ", min(df_subset$pressure, na.rm = TRUE), " e máxima: ", max(df_subset$pressure, na.rm = TRUE), "\n", # nolint
  "Insulina mínima: ", min(df_subset$insulin, na.rm = TRUE), " e máxima: ", max(df_subset$insulin, na.rm = TRUE), "\n", # nolint
  "Massa mínima: ", min(df_subset$mass, na.rm = TRUE), " e máxima: ", max(df_subset$mass, na.rm = TRUE), "\n" # nolint
)

# Procedimentos de normalização 
## min-max
min_max <- function(valor){
    x <- (valor - min(valor)) / (max(valor) - min(valor))
    return(x)
}

teste_1 <- min_max(df_subset$glucose)
summary(teste_1)

## valor máximo 
max_value <- function(valor){
    x <- valor/max(valor)
    return(x)
}

teste_2 <- max_value(df_subset$pressure)
print(teste_2)
summary(teste_2)


## Por amplitude
amplitude <- function(valor){
    x <- valor/(max(valor) - min(valor))
    return(x)
}
teste_3 <- max_value(df_subset$insulin)
print(teste_3)
summary(teste_3)


## Por quantis
q1 <- quantile(df_subset$mass, prob = 0.25, na.rm = TRUE)
q2 <- quantile(df_subset$mass, prob = 0.75, na.rm = TRUE)
quantis <- function(valor){
    x <- (valor - q1) / (q2 - q1)
    return(x)
}

teste_4 <- quantis(df_subset$mass)
summary(teste_4)


