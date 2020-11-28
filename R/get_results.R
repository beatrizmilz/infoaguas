get_results <- function(sampling_point, start, end, path) {
  `%>%` <- magrittr::`%>%`

  data_inicio_ponto <-
    sampling_points %>%
    dplyr::filter(cod_interaguas == sampling_point) %>%
    dplyr::pull(data_inicio)

  continuar <-
    lubridate::as_date(data_inicio_ponto) < lubridate::as_date(start, format = "%d-%m-%Y")

  if (continuar == FALSE) {
    message(
      glue::glue(
        "Arquivo não baixado, referente ao ponto {sampling_point} nos períodos {inicial_busca} a {final_busca}.
              Não há dados disponíveis para este período.
              "
      )
    )
  } else {
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

    resposta <- httr::content(r_busca) %>% xml2::xml_text()

    if (resposta == "success") {
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
    } else {
      message(
        glue::glue(
          "Arquivo não baixado, referente ao ponto {sampling_point} nos períodos {start} a {end}."
        )
      )
    }

  }















}
