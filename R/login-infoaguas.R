#' Fun\u00e7\u00e3o para autenticar no Sistema Infoaguas da CETESB
#'
#' @param login
#' @param password
#'
#' @return
#' @export
#'
#' @examples
login_infoaguas <- function(login, password) {

  u <- "https://sistemainfoaguas.cetesb.sp.gov.br"

  # Primeiro precisamos obter o token
  r <- httr::GET(u)

  token <- r %>%
    xml2::read_html() %>%
    xml2::xml_find_first("//*[@name='__RequestVerificationToken']") %>%
    xml2::xml_attr("value")

  # Autenticar
  body <- list(
    "Email" = login,
    "Senha" = password,
    "X-Requested-With" = "XMLHttpRequest",
    "__RequestVerificationToken" = token
  )

  r_post <- httr::POST(u, body = body, encode = "form")

  resposta <-
    httr::content(r_post) %>% purrr::pluck("result") # Result "ok" -> autentica\u00e7\u00e3o deu certo!

  if (resposta == "Ok") {
    message("A autentica\u00e7\u00e3o no Sistema Infoaguas foi realizada.")
  } else if (resposta == "Erro") {
    stop("A autentica\u00e7\u00e3o no Sistema Infoaguas n\u00e3o foi realizada.
         Verifique se o email e senha informados est\u00e3o corretos.")
  }

}

