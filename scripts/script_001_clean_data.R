# Script 001: Import and clean raw GPS data 

# -----------------------------------------------------------------------------
# Session setup
# -----------------------------------------------------------------------------

# Load required packages
if (!require("pacman"))
  install.packages("pacman")
pacman::p_load(
  tidyverse,
  tidyr,
  NicheMapR,
  terra,
  tidyterra
)

# Install and load 'NicheMapR' from GitHub
# # Have to install the NicheMapR data to your PC
# - Default directory is C:/global_climate/
# - Remove # below to download data
# - Only needs to be run once, not each session
# devtools::install_github('mrke/NicheMapR')
# NicheMapR::get.global.climate()

# -----------------------------------------------------------------------------
# Data import and basic cleaning 
# -----------------------------------------------------------------------------

# Import raw .csv file 
df_raw <- readr::read_csv(
  file = here::here("./data/data_raw/Africa Vectors database_1898-2016.csv")
  ) %>%
  # Clean column headers 
  janitor::clean_names() %>%
  # Convert all the 'Y' scores into a 1
  dplyr::mutate(
    dplyr::across(
      .cols = an_gambiae_complex:an_paludis,
      ~ dplyr::if_else(.x == "Y", 1, 0)
      )
    ) %>%
  # Replace NA with 0
  dplyr::mutate(
    dplyr::across(
      .cols = an_gambiae_complex:an_paludis,
      ~ tidyr::replace_na(.x, 0))) %>%
  # Keep only necessary columns (and rename, where needed)
  dplyr::select(
    country, 
    lat, 
    lon = long,
    ano_gambiae = an_gambiae_complex,
    ano_arabiensis = an_arabiensis,
    ano_melas = an_melas,
    ano_merus = an_merus,
    ano_bwambae = an_bwambae,
    ano_funestus = an_funestus_s_l,
    ano_leesoni = an_leesoni,
    ano_rivulorum = an_rivulorum,
    ano_parensis = an_parensis,
    ano_vaneedeni = an_vaneedeni,
    ano_nili = an_nili_s_l,
    ano_moucheti = an_moucheti_s_l,
    ano_pharoensis = an_pharoensis,
    ano_hancocki = an_hancocki,
    ano_mascarensis = an_mascarensis,
    ano_marshalli = an_marshalli,
    ano_squamous = an_squamous,
    ano_wellcomei = an_wellcomei,
    ano_rufipes = an_rufipes,
    ano_coustani = an_coustani_s_l,
    ano_paludis = an_paludis
  ) %>%
  # Remove rows with NA lat or lon
  tidyr::drop_na(
    lat,
    lon
  )
head(df_raw)
