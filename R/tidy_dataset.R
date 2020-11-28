

raw_dataset <- list.files(path, full.names = TRUE) %>% purrr::map_dfr(. , .f = readxl::read_xlsx)
