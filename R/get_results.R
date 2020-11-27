get_results <- function(sampling_point, start, end) {
  `%>%` <- magrittr::`%>%`


  # n_ugrhi <- 6
  sampling_point <- 106
  start <- "01/01/2020"
  end <- "25/11/2020"


  u_busca <-
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais"


  res <- httr::GET(u_busca)

  cookies <- httr::cookies(res)$value %>%
    purrr::set_names(httr::cookies(res)$name)


  body_busca <- list(
    "TipoConsulta" = "Monitoramento",
    "FiltroTipo" = "0",
    "X-Requested-With" = "XMLHttpRequest"

  )


  r_busca <- httr::POST(u_busca, body = body_busca, encode = "form",  httr::set_cookies(cookies))


  u_busca <-
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/MonitoramentoModal"




  body_busca <- list(
    "DataInicial" = start,
    "DataFinal" = end ,
    "CodigoPonto[]" = sampling_point

  )


  r_busca <- httr::POST(u_busca,
                        #   query = list(method = "pesquisar"),
                        body = body_busca,
                        encode = "form"#,

                        #  httr::accept("xlsx")
                        ,
                        httr::set_cookies(cookies))



  r_monitoramento <-
    httr::GET(
      "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/MonitoramentoModal",
      httr::write_disk("inst/temp.html", overwrite = TRUE)
    )


  # Até aqui: o html pede para fazer a busca pela data (mas já fiz....) (?)


}
