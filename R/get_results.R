#' Title
#'
#' @param sampling_point
#' @param path
#'
#' @return
#' @export
#'
#' @examples
get_results <- function(sampling_point, path) {

    data_inicio_ponto <-
    infoaguas::sampling_points %>%
    dplyr::filter(cod_interaguas == sampling_point) %>%
    dplyr::pull(data_inicio) %>%
    format("%d-%m-%Y")

  # ponto_mais_antigo <- sampling_points %>%
  #   dplyr::arrange(data_inicio) %>%
  #   dplyr::slice(1) %>%
  #   dplyr::pull(data_inicio)

  if(is.na(data_inicio_ponto)){data_inicio_ponto <- "01-01-1974"}



  data_final <- format(Sys.Date(), "%d-%m-%Y")


  u_busca <-
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/MonitoramentoModal"

  body_busca <- list(
    "DataInicial" = data_inicio_ponto,
    "DataFinal" = data_final,
    "CodigoPonto[]" = sampling_point

  )


  r_busca <- httr::POST(u_busca,
                        body = body_busca,
                        encode = "form")

  resposta <- httr::content(r_busca) %>% xml2::xml_text()

  start_2 <- stringr::str_replace_all(data_inicio_ponto , "/", "-")

  end_2 <- stringr::str_replace_all(data_final, "/", "-")

  arquivo <-
    glue::glue("{path}infoaguas_{sampling_point}_start-{start_2}_end-{end_2}.xlsx")

  if (file.exists(arquivo)) {
    message(
      glue::glue(
        "Arquivo não baixado, referente ao ponto {sampling_point} nos períodos {start_2} a {end_2},
        pois o arquivo correspondente já existe no diretório."
      )
    )

  } else if (resposta == "success") {
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
        "Arquivo não baixado, referente ao ponto {sampling_point} nos períodos {start_2} a {end_2}."
      )
    )
  }

}
