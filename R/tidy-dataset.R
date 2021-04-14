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
            "Colora\u00e7\u00e3o",
            "Chuvas nas \u00faltimas 24h",
            "Indu\u00e7\u00e3o de Micron\u00facleos"
          ) ~ as.character(valor),

          TRUE ~ NA_character_
        ),
        altitude = as.double(altitude)
      ) %>%
      dplyr::relocate(c(valor_numerico, valor_texto), .after = valor) %>%
      tidyr::separate(latitude, into = c("lat_graus", "lat_min", "lat_sec"), sep = " ", remove = FALSE) %>%
      tidyr::separate(longitude, into = c("long_graus", "long_min", "long_sec"), sep = " ", remove = FALSE) %>%
      dplyr::mutate(dplyr::across(.cols = tidyselect::starts_with(c("lat_", "long_")), as.double),
                    latitude_decimal = biogeo::dms2dd(dd = lat_graus, mm = lat_min, ss = lat_sec, ns = "S"),
                    longitude_decimal = biogeo::dms2dd(dd = long_graus, mm = long_min, ss = long_sec, ns = "W")) %>%
      dplyr::select(-tidyselect::starts_with(c("lat_", "long_")))

  })


  tidy_dataset
}
