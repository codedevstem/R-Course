# Title     : TODO
# Objective : TODO
# Created by: stem
# Created on: 22.09.2020

library(tidyverse)
library(lubridate)
library(purrr)
library(readxl)


knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE)


df <- readRDS("data/bysykkeldata.Rds")

df %>%
  head()

filtered_df <- df %>%
  filter(!(end_station_name %in% c("workshop", "UIP"))
           & duration > 3600)

dates_only <- df %>%
  select(started_at, ended_at)

mutated_df <- df %>%
  mutate(duration_minutes = duration %% 60,
         month_started = month(started_at),
         wday_started = wday(started_at),
         hour_started = hour(started_at),
         weekend_trip = wday_started > 5)

grouped_df <- df %>%
  mutate(day_started = wday(started_at)) %>%
  group_by(day_started) %>%
  summarise(number_of_trips = sum(day_started))

arranged <- df %>%
  group_by(end_station_name) %>%
  summarise(snitt_duration = mean(duration)) %>%
  arrange(-snitt_duration)

df_mdp <- df %>%
  filter(start_station_name == "Møllendalsplass")

df_mdp %>%
  ggplot(aes(x = distance_trip, y = duration_minutes)) +
  geom_point()

ggplot(data = df_mdp, aes(x = 'duration', y = 'distance_trip')) +
  geom_jitter()

