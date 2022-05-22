library(feedeR)
library(sf) 
library(fs)
library(tidyverse)
library(lubridate)
library(classInt)
library(tmap)
library(rvest)
setwd("/home/marc/Documents/imatges_bcn")
# data downloaded using this method https://dominicroye.github.io/es/2019/visualizar-el-crecimiento-urbano/

url <- "http://www.catastro.minhap.es/INSPIRE/buildings/ES.SDGC.bu.atom.xml"

# importing rss
prov_enlaces <- feed.extract(url)
str(prov_enlaces) #estructura es lista

# extract table with links
prov_enlaces_tab <- as_tibble(prov_enlaces$items) %>% 
  mutate(title = repair_encoding(title))

# get rss url for BCN province
val_atom <- filter(prov_enlaces_tab, str_detect(title, "Barcelona")) %>% pull(link)

# import rss
val_enlaces <- feed.extract(val_atom)

# get table with links
val_enlaces_tab <- val_enlaces$items

# filter for city name
val_link <- filter(val_enlaces_tab, str_detect(title, "BARCELONA")) %>% pull(link)
val_link

# DOWNLOAD FILE
temp <- tempfile()
download.file(URLencode(val_link), temp)
unzip(temp, exdir = "buildings_bcn")

# read file
file_bcn <- dir_ls("buildings_bcn", regexp = "building.gml")

buildings <- st_read(file_bcn)

# check crs

bcn <- st_read("0301100100_UNITATS_ADM_POLIGONS.json")

bcn <- bcn |> filter(CONJ_DESCR == "Terme Municipal")

# filtrar per àrea <50 m2

buildings <- filter(buildings, as.numeric(st_area(geometry))>50)

buildings <- st_make_valid(buildings)

# unir polígons que es toquen
parts <- st_cast(st_union(buildings),"POLYGON")


parts <- st_sf(parts)

parts_f <- parts |> 
  rename("geometry" = "parts") |> 
  st_make_valid()

parts_f$uid <- seq_along(1:nrow(parts))

st_write(parts_f, "./parts_edificis.geojson")
