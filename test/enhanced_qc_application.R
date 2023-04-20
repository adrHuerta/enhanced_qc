rm(list = ls())

source("src/enhanced_qc_fun.R")

# example for a single time serie
time_serie <- read.csv("data/time_serie_example.csv")
time_serie <- xts::xts(time_serie[,2], as.Date(time_serie[,1]))

# point plots
p1 <- point_plots_eqc(xts_ts = time_serie, title_plot = "point plots")
p1

# point plots threshold
p2 <- point_plots_eqc_thld(xts_ts = time_serie, title_plot = "point plots threshold (threshold = 5 mm)")
p2

# decimal plots
p3 <- decimal_plots_eqc(xts_ts = time_serie, title_plot = "decimal plots")
p3

# missing values plots
p4 <- missing_plot_eqc(xts_ts = time_serie, title_plot = "missing values plots")
p4

# weekly precipitation cycles
p5 <- wd_plot_eqc(xts_ts = time_serie, title_plot = "weekly precipitation cycles")
p5

# weekly precipitation cycles by year
p6 <- wd_pyear_plot_eqc(xts_ts = time_serie, title_plot = "weekly precipitation cycles by year")
p6

cowplot::plot_grid(p1, p2, p3, p4, p5, p6, ncol = 2)
ggplot2::ggsave("enhanced_qc_by_R.png", width = 15, height = 10, dpi = 300)
