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
      "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/Monitoramento"
    )

  tabela_pontos <-
    r_monitoramento %>%
    httr::content() %>%
    rvest::html_table() %>%
    purrr::pluck(1) %>%
    janitor::clean_names()  %>%
    tibble::as_tibble() %>%
    dplyr::select(-x) %>%
    dplyr::mutate(data_inicio = readr::parse_date(data_inicio, format = "%d/%m/%Y"),
                  data_fim = as.character(data_fim),
                  data_fim = readr::parse_date(data_fim, format = "%d/%m/%Y"),
                  n_ugrhi = n_ugrhi)

  tabela_pontos
}
