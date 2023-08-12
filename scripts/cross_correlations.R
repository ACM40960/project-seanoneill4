#
# This script calculates the cross-corretion between temperature and CO2
# with a robust 95% confidence interval using the `testcorr` package.
#

# package for calculating cross-correlation with robust CI
library(testcorr)
library(ggplot2)

# import data
data <- read.csv("../data/processed/data_matched.csv")[1:65,] # matching years
temp <- data[["temp"]]
co2 <- data[["co2"]]
year <- data[["X"]] # 1958-2022

# import other data
other <- read.csv("../data/processed/other_data_matched.csv")
volcano <- other[["volcano"]]
irradiance <- other[["irradiance"]]
other_year <- other[["X"]] # 1958-2022

# perform differencing for stationarity
temp1 <- diff(temp)                     # 1959-2022 (1 year lost)
co21 <- diff(diff(co2))                 # 1960-2022 (1+1 years lost)
irradiance1 <- diff(irradiance, lag=11) # 1970-2022 (11 years lost)


# temperature and co2
cc1 <- cc.test(temp1[2:64], co21, max.lag=3)

plt1 <- ggplot() +
    theme_bw() +
    geom_bar(aes(x=cc1$lag, y=cc1$cc), stat="identity", width=0.25, fill="dodgerblue3") +
    geom_line(aes(x=cc1$lag, y=cc1$rcb[,1]), colour="firebrick2", linewidth=0.65, linetype=2) +
    geom_line(aes(x=cc1$lag, y=cc1$rcb[,2]), colour="firebrick2", linewidth=0.65, linetype=2) +
    ggtitle(expression("Temperature anomaly with CO"[2]*" concentration")) +
    xlab("lag") +
    ylab("cross-correlation") +
    theme(plot.title=element_text(hjust=0.5, size=14, face="bold"), 
          axis.title.x=element_text(size=13),
          axis.title.y=element_text(size=13),
          axis.text.x=element_text(size=11),
          axis.text.y=element_text(size=11),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank()) +
    scale_x_continuous(name="lag", breaks=c(-3,-2,-1,0,1,2,3)) +
    geom_hline(yintercept=0, linewidth=0.2) +
    scale_fill_brewer(palette="Dark2")

ggsave(filename="../data/images/corr_plot_1.png", plot=plt1, dpi=300,
       width=6, height=4)


# temperature and irradiance
cc2 <- cc.test(temp1[11:64], irradiance1, max.lag=3)

plt2 <- ggplot() +
    theme_bw() +
    geom_bar(aes(x=cc2$lag, y=cc2$cc), stat="identity", width=0.25, fill="dodgerblue3") +
    geom_line(aes(x=cc2$lag, y=cc2$rcb[,1]), colour="firebrick2", linewidth=0.65, linetype=2) +
    geom_line(aes(x=cc2$lag, y=cc2$rcb[,2]), colour="firebrick2", linewidth=0.65, linetype=2) +
    ggtitle(expression("Temperature anomaly with solar irradiance")) +
    xlab("lag") +
    ylab("cross-correlation") +
    theme(plot.title=element_text(hjust=0.5, size=14, face="bold"), 
          axis.title.x=element_text(size=13),
          axis.title.y=element_text(size=13),
          axis.text.x=element_text(size=11),
          axis.text.y=element_text(size=11),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank()) +
    scale_x_continuous(name="lag", breaks=c(-3,-2,-1,0,1,2,3)) +
    geom_hline(yintercept=0, linewidth=0.2) +
    scale_fill_brewer(palette="Dark2")

ggsave(filename="../data/images/corr_plot_2.png", plot=plt2, dpi=300,
       width=6, height=4)


# volcano and co2
cc3 <- cc.test(co21, volcano[3:65], max.lag=3)

plt3 <- ggplot() +
    theme_bw() +
    geom_bar(aes(x=cc3$lag, y=cc3$cc), stat="identity", width=0.25, fill="dodgerblue3") +
    geom_line(aes(x=cc3$lag, y=cc3$rcb[,1]), colour="firebrick2", linewidth=0.65, linetype=2) +
    geom_line(aes(x=cc3$lag, y=cc3$rcb[,2]), colour="firebrick2", linewidth=0.65, linetype=2) +
    ggtitle(expression("Volcanic activity with CO"[2]*" concentration")) +
    xlab("lag") +
    ylab("cross-correlation") +
    theme(plot.title=element_text(hjust=0.5, size=14, face="bold"), 
          axis.title.x=element_text(size=13),
          axis.title.y=element_text(size=13),
          axis.text.x=element_text(size=11),
          axis.text.y=element_text(size=11),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank()) +
    scale_x_continuous(name="lag", breaks=c(-3,-2,-1,0,1,2,3)) +
    geom_hline(yintercept=0, linewidth=0.2) +
    scale_fill_brewer(palette="Dark2")

ggsave(filename="../data/images/corr_plot_3.png", plot=plt3, dpi=300,
       width=6, height=4)
