# library(xml2)
library(magrittr)

# Login no sistema infoaguas  ------------------------

# Código para autenticar feito pelo Julio

u <- "https://sistemainfoaguas.cetesb.sp.gov.br"

# Primeiro precisamos obter o token
r <- httr::GET(u)

token <- r %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//*[@name='__RequestVerificationToken']") %>%
  xml2::xml_attr("value")

# Autenticar
body <- list(
  "Email" = "milz.bea@gmail.com",
  "Senha" = "PczpBVCTJrqDW",
  "X-Requested-With" = "XMLHttpRequest",
  "__RequestVerificationToken" = token
)

r_post <- httr::POST(u, body = body, encode = "form")

httr::content(r_post) # Result "ok" -> autenticação deu certo!




# Pesquisar ----------

r_pagina_inicial <-
  httr::GET(
    "https://sistemainfoaguas.cetesb.sp.gov.br/Home",
    httr::write_disk("R/pagina_inicial.html", overwrite = TRUE)
  )

r_aguas_superf <-
  httr::GET(
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais",
    httr::write_disk("R/aguas_superf.html", overwrite = TRUE)
  )

httr::content(r_monitoramento)

# AGORA FAZER UM POST

u_busca <- "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais"


body_busca <- list(

  "TipoConsulta" = "Monitoramento",
  "FiltroTipo" = "1",
  "NUGRHI" = "6",
  "X-Requested-With" = "XMLHttpRequest"

)


r_busca <- httr::POST(u_busca, body = body_busca, encode = "form")

httr::content(r_busca)


r_monitoramento <-
  httr::GET(
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/Monitoramento",
    httr::write_disk("R/monitoramento.html", overwrite = TRUE)
  )



tabela_pontos <-
  r_monitoramento %>%
  httr::content() %>%
  rvest::html_table() %>%
  purrr::pluck(1) %>%
  janitor::clean_names()  %>%
  tibble::as_tibble()



