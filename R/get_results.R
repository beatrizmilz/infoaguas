get_results <- function(sampling_point, start, end, path) {
  `%>%` <- magrittr::`%>%`

  u_busca <-
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais"


  res <- httr::GET(u_busca)


  body_busca <- list(
    "TipoConsulta" = "Monitoramento",
    "FiltroTipo" = "0",
    "X-Requested-With" = "XMLHttpRequest"

  )


  r_busca <-
    httr::POST(u_busca, body = body_busca, encode = "form")


  u_busca <-
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/MonitoramentoModal"




  body_busca <- list(
    "DataInicial" = start,
    "DataFinal" = end ,
    "CodigoPonto[]" = sampling_point

  )


  r_busca <- httr::POST(u_busca,
                        body = body_busca,
                        encode = "form")

  httr::content(r_busca)


  start_2 <- stringr::str_replace_all(start, "/", "-")

  end_2 <- stringr::str_replace_all(end, "/", "-")

  arquivo <-
    glue::glue("{path}infoaguas_{sampling_point}_start-{start_2}_end-{end_2}.xlsx")

  r_monitoramento <-
    httr::GET(
      "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/Download",
      httr::write_disk(arquivo, overwrite = TRUE)
    )
  message(glue::glue("O arquivo foi baixado e pode ser encontrado em:
                     {arquivo}"))

}
