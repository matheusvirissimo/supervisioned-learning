library(ggplot2)
library(patchwork)


# DEFINIÇÃO DOS PARÂMETROS 
# __________________________________________________ 
set.seed(666)

n_treino <- 1000     
n_teste  <- 1000     
alpha    <- -0.5     
beta     <- 1.2      
sigma    <- 1.0      
a        <- 1.0      
delta    <- 1.5     


# AVALIAÇÃO
#___________________________________________________________________________
auc <- function(y, score){
  r <- rank(score, ties.method = "average")
  n1 <- sum(y == 1); n0 <- sum(y == 0)
  if (n1 == 0 || n0 == 0) return(NA_real_)
  (sum(r[y == 1]) - n1 * (n1 + 1) / 2) / (n1 * n0)
}

brier <- function(y, p) mean((y - p)^2)

ece <- function(y, p, bins = 10){
  cutp <- cut(p, breaks = seq(0, 1, length.out = bins + 1), include.lowest = TRUE)
  tab  <- split(data.frame(y = y, p = p), cutp)
  out  <- 0
  for (g in tab) if (nrow(g) > 0) out <- out + (nrow(g)/length(y)) * abs(mean(g$y) - mean(g$p))
  out
}

metrics <- function(y, p) c(AUC = auc(y, p), Brier = brier(y, p), ECE = ece(y, p))


#___________________________________________________________________________#

gerar_dados <- function(n_obs, cenario) {
  
  X_star <- rnorm(n_obs, mean = 0, sd = sigma)
  prob   <- plogis(alpha + beta * X_star)
  Y      <- rbinom(n_obs, 1, prob)
  
  # Erro aleatório 
  U <- runif(n_obs, min = -a, max = a)
  X_obs <- switch(cenario,
                  "Limpo"       = X_star,
                  "Aleatorio"   = X_star + U,
                  "Sistematica" = X_star + delta + U) 
  
  data.frame(Y = Y, 
             X = X_obs, 
             processo = factor(cenario, levels = c("Limpo", "Aleatorio", "Sistematica")))
}


# MODELOS
# ____________________________________________________________________________ #

dados_treino <- rbind(gerar_dados(n_treino/3, "Limpo"), 
                      gerar_dados(n_treino/3, "Aleatorio"), 
                      gerar_dados(n_treino/3, "Sistematica"))

# Modelo utilizando apenas a variável observada X
modelo_simples  <- glm(Y ~ X, data = dados_treino, family = binomial)

# Modelo incluindo X e indicadoras
modelo_completo <- glm(Y ~ X + processo, data = dados_treino, family = binomial)


# 5. AVALIAÇÃO DOS CENÁRIOS DE TESTE
#_____________________________________________________________________________ #

teste_limpo <- gerar_dados(n_teste, "Limpo")
teste_aleat <- gerar_dados(n_teste, "Aleatorio")
teste_sist  <- gerar_dados(n_teste, "Sistematica")

imprimir_relatorio <- function(dados_teste, titulo) {
  p_simp <- as.numeric(predict(modelo_simples,  dados_teste, type = "response"))
  p_comp <- as.numeric(predict(modelo_completo, dados_teste, type = "response"))
  
  cat("\n==========================================\n")
  cat(" Cenário:", titulo, "\n")
  cat("==========================================\n")
  res <- rbind("MI (Apenas X)    " = metrics(dados_teste$Y, p_simp),
               "MAL (X + Indicad.)" = metrics(dados_teste$Y, p_comp))
  print(round(res, 4))
}

cat("\nRESULTADOS DE PERFORMANCE PREDITIVA\n")
imprimir_relatorio(teste_limpo, "1. Limpo (Medição Correta)")
imprimir_relatorio(teste_aleat, "2. Apenas Erro Aleatório")
imprimir_relatorio(teste_sist,  "3. Erro Sistemático Persistente")


# 6. ANÁLISE GRÁFICA AVANÇADA (Calibração Sobreposta)
# ____________________________________________________________________________#
plot_calibracao <- function(dados, titulo) {
  #predições
  p_simp <- as.numeric(predict(modelo_simples, dados, type = "response"))
  p_comp <- as.numeric(predict(modelo_completo, dados, type = "response"))
  
  
  df_simp <- data.frame(Y = dados$Y, P = p_simp, Modelo = "MI")
  df_comp <- data.frame(Y = dados$Y, P = p_comp, Modelo = "MAL")
  df_plot <- rbind(df_simp, df_comp)

  df_plot$faixa <- cut(df_plot$P, breaks = seq(0, 1, 0.1), include.lowest = TRUE)
  df_agg <- aggregate(cbind(Y, P) ~ faixa + Modelo, data = df_plot, FUN = mean)
  
  #gráfico
  ggplot(df_agg, aes(x = P, y = Y, color = Modelo, shape = Modelo)) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "gray40") +
    geom_line(linewidth = 1.2, alpha = 0.8) + 
    geom_point(size = 2.5) +
    scale_color_manual(values = c("MI" = "#d95f02", "MAL" = "#1b9e77")) +
    labs(title = titulo, x = "Probabilidade Predita", y = "Proporção Observada") +
    coord_cartesian(xlim = c(0, 1), ylim = c(0, 1)) + 
    theme_minimal() +
    theme(legend.position = "bottom",
          plot.title = element_text(size = 11, face = "bold"))
}

# gráficos para os três cenários
g_limpo <- plot_calibracao(teste_limpo, "Cenário: Limpo")
g_aleat <- plot_calibracao(teste_aleat, "Cenário: Aleatório")
g_sist  <- plot_calibracao(teste_sist,  "Cenário: Sistemático")

g_limpo + g_aleat + g_sist + plot_layout(ncol = 3, guides = "collect") & theme(legend.position = "bottom")

