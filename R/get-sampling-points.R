#' Fun\u00e7\u00e3o para obter a tabela de pontos de monitoramneto
#' @return
#' @export
#'
#' @examples
get_sampling_points <- function() {


  u_busca <-
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais"


  body_busca <- list(
    "TipoConsulta" = "Monitoramento",
    "FiltroTipo" = "0",
    "X-Requested-With" = "XMLHttpRequest"

  )


  r_busca <- httr::POST(u_busca, body = body_busca, encode = "form")

  # httr::content(r_busca)


  r_monitoramento <-
    httr::GET(
      "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/Monitoramento")



  teste_autenticacao <- r_monitoramento %>%
    xml2::read_html() %>%
    xml2::xml_find_first("//*[@name='__RequestVerificationToken']") %>%
    xml2::xml_attr("name")

  if (is.na(teste_autenticacao)) {
    cod_interaguas  <- r_monitoramento %>%
      xml2::read_html() %>%
      xml2::xml_find_first("//table//tbody") %>%
      xml2::xml_find_all("//input") %>%
      xml2::xml_attr("value")


    tabela_pontos <-
      r_monitoramento %>%
      httr::content() %>%
      rvest::html_table() %>%
      purrr::pluck(1) %>%
      janitor::clean_names()  %>%
      tibble::as_tibble() %>%
      tibble::add_column(cod_interaguas) %>%
      dplyr::select(-x) %>%
      dplyr::mutate(
        data_inicio = readr::parse_date(data_inicio, format = "%d/%m/%Y"),
        data_fim = as.character(data_fim),
        data_fim = readr::parse_date(data_fim, format = "%d/%m/%Y"),
        muni = abjutils::rm_accent(municipio),
        muni = stringr::str_replace_all(muni, "-", " "),
        muni = dplyr::case_when(
          muni == "SANTANA DO PARNAIBA" ~
            "SANTANA DE PARNAIBA",
          muni == "QUEIROS" ~ "QUEIROZ",
          TRUE ~ muni
        )
      )

    join_code_muni <-  tabela_pontos %>%
      dplyr::left_join(infoaguas::municipios_sp, by = "muni") %>%
      dplyr::select(-muni) %>%
      dplyr::mutate(code_muni = as.character(code_muni))


    join_code_muni

  } else {
    stop(
      "Voc\u00ea precisa realizar a autentica\u00e7\u00e3o antes de utilizar essa fun\u00e7\u00e3o.
         Utilize a seguinte fun\u00e7\u00e3o, informando seu email e senha cadastrados no sistema Infoaguas:
         login_infoaguas(login = .... , password = ....)

         Caso n\u00e3o tenha realizado o cadastro, \u00e9 poss\u00edvel realizar neste site:
         https://sistemainfoaguas.cetesb.sp.gov.br/Login/Index"
    )
  }


}
