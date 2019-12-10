# Set de diretorio
setwd("/home/rennisHD01/Projetos/R/rennis-r/utils")

# Formatação de valores para R$ - Reais
formataReal <- function(values, nsmall = 0) {
  values %>%
    as.numeric() %>%
    format(nsmall = nsmall, decimal.mark = ",", big.mark = ".") %>%
    str_trim() %>%
    str_c("R$ ", .)
}
