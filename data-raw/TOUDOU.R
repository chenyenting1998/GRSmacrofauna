#################################
### tou and dou data cleaning ###
#################################

# Description
# Selecting tou and dou

library(readxl)
library(dplyr)
library(devtools)
library(ggplot2)
library(usethat)
library(knitr)
library(roxygen2)

load_all()

# read data
dou <- read.csv("data-raw/GPSC_dou.csv")
tou <- read.csv("data-raw/GPSC_tou.csv")

# tou
tou$Cruise <- gsub("_", "-", tou$Cruise)
tou$Deployment <- as.character(tou$Deployment)
tou$Tube <- as.character(tou$Tube)
tou <-
  tou %>%
  filter(Cruise %in% c("OR1-1219", "OR1-1242")) %>%
  filter(!Station %in% c("GC1", "GS1")) %>%
  mutate(TOU = - In_situ_DO_flux) %>%
  select(Cruise, Station, Deployment, Tube, TOU)

ggplot(tou)+
  geom_bar(aes(x = Station, y = TOU, fill = Tube),
           stat = "identity",
           position = "dodge")+
  facet_wrap(~Cruise, scales = "free_x")+
  theme_bw()


# dou
dou$Cruise <- gsub("_", "-", dou$Cruise)
dou$Deployment <- as.character(dou$Deployment)
dou$Tube <- as.character(dou$Tube)

dou <-
  dou %>%
  filter(Cruise %in% c("OR1-1219", "OR1-1242")) %>%
  filter(!Station %in% c("GC1", "GS1")) %>%
  mutate(DOU = In_situ_Integrated_Prod / 1000000 * 10000 * 60 * 60 * 24) %>%
  #                                      mmol      m-2     day-1
  group_by(Cruise, Station, Deployment, Tube) %>%
  summarize(DOU = mean(abs(DOU)),
            OPD = mean(OPD/10000)) # um to cm

ggplot(dou)+
  geom_bar(aes(x = Station, y = DOU, fill = Tube),
          stat = "identity",
          position = "dodge")+
  facet_wrap(~Cruise, scales = "free_x")+
  theme_bw()

# merge tou and dou data
tou %>%
  left_join(dou) %>%
  mutate(BOU = TOU - DOU) %>%
  ggplot()+
  geom_bar(aes(x = Station, y = TOU, fill = Tube),
           stat = "identity",
           position = "dodge") +
  geom_point(aes(x = Station, y = DOU, fill = Tube),
           stat = "identity",
           position = "dodge") +
  facet_wrap(~Cruise, scale = "free_x") +
  theme_bw()

ou <-
  left_join(tou, dou) %>%
  mutate(BOU = TOU-DOU) %>%
  relocate(BOU, .after = DOU)
str(ou)

ou$Deployment <- as.double(ou$Deployment)
ou$Tube <- as.double(ou$Tube)
# output data
use_data(ou, overwrite = TRUE)
