sampling_points <- get_sampling_points()

usethis::use_data(sampling_points, overwrite = TRUE)

readr::write_csv2(sampling_points, "inst/tutorials/sampling_points.csv")

