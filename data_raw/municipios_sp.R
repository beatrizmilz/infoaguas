r_municipios_sp <-
  geobr::read_municipality("SP")

municipios_sp <- r_municipios_sp %>%
  sf::st_drop_geometry() %>%
  dplyr::select(code_muni, name_muni) %>%
  tibble::as_tibble() %>%
  dplyr::mutate(muni = stringr::str_to_upper(name_muni),
                muni = abjutils::rm_accent(muni),
                muni = stringr::str_replace_all(muni, "-", " "),
                muni = stringr::str_replace_all(muni,  "'", " "),
                muni = dplyr::case_when(muni == "MOJI MIRIM" ~
                                          "MOGI MIRIM",
                                        TRUE ~ muni))


usethis::use_data(municipios_sp, overwrite = TRUE)
