# Title     : TODO
# Objective : TODO
# Created by: stem
# Created on: 22.09.2020


library(tidyverse)
library(lubridate)
library(purrr)
library(readxl)
#
#knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE)
#
#df <- readxl::read_excel("data/untidy_cashflow.xlsx", range = "E8:J11")
#
#tidy_df <- df %>%
#  pivot_longer(- År, values_to = "value", names_to = "year") %>%
#  rename(type = År) %>% # Endre til fornuftige navn på kolonnene
#  mutate(year = as.integer(year)) # Endre til fornuftige type på variablene.


df <- readRDS("data/bysykkeldata.Rds")

