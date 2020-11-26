ugrhis <- 1:22

sampling_points <- purrr::map_dfr(ugrhis, get_sampling_points)

usethis::use_data(sampling_points, overwrite = TRUE)

