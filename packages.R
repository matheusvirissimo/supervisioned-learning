install.packages("languageserver")
install.packages(c("fs","roxygen2","stringi","pkgload","stringr"))
installed.packages()["languageserver",]
find.package("languageserver")


.libPaths()


# Pacotes usado em aula
install.packages("tidyverse", dependencies = TRUE)

# pacote para validação de dados (incluindo inconsistências)
install.packages("pointblank", dependencies = TRUE)
find.package("pointblank")

# Sumarização dos dados 
install.packages("summarytools", dependencies = TRUE)
find.package("summarytools")

install.packages("arrow", type = "binary")

# para arrumar identação 
install.packages("styler")

# Para limpeza de dados
install.packages("janitor")

# ========================
install.packages("nycflights13")
