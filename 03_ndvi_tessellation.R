setwd("/home/marc/Documents/imatges_bcn")
library(terra)
library(stars)
library(tidyverse)
library(sf)
library(tmap)

# read bcn shape
bcn <- st_read("./0301100100_UNITATS_ADM_POLIGONS.json")

bcn <- st_transform(bcn, "EPSG:25831")
barris <- bcn |> 
  filter(TIPUS_UA == "BARRI")

# read raster

bcn_normalitzat <- stars::read_stars("./raster_normalitzat.tiff")

# crop raster
bcn_normalitzat_crop <- st_crop(bcn_normalitzat, barris)

# rescale

bcn_normalitzat_crop_nvdi <- st_apply(bcn_normalitzat_crop, 1, \(x) ((x-100)/100))

tmap::tm_shape(terra::rast(bcn_normalitzat_crop_nvdi)[[1]]) + 
  tm_raster(palette = "RdYlGn",
            breaks = c(-1,0,0.2,0.4,0.6,1),
            labels = c("Aigua, cobertes artificials, etc.", 
                       "Sòl nu i/o vegetació morta",
                       "Vegetació dispersa i/o poc vigorosa",
                       "Vegetació abundant i/o vigorosa",
                       "Vegetació molt densa i molt vigorosa"),
            title = "Índex de Vegetació de Diferència Normalitzada") + 
  tm_shape(barris) + 
  tm_borders()

# Read tessellation w/ and w/o differences

tes_buildings <- st_read("tessellation_limit.geojson")
tes_nobuildings <- st_read("tessellation_nobuilding_limit.geojson")

# get average nvdi per tessella outside buildings
mitjana_per_tessella <- aggregate(bcn_normalitzat_crop_nvdi, tes_nobuildings, FUN = mean) |> 
  st_as_sf() |> 
  rename("nvdi" = "raster_normalitzat.tiff.V1") |> 
  select("nvdi", "geometry")

# join values to full map

tes_buildings$nvdi <- mitjana_per_tessella$nvdi

tm_shape(tes_buildings) + 
  tm_polygons(col = "nvdi",
              palette = "RdYlGn",
              breaks = c(-1, 0, 0.2, 0.4, 0.6, 1),
              labels = c("Aigua, cobertes artificials, etc.", 
                         "Sòl nu i/o vegetació morta",
                         "Vegetació dispersa i/o poc vigorosa",
                         "Vegetació abundant i/o vigorosa",
                         "Vegetació molt densa i molt vigorosa"),
              title = "Índex de Vegetació de Diferència Normalitzada",
              lwd = 0.1)