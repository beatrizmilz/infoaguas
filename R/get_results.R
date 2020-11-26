get_results <- function(sampling_point, start, end) {
  `%>%` <- magrittr::`%>%`


  n_ugrhi <- 6
  sampling_point <- 106
  start <- "01/01/2020"
  end <- "25/11/2020"


  u_busca <-
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais"


  body_busca <- list(
    "TipoConsulta" = "Monitoramento",
    "FiltroTipo" = "1",
    "NUGRHI" = n_ugrhi,
    "X-Requested-With" = "XMLHttpRequest"

  )


  r_busca <- httr::POST(u_busca, body = body_busca, encode = "form")


  u_busca <-
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/MonitoramentoModal"




  body_busca <- list(
    "DataInicial" = start,
    "DataFinal" = end ,
    "CodigoPonto[]" = sampling_point

  )


  r_busca <- httr::POST(
    u_busca,
 #   query = list(method = "pesquisar"),
    body = body_busca,
    encode = "form"#,
  #  httr::accept("xlsx")
  )

  httr::content(r_busca)




  r_monitoramento <-
    httr::GET(
      "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/MonitoramentoModal",
      httr::write_disk("inst/temp.html", overwrite = TRUE)
    )


  # Até aqui: o html pede para fazer a busca pela data (mas já fiz....) (?)

}
