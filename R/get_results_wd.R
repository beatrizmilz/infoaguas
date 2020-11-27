# # tentando get_results() com webdriver
# library(webdriver)
# library(magrittr)
#
# `%>%` <- magrittr::`%>%`
#
# pjs <- webdriver::run_phantomjs()
#
# ses <- webdriver::Session$new(port = pjs$port)
#
# u_busca <-
#   "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais"
#
#
# ses$go(u_busca)
# ses$takeScreenshot()
#
# # Autenticar T_T
#
# escrever_email <- ses$findElements(xpath = '//*[@id="Email"]')
# escrever_email$moveMouseTo()
# escrever_email$takeScreenshot()
# escrever_email


