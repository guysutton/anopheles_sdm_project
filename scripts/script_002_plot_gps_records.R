
# Get map of Africa to to use as base layer
ext <- rnaturalearth::ne_countries(scale = "medium",
                                       returnclass = "sf") %>%
  dplyr::filter(continent == "Africa")

# Convert Africa map to a 'terra::spatVect' object
ext <- terra::vect(ext)
class(ext)
terra::plot(ext)

# Set the CRS projection for Africa base map
# - Use the correct wkt CRS format - no more PROJ4 strings! 
terra::crs(ext) <- "epsg:4326"
terra::crs(ext, describe = T)

# Convert GPS points into a 'terra::spatVect' object
gps_pts <- df_raw %>%
  dplyr::mutate(
    dplyr::across(
      .cols = ano_gambiae:ano_paludis,
      ~ as.factor(.x)
    )
  ) %>%
  # Convert all the '1' scores into "Yes"
  dplyr::mutate(
    dplyr::across(
      .cols = ano_gambiae:ano_paludis,
      ~ dplyr::if_else(.x == "1", "Yes", "No")
    )
  ) %>%
  # Convert data to long-format
  tidyr::pivot_longer(
    cols = dplyr::contains("ano_"),
    names_to = "species",
    values_to = "present"
  ) %>%
  # Subset data to plot different species
  dplyr::filter(species %in% c("ano_gambiae")) %>%
  terra::vect(
    ., 
    geom = c("lon", "lat"), 
    crs = "", 
    keepgeom = TRUE
    )
head(gps_pts)
class(gps_pts)

# Set the CRS projection for the GPS points
# - Use the correct wkt CRS format - no more PROJ4 strings! 
terra::crs(gps_pts) <- "epsg:4326"
terra::crs(gps_pts, describe = T)

# Plot GPS records 
ggplot() +
  # Plot Africa base layer
  geom_spatvector(data = ext, fill = NA) +
  # Plot Africa base layer
  geom_spatvector(data = gps_pts, aes(colour = present)) +
  # Control axis and legend labels 
  labs(
    x = "Longitude",
    y = "Latitude",
    colour = "Recorded"
  ) +
  # Crops map to just the geographic extent of Australia
  coord_sf(
    xlim = c(-20, 55),
    ylim = c(-37.5, 40),
    crs = 4326,
    expand = FALSE
  ) + 
  # Add a facet for GPS presences vs absences
  facet_wrap(~ present, nrow = 1) + 
  theme(legend.position = "right")
