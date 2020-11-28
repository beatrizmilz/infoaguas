# Primeira rodada de download dos arquivos!
todos_codigos <- unique(sampling_points$cod_interaguas)

get_all_results(todos_codigos, "inst/download/")


# Depois, bora checar se falta algum?
# Tem um ponto que não baixa nem manualmente : SDOM04600

while(length(todos_codigos) > length(arquivos_baixados) + 1){
  path <- "inst/download/"

  arquivos_baixados <- list.files(path, full.names = TRUE)

  codigos_baixados <- arquivos_baixados  %>%
    stringr::str_extract(., "_\\d+_") %>%
    stringr::str_remove_all(., "_") %>%
    tibble::as_tibble()


  arquivos_faltantes <- sampling_points %>%
    dplyr::anti_join(codigos_baixados , by = c("cod_interaguas" = "value"))

  # View(arquivos_faltantes)

  codigos_faltantes <- arquivos_faltantes$cod_interaguas


  get_all_results(codigos_faltantes, "inst/download/")
}

