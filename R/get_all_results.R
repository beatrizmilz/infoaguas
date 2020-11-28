maybe_get_results <-
  purrr::possibly(get_results, otherwise = "Erro")


maybe_get_results_progresso <- function(points, path, prog) {
  if (!missing(prog))
    prog()
  maybe_get_results(points, path)
}



#' Title
#'
#' @param points
#' @param path
#'
#' @return
#' @export
#'
#' @examples
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
