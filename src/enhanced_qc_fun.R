"%>%" = magrittr::`%>%`

point_plots_eqc <- function(xts_ts, title_plot = "title")
{
  
  data_ts <- zoo::fortify.zoo(xts_ts) %>% setNames(c("index", "value"))
  
  ggplot2::ggplot() + 
    ggplot2::geom_point(data = data_ts, ggplot2::aes(x = index, y = value), size = .1) +
    ggplot2::geom_rug(data = data_ts[!complete.cases(data_ts), ], ggplot2::aes(x = index), colour = "red", linewidth = 0.05, alpha = 0.1, shape = 1) + 
    ggplot2::xlab("") + 
    ggplot2::ylab("PRCP (mm)") + 
    ggplot2::ggtitle(title_plot) +
    ggplot2::scale_x_date(date_minor_breaks = "1 year") + 
    ggplot2::theme_bw() + 
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 90, hjust = 0.5), 
                   axis.title.x = ggplot2::element_blank(),
                   plot.title = ggplot2::element_text(hjust = 0.5),
                   legend.margin = ggplot2::margin(0,0,0,0),
                   legend.box.spacing = ggplot2::unit(0, "pt"))
}

point_plots_eqc_thld <- function(xts_ts, title_plot = "title", threshold = 5)
{
  
  data_ts <- zoo::fortify.zoo(xts_ts) %>% setNames(c("index", "value"))
  
  ggplot2::ggplot() + 
    ggplot2::geom_point(data = data_ts, ggplot2::aes(x = index, y = value), size = .1) +
    ggplot2::geom_rug(data = data_ts[!complete.cases(data_ts), ], ggplot2::aes(x = index), colour = "red", linewidth = 0.05, alpha = 0.1, shape = 1) + 
    ggplot2::xlab("") + 
    ggplot2::ylab("PRCP (mm)") +
    ggplot2::ggtitle(title_plot) +
    ggplot2::scale_x_date(date_minor_breaks = "1 year") +
    ggplot2::ylim(0, threshold) + 
    ggplot2::theme_bw() + 
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 90, hjust = 0.5), 
                   axis.title.x = ggplot2::element_blank(),
                   plot.title = ggplot2::element_text(hjust = 0.5),
                   legend.margin = ggplot2::margin(0,0,0,0),
                   legend.box.spacing = ggplot2::unit(0, "pt"))
}

get_dec_from_xts <- function(xts_obj)
{
  if(dim(xts_obj)[1] < 1){
    
    data.frame(year = NA,
               dec = NA) 
    
    
  } else {
    
    w = abs(xts_obj)
    w = as.integer((round(w, 1) -
                      as.integer(round(w, 1)))*10)
    
    out_df <- data.frame(year = format(time(xts_obj), "%Y") %>% as.numeric(),
                         dec = factor(w, levels = seq(9, 0, -1), labels = paste("x.", seq(9, 0, -1), sep = "")))
    
    out_df[complete.cases(out_df), ]
    
  }
}


decimal_plots_eqc <- function(xts_ts, title_plot = "title")
{
  
  rhg_cols <- rev(c("black", "yellow", "orange", "red", "darkslateblue", "darkgray", "magenta","blue", "cyan", "darkgreen"))
  
  ggplot2::ggplot() + 
    ggplot2::geom_bar(data = get_dec_from_xts(xts_ts), ggplot2::aes(x = year, fill = dec),  width=.8) + 
    ggplot2::scale_fill_manual(values = rhg_cols, drop = FALSE, " ",
                               guide = ggplot2::guide_legend(
                                 label.position = "top",
                                 nrow = 1,
                               )
    )+ 
    ggplot2::ylab("frequency (days/year)") + 
    ggplot2::xlab(" ") + 
    ggplot2::ggtitle(title_plot) +
    ggplot2::theme_bw() + 
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 90, hjust = 0.5), 
                   axis.title.x = ggplot2::element_blank(),
                   plot.title = ggplot2::element_text(hjust = 0.5),
                   legend.margin = ggplot2::margin(0,0,0,0),
                   legend.box.spacing = ggplot2::unit(0, "pt"),
                   legend.position = "bottom",
                   legend.box = "horizontal",
                   legend.spacing.x = ggplot2::unit(0, 'cm'))
}

get_eyear_from_xts <- function(xts_obj)
{
  if(dim(xts_obj)[1] < 1){
    
    data.frame(year = NA,
               dec = NA) 
    
    
  } else {
    
    out_df <- data.frame(value = as.numeric(xts_obj),
                         year = as.numeric(format(time(xts_obj), "%Y")))
    
    aggregate(value ~ year, data = out_df, function(x) sum(is.na(x)), na.action = NULL)
    
  }
}

missing_plot_eqc <- function(xts_ts, title_plot = "title"){
  
  ggplot2::ggplot() + 
    ggplot2::geom_bar(data = get_eyear_from_xts(xts_ts), 
                      ggplot2::aes(x = year, y = value), stat = "identity", colour = "black") + 
    ggplot2::geom_text(data = get_eyear_from_xts(xts_ts), 
                       ggplot2::aes(x = year, y = value, label = value), position = ggplot2::position_dodge(width=0.9), vjust = -0.25, size = 2) +
    ggplot2::ylab("missing values / year") + 
    ggplot2::xlab(" ") +
    ggplot2::ggtitle(title_plot) +
    ggplot2::theme_bw() + 
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 90, hjust = 0.5), 
                   axis.title.x = ggplot2::element_blank(),
                   legend.margin = ggplot2::margin(0,0,0,0),
                   legend.box.spacing = ggplot2::unit(0, "pt"),
                   plot.title = ggplot2::element_text(hjust = 0.5))
  
}

wd_fraction <- function(xts_obj)
{
  out_df <- data.frame(value = as.numeric(xts_obj), week = weekdays(time(xts_obj)))
  out_df_wd <- out_df[out_df$value >= 0.1, ]
  
  length_values <- aggregate(value ~ week, data = out_df, function(x) length(x[!is.na(x)]), na.action = NULL)
  
  if(all(is.na(out_df_wd$value))){
    lenght_wd <- length_values
  } else {
    lenght_wd <- aggregate(value ~ week, data = out_df_wd, function(x) length(x[!is.na(x)]), na.action = NULL)
  }
  
  out_df <- merge(length_values, lenght_wd, by = "week") %>% 
    setNames(c("week", "count", "count_wd")) %>%
    transform(week = factor(week, 
                            levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"),
                            labels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))) %>%
    transform(frac_wd = count_wd/count)
  
  if(is.nan(sum(out_df$frac_wd)) | is.na(sum(out_df$frac_wd))){ #all(is.nan(out_df$frac_wd))
    
    out_df$bin_test <- NA
    out_df$bin_test <- factor(out_df$bin_test, levels = c("Rejected Ho", "No Rejected Ho")) 
    
  } else {
    
    for(i in 1:nrow(out_df)){
      test_bt <- binom.test(out_df$count_wd[i], out_df$count[i],
                            p = sum(out_df$count_wd)/sum(out_df$count),
                            alternative = "two.sided",
                            conf.level = 0.95)
      
      out_df$bin_test[i] <- ifelse(!((test_bt$conf.int[1] < sum(out_df$count_wd)/sum(out_df$count)) & 
                                       (sum(out_df$count_wd)/sum(out_df$count) < test_bt$conf.int[2])), "Rejected Ho", "No Rejected Ho")
      
    }
    
    out_df$bin_test <- factor(out_df$bin_test, levels = c("Rejected Ho", "No Rejected Ho")) 
    
  }
  
  out_df
}

get_pweek_from_xts <- function(xts_obj){
  if(dim(xts_obj)[1] < 1){
    
    data.frame(year = NA,
               dec = NA)
  } else {
    
    wd_fraction(xts_obj)
    
  }
}

wd_plot_eqc <- function(xts_ts, title_plot = "title"){
  
  ggplot2::ggplot() + 
    ggplot2::geom_bar(data = get_pweek_from_xts(xts_ts),
                      ggplot2::aes(x = week, y = frac_wd, fill = bin_test), stat = "identity", colour = NA, width = 0.25) +
    ggplot2::geom_text(data = get_pweek_from_xts(xts_ts), 
                       ggplot2::aes(x = week, y = frac_wd, label = count), position = ggplot2::position_dodge(width=0.9), vjust = -0.25) + 
    ggplot2::geom_hline(yintercept = sum(get_pweek_from_xts(xts_ts)$count_wd)/sum(get_pweek_from_xts(xts_ts)$count), color = "gray10", linetype = "dashed") +
    ggplot2::scale_fill_manual("Binomial Test:", values = c("red", "gray20"), labels = c("WD fraction outside the 95% CI", "WD fraction inside the 95% CI"), drop = FALSE) + 
    ggplot2::ylab("WD fraction (PRCP >= 1 mm)") +
    ggplot2::xlab(" ") + 
    ggplot2::ggtitle(title_plot) +
    ggplot2::ylim(0, sum(get_pweek_from_xts(xts_ts)$count_wd)/sum(get_pweek_from_xts(xts_ts)$count) + 0.05) +
    ggplot2::theme_bw() + 
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 90, hjust = 0.5), 
                   axis.title.x = ggplot2::element_blank(),
                   plot.title = ggplot2::element_text(hjust = 0.5),
                   legend.margin = ggplot2::margin(0,0,0,0),
                   legend.box.spacing = ggplot2::unit(0, "pt"),
                   legend.position = "bottom", 
                   legend.direction = "horizontal")
  
}

get_pweek_pyear_from_xts <- function(xts_obj)
{
  if(dim(xts_obj)[1] < 1){
    
    data.frame(year = NA,
               dec = NA)
  } else {
    
    nyears <- unique(format(time(xts_obj), "%Y"))
    lapply(nyears, function(z){
      
      data.frame(wd_fraction(xts::xts(xts_obj)[z]), year = as.numeric(z))
      
    }) %>% do.call("rbind", .)  
    
  }
}

wd_pyear_plot_eqc <- function(xts_ts, title_plot = "title"){
  
  data_ts <- get_pweek_pyear_from_xts(xts_ts) %>% .[complete.cases(.), ]
  
  ggplot2::ggplot() + 
    ggplot2::geom_point(data = data_ts,
                        ggplot2::aes(x = year, y = week, colour = bin_test), size = 2) + 
    ggplot2::geom_rug(data = data_ts[data_ts$bin_test == "Rejected Ho", ],
                      ggplot2::aes(x = year), colour = "red", linewidth = 1, alpha = 1, shape = 1) +
    ggplot2::scale_colour_manual("Binomial Test:", values = c("red", "gray20"), labels = c("WD fraction outside the 95% CI", "WD fraction inside the 95% CI"), drop = FALSE) + 
    ggplot2::ylab("WD fraction (PRCP >= 1 mm)") + 
    ggplot2::xlab(" ") + 
    ggplot2::ggtitle(title_plot) +
    ggplot2::theme_bw() + 
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 90, hjust = 0.5), 
                   axis.title.x = ggplot2::element_blank(),
                   plot.title = ggplot2::element_text(hjust = 0.5),
                   legend.margin = ggplot2::margin(0,0,0,0),
                   legend.box.spacing = ggplot2::unit(0, "pt"),
                   legend.position = "bottom", 
                   legend.direction = "horizontal")
  
}