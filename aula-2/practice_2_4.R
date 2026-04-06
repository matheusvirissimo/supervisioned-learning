## OBJETIVO
# simular dados com erro de medição e comparar um modelo ingênuo vs um modelo
# que reconhece o erro para ver como isso afeta a qualidade das previsões

## FUNÇÃO: P(Y = 1 | X*) = plogis(alpha + beta * X_train)

##  Configurações Iniciais --------------------------- ##
# CONSTANTES - podem ser escolhidas aleatoriamente,
# desde que sejam fixas

set.seed(123)             # Semente

n_train         <- 700   # Tamanho do conjunto de treino (70%)
n_test          <- 300   # Tamanho do conjunto de teste (30%)

alpha           <-  -0.5   # Intercepto (modelo gerador)
beta            <-  1.2   # Efeito do biomarcador (modelo gerador)
sigma           <-  1.0   # Desvio-padrão do biomarcador (variância constante = 1) #nolint
sigma_2         <-  sigma^2  # Variância

a               <- 0.5  # Parâmetro do erro uniforme (o erro varia entre uma faixa) #nolint
delta           <-  1   # Erro sistemático (balança sempre pesa 1kg a mais)

##  Geração dos Dados Simulados ------------------------- ##

## X* (verdadeiro) #nolint
X_clean_train    <- rnorm(n_train, mean = 0, sd = sigma)
X_clean_test     <- rnorm(n_test,  mean = 0, sd = sigma)

## Erro U -> unif(-a, a) e diferentes (evitar correlação artificial)
U1               <- runif(n_train, min = -a, max = a)
U2               <- runif(n_train, min = -a, max = a)

## X* + U -> X com erro uniforme
X_U_train        <- X_clean_train + U1
X_U_test         <- X_clean_train + U1

## X* + U + delta -> erro sistemático
X_U_delta_train  <- X_clean_train + U2 + delta
X_U_delta_test   <- X_clean_test + U2 + delta

## Desfecho binário (modelo logístico)

p_train         <- plogis(alpha + beta * X_clean_train)
p_test          <- plogis(alpha + beta * X_clean_test)

Y_train         <- rbinom(n_train, size = 1, prob = p_train)
Y_test          <- rbinom(n_test,  size = 1, prob = p_test)


## Resumo descritivo do biomarcador por laboratório (conjunto de treino)
cat("===== Criação dos cenários ======\n\n", 
    "I - Cenário limpo\n\n",
    paste("",capture.output(summary(X_clean_train)), collapse = "\n"),
    "\n\n\n",
    "II - Cenário com erro UNIFORME\n\n",
    paste("",capture.output(summary(X_U_train)), collapse = "\n"),
    "\n\n\n",
    "III - Cenário com erro UNIFORME e SISTEMÁTICO\n\n",
    paste("",capture.output(summary(X_U_delta_train)), collapse = "\n")
)

# 1 - Ajuste de dois modelos
## Modelo simples - ignora o erro de mdeição
## Modelo completo - usa X + variações que indicam o tipo da medição

# 2 - Avaliação em diferentes cenários
## Cenário limpo
## Cenário com erro aleatório
## Cenário com erro sistemático persistente

