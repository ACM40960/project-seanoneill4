#required libraries
library(rstan)
library(HDInterval)
library(ggplot2)

#read in and generate required data
tempco2 <- read.csv("../data/TempCO2_COMBINED.csv")
temp <- tempco2[, 1]
co2 <- tempco2[, 2]

years <-  1959:2023
new_years <-  1959:2100
y0 <- c(temp[1], co2[1])
t0 <- 1958
temp <- temp[-1]
co2 <- co2[-1]

#data required by stan
data <- list(N = length(temp), years = years, co2 = co2,
             temp = temp, y0 = y0, t0 = t0, new_years = new_years, 
             L = length(new_years))

#run the stan script
fit <- stan("ode.stan", data = data, iter = 8000)

#extract the mean co2 and temp anomaly sampled distributions from model
mu <- extract(fit)$mu
theta <- extract(fit)$theta

#calculate mean of samples for plotting
means <- colMeans(mu)

#quick plot of data and model
plot(years, means[, 1], type = "l", col = "red",)
points(years, temp, type = "l")

#extract the output of the model
mod <- extract(fit)$model_output

#get smooth 95% credible intervals
smooth_lower_hdi_temp <- ksmooth(new_years, hdi(mod[,,1])[1,], x.points = new_years, 
                                 bandwidth = 4)$y
smooth_upper_hdi_temp <- ksmooth(new_years, hdi(mod[,,1])[2,], x.points = new_years, 
                                 bandwidth = 4)$y

smooth_lower_hdi_co2 <- ksmooth(new_years, hdi(mod[,,2])[1,], x.points = new_years, 
                                 bandwidth = 2)$y
smooth_upper_hdi_co2 <- ksmooth(new_years, hdi(mod[,,2])[2,], x.points = new_years, 
                                 bandwidth = 2)$y

#plot the model with the confidence intervals
tempplot <- ggplot() +  #temperature anomaly
  geom_line(mapping = aes(x = new_years, y = colMeans(mod[,,1]), fill = "Model", color = "Model"), lwd = 1) +
  geom_line(mapping = aes(x = years, y = temp, fill = "Data", color = "Data"), lwd = 0.8) +
  geom_ribbon(mapping = aes(x = new_years, ymin = smooth_lower_hdi_temp, 
                            ymax = smooth_upper_hdi_temp, fill = "95% Cred. Int.", color = "95% Cred. Int.")) + 
  theme_classic() +
  ggtitle("Simple predictive model of temperature drift over time") +
  ylab("temperature anomaly (°C)") + xlab("Year") +
  theme(plot.title = element_text(hjust = 0.5))  +
  scale_color_manual(name = "",
                     breaks = c("Model", "Data", "95% Cred. Int."),
                     values = c("Model"="black", "Data"="red", "95% Cred. Int."=adjustcolor("orange", 0.35)),
                     guide = guide_legend(override.aes = aes(col = NA))) +
  scale_fill_manual(name = "",
                    breaks = c("Model", "Data", "95% Cred. Int."),
                    values = c("Model"="black", "Data"="red", "95% Cred. Int."=adjustcolor("orange", 0.35))) +
  theme(legend.position = c(0.15, 0.95), text = element_text(size = 20))

co2plot <- ggplot() + #CO2 levels
  geom_line(mapping = aes(x = new_years, y = colMeans(mod[,,2]), fill = "Model", color = "Model"), lwd = 1) +
  geom_line(mapping = aes(x = years, y = co2, fill = "Data", color = "Data"), lwd = 1) +
  geom_ribbon(mapping = aes(x = new_years, ymin = smooth_lower_hdi_co2, 
                            ymax = smooth_upper_hdi_co2,
                            fill = "95% Cred. Int.", color = "95% Cred. Int.")) +
  theme_classic() +
  ggtitle(expression("Simple predictive model of CO"[2]*" over time")) +
  ylab(expression("CO"[2]*" concentration (ppm)")) + xlab("Year") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_color_manual(name = "",
                     breaks = c("Model", "Data", "95% Cred. Int."),
                     values = c("Model"="black", "Data"="blue", "95% Cred. Int."=adjustcolor("darkgreen", 0.25)),
                     guide = guide_legend(override.aes = aes(col = NA))) +
  scale_fill_manual(name = "",
                    breaks = c("Model", "Data", "95% Cred. Int."),
                    values = c("Model"="black", "Data"="blue", "95% Cred. Int."=adjustcolor("darkgreen", 0.25))) +
  theme(legend.position = c(0.15, 0.95), text = element_text(size = 20))

#save images
ggsave("../data/images/TempModelImage.jpg", plot = tempplot, device = "jpeg",
       width = 12, height = 8, dpi = 300)
ggsave("../data/images/CO2ModelImage.jpg", plot = co2plot, device = "jpeg",
       width = 12, height = 8, dpi = 300)
