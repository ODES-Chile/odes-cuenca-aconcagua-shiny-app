# packages ----------------------------------------------------------------
# SHINY
library(shiny)
library(leaflet)
library(leaflet.providers)
library(highcharter) # remotes::install_github("jbkunst/highcharter")
library(shinyWidgets)
library(bslib)

# DATA
library(tidyverse)
library(sf)

# OTHERS
library(cli)

cli::cli_h1("Start global.R")


# data --------------------------------------------------------------------
# Leer datos bd_clusterizado.csv
data <- read.csv("data/bd_clusterizado.csv", sep = ",", header = TRUE) %>%
  rename(cod_comuna = cut_com) |>
  as_tibble()

# leer shape de comunas
dgeo <- st_read("data/Comunas/comunas.shp")
dgeo

# filtrar de comunas solo las que estan en la region de valparaiso
dgeo <- dgeo[dgeo$Region == "Región de Valparaíso",]

# options -----------------------------------------------------------------
parametros <- list(
  color = "#236478",
  font_family = "Raleway",
  font_family_code = "Source Code Pro"
  )

theme_odes <-  bs_theme(
  version = 5,
  primary = parametros$color,
  base_font = font_google(parametros$font_family),
  code_font = font_google(parametros$font_family_code)
)


# options -----------------------------------------------------------------
opt_variables <- c(
  "Índice Vulnerabilidad Económica y Social" = "ives",
  "Edad" = "edad",
  "Experiencia" = "experiencia",
  "Dificultad por sequia ponderada" = "dificultad_por_sequia_pond"
  )


# end ---------------------------------------------------------------------
cli::cli_h1("End global.R")
