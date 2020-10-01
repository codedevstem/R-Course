# Title     : TODO
# Objective : TODO
# Created by: stem
# Created on: 24.09.2020

library(tidyverse)
library(lubridate)
library(purrr)
library(readxl)

df_raw <- read_rds("data/bysykkeldata.Rds")

# Clean data
# Remove trips to service stations
# Remove trips that start and end same place
df <- df_raw %>%
  filter(!(end_station_name %in% c("workshop", "UIP"))) %>%
  filter(duration < 3600) %>%
  filter(start_station_name != end_station_name)

# Add variables
# Merk: geosphere er egen pakke, last ned på forhånd med install.packages("geosphere")
df <- df %>%
  mutate(duration_minutes = duration %/% 60,
         month = month(started_at),
         wday = factor(wday(started_at)),
         time_of_day_started = hour(started_at),
         distance_trip = round(geosphere::distCosine(cbind(start_station_longitude, start_station_latitude),
                                            cbind(end_station_longitude, end_station_latitude))))
# smaller dataset containing only trips started at the most popular station
df_mdp <- df %>%
  filter(start_station_name == "Møllendalsplass")

df_1_1 <- df_mdp %>%
  mutate(average_speed_kph = (distance_trip / duration) * 3.6)

df_1_2 <- df_mdp %>%
  group_by(start_station_name, end_station_name) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  head(10)

df_1_3 <- df_mdp %>%
  group_by(start_station_name, end_station_name) %>%
  select() %>%
  pivot_longer(1:2, names_to = "type", values_to = "stops") %>%
  group_by(stops) %>%
  summarise("number_of_visits" = n())
  head(10)

df_rain_raw <- read.csv("data/rain.csv")

df_filtered <- df %>%
  mutate(date = date(started_at)) %>%
  filter(date > as_date("2018-07-01"))

df_rain_mutate <- df_rain_raw %>%
  mutate(date = date(date))

df_1_4 <- df_filtered %>%
  left_join(df_rain_mutate, "date") %>%
  mutate(rain_category = case_when(
    rain == 0 ~ "Ingen regn",
    rain < 5 ~ "Litt regn",
    rain > 5 ~ "Mye regn",
  ))

df_1_5 <- df_1_4 %>%
  group_by(rain_category) %>%
  summarise(average = mean(duration))

## CLEANING








