get_all_results <- function(vetor_pontos, path_download) {
  future::plan(future::multisession)

  #progressr::with_progress({
    hoje <- format(Sys.Date(), "%d-%m-%Y")


    inicial <- paste0("01-01-", c(seq(
      from = 1974, to = 2020, by = 5
    )))


    final <-
      c(paste0("31-12-", c(seq(
        from = 1979, to = 2020, by = 5
      ) - 1)),
      hoje)


    for (i in 1:length(inicial)) {
      inicial_busca <- inicial[i]
      final_busca <- final[i]

      furrr::future_map(
        .x = vetor_pontos,
        .f = get_results,
        start = inicial_busca,
        end = final_busca,
        path = path_download
      )

      Sys.sleep(1)

    }
   #p()


  #})


}
