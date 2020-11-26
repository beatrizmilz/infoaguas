#' Função para obter a tabela de pontos por ugrhi
#'
#' @param n_ugrhi
#'
#' @return
#' @export
#'
#' @examples get_sampling_points(6)
get_sampling_points <- function(n_ugrhi) {
  `%>%` <- magrittr::`%>%`


  u_busca <-
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais"


  body_busca <- list(
    "TipoConsulta" = "Monitoramento",
    "FiltroTipo" = "1",
    "NUGRHI" = n_ugrhi,
    "X-Requested-With" = "XMLHttpRequest"

  )


  r_busca <- httr::POST(u_busca, body = body_busca, encode = "form")

  # httr::content(r_busca)


  r_monitoramento <-
    httr::GET(
      "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/Monitoramento")


  id_ponto <- r_monitoramento %>%
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
    tibble::add_column(id_ponto) %>%
    dplyr::select(-x) %>%
    dplyr::mutate(data_inicio = readr::parse_date(data_inicio, format = "%d/%m/%Y"),
                  data_fim = as.character(data_fim),
                  data_fim = readr::parse_date(data_fim, format = "%d/%m/%Y"),
                  n_ugrhi = n_ugrhi,
                  muni = abjutils::rm_accent(municipio),
                  muni = stringr::str_replace_all(muni, "-", " "),
                  muni = dplyr::case_when(muni == "SANTANA DO PARNAIBA" ~
                                            "SANTANA DE PARNAIBA",
                                          muni == "QUEIROS" ~ "QUEIROZ",
                                          TRUE ~ muni))

 join_code_muni <- tabela_pontos %>% dplyr::left_join(municipios_sp, by = "muni") %>% dplyr::select(-muni)


 join_code_muni


}
