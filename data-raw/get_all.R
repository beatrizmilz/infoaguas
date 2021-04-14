maybe_get_results_progresso <- function(points, path, prog) {
  if (!missing(prog))
    prog()

  maybe_get_results <-
    purrr::possibly(get_results, otherwise = "Erro")


  maybe_get_results(points, path)
}

get_all_results <-  function(points, path) {
  # coloca o script no contexto
  progressr::with_progress({
    # cria a barra de progresso
    p <- progressr::progressor(length(points))

    purrr::walk(points,
                maybe_get_results_progresso,
                path = path,
                prog = p)


  })
}



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

  codigos_faltantes <- arquivos_faltantes$cod_interaguas


  get_all_results(codigos_faltantes, "inst/download/")
}


# Depois de baixar todos, criar um df único

dados_infoaguas <- tidy_infoaguas("inst/download/")

write.csv2(dados_infoaguas, "inst/tutorials/trabalho_final/dados_infoaguas.csv")

#usethis::use_data(dados_infoaguas, overwrite = TRUE)
