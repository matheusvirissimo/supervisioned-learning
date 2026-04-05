# bibliotecas
library(dplyr)
library(pointblank)

# leitura dos dados
dados <- data("airquality")
head(dados, n = 5)

# Inspeção dos dados
str(dados)

# Resumo descritivo
library(summarytools)
dfSummary(dados)

# Contagem de NA's (ou NAN's)
sapply(dados, function(x) sum(is.na(x)))

# Agentes de validação
# no lint
agent <- create_agent(
    tbl = dados,
    label = "Validação de conjunto de dados 'airquality'"
) %>% # nolint - regras estruturais
    col_vals_not_null(
        colums = vars(Month),
        action = action_levels(warnt_at),
        brief = "Variável month/mês não deve conter NA ou NAN"
    ) %>% # nolint
    col_vals_between(
        columns = vars(Month),
        left = 5,
        right = 9,
        inclusive = c(TRUE, TRUE),
        action = action_levels(warn_at = 1, stop_at = 12),
        brief = "Variável não pode estar entre MAIO e SETEMBRO"
    ) # nolint inclua direito e esquerdo
col_vals_not_null(
    colums = vars(Day),
    action = action_levels(warnt_at),
    brief = "Variável month/mês não deve conter NA ou NAN"
) %>% # nolint
    col_vals_between(
        columns = vars(Day),
        left = 1,
        right = 31,
        inclusive = c(TRUE, TRUE),
        action = action_levels(warn_at = 1, stop_at = 31),
        brief = "Variável deve estar entre 1 e 31"
    ) %>%
    col_vals_gt(
        columns = vars(Wind),
        value = 0,
        action = action_levels(warn_at = 1, stop_at = 10),
        brief = ""
    ) %>%
    rows_complete(
        columns = vars(Solar.R),
        preconditions = ~ . %>% dplyr::filter(!is.na(Ozone)),
        action = action_levels(warn_at = 1, stop_at = 10),
        brief = "Se o Ozônio estiver preenchido, Solar.R também deve estar"
    )

# Executar validação dos dados
agent_validation <- interrogate(agent)
