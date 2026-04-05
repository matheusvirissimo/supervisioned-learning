## OBJETIVO
# simular dados com erro de medição e comparar um modelo ingênuo vs um modelo que reconhece o erro, #nolint
# para ver como isso afeta a qualidade das previsões

## FUNÇÃO: P(Y = 1 | X*) = plogis(alpha + beta * X_train)

## ------------------------- Importação das Bibliotecas ------------------------- ##

library(ggplot2)
library(patchwork)

## --------------------------- Configurações Iniciais --------------------------- ##

set.seed(123)             # Semente

n_train         <- 1000   # Tamanho do conjunto de treino
n_test          <- 1000   # Tamanho do conjunto de teste

alpha           <- -0.5   # Intercepto (modelo gerador)
beta            <-  1.2   # Efeito do biomarcador (modelo gerador)
sigma           <-  1.0   # Desvio-padrão do biomarcador

delta           <-  0.7   # Erro sistemático de calibração no Lab B

## ------------------------ Geração dos Dados Simulados ------------------------- ##

## Biomarcador (X^ast)

X_train_true    <- rnorm(n_train, mean = 0, sd = sigma)
X_test_true     <- rnorm(n_test,  mean = 0, sd = sigma)

## Desfecho binário (modelo logístico)

p_train         <- plogis(alpha + beta * X_train_true)
p_test          <- plogis(alpha + beta * X_test_true)

Y_train         <- rbinom(n_train, size = 1, prob = p_train)
Y_test          <- rbinom(n_test,  size = 1, prob = p_test)

## Definição do Laboratório (0 = Laboratório A, 1 = Laboratório B)

lab_train       <- rbinom(n_train, size = 1, prob = 0.5)

## Erro sistemático de calibração: deslocamento constante aplicado ao Lab B

X_train_obs     <- X_train_true + ifelse(lab_train == 1, delta, 0)

## Resumo descritivo do biomarcador por laboratório (conjunto de treino)

cat(" # --------------------------------------------------------- #\n",
    "# Resumo Descritivo do Biomarcador (X) (Conjunto de Treino) #\n",
    "# --------------------------------------------------------- #\n\n",
  
    "Laboratório A (lab_train = 0)\n\n",
    "n = ", sum(lab_train == 0), "\n\n",
    paste("",capture.output(summary(X_train_obs[lab_train == 0])), collapse = "\n"),
    "\n\n\n",
  
    "Laboratório B (lab_train = 1)\n\n",
    "n = ", sum(lab_train == 1), "\n\n",
    paste("",capture.output(summary(X_train_obs[lab_train == 1])), collapse = "\n"),
    "\n"
)

# 1 - Ajuste de dois modelos
## Modelo simples - ignora o erro de mdeição
## Modelo completo - usa X + variações que indicam o tipo da medição

# 2 - Teste em cenários
## Cenário limpo
## Cenário com erro aleatório
## Cenário com erro sistemático persistente

