




get_results <- function(sampling_point, start, end) {

  `%>%` <- magrittr::`%>%`

  sampling_point <- 145
  start <- "01/01/2020"
  end <- "25/11/2020"
  u_busca <-
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/MonitoramentoModal"




  body_busca <- list(

      "DataInicial" = start,
      "DataFinal" = end ,
      "CodigoPonto[]" = sampling_point

  )


  r_busca <- httr::POST(u_busca, body = body_busca, encode = "form")

  httr::content(r_busca)


  r_monitoramento <-
    httr::GET(
      "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/MonitoramentoModal",
      httr::write_disk("inst/temp.html", overwrite = TRUE)
    )


  # # erro:
  # Valor não pode ser nulo.
  # Nome do parâmetro: source

}
