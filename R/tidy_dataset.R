#' Title
#'
#' @param path
#'
#' @return
#' @export
#'
#' @examples
tidy_infoaguas <- function(path) {
  raw_dataset <-
    list.files(path, full.names = TRUE, pattern = "*.xlsx") %>%
    purrr::map_dfr(. , .f = readxl::read_xlsx)

  suppressWarnings({


    tidy_dataset <- raw_dataset %>%
      janitor::clean_names() %>%
      dplyr::mutate(
        dplyr::across(
          .cols = c(
            periodo_de,
            periodo_ate,
            data_coleta,
            inicio_operacao,
            fim_operacao
          ),
          .fns = lubridate::dmy
        ),
        hora_coleta = lubridate::hm(hora_coleta),
        valor_numerico = readr::parse_double(valor, locale = readr::locale(decimal_mark = ",")),
        valor_texto = dplyr::case_when(
          parametro %in% c(
            "Ens. Ecotoxic. C/ Ceriodaphnia dubia",
            "Coloração",
            "Chuvas nas últimas 24h",
            "Indução de Micronúcleos"
          ) ~ valor,

          TRUE ~ NA_character_
        ),
        altitude = as.double(altitude)
      ) %>%
      dplyr::relocate(c(valor_numerico, valor_texto), .after = valor)

  })


  tidy_dataset
}
