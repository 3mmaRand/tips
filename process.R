
# DESCRIPTION -------------------------------------------------------------
# The project contains 6 files of larvae tracking data generated from imageJ
# The files are in the same format and contain the following columns:
# Track, Length, Distance,	#Frames,	1stFrame,	time(s),	MaxSpeed	
# AvgArea,	StdArea,	AvgPerim,	StdPerim,	AvgSpeed,	BLPS,	avgX,	avgX,	Bends,
# BBPS

# Note that avgX appears twice and the second will be renamed avgX_1 on import

# The file names encode the larvae type (EV or 343) and the concentration of 
# the treatment (P-coumpound)
# 343_1.txt
# 343_2.5.txt
# 343_0.txt
# ev_1.txt
# ev_2.5.txt     
# ev_0.txt


# Packages ----------------------------------------------------------------
library(tidyverse)



# Import ------------------------------------------------------------------

# get a vector of the file names
files <- list.files(path = "track", full.names = TRUE )

# import multiple data files into one dataframe
# using map_df() from purrr package
# clean the column names up using janitor::clean_names()
tracking <- files |> 
  set_names() |>
  map_dfr(read_table, .id = "file") |>
  janitor::clean_names()



# Process the file name column --------------------------------------------

# extract type and concentration from file name
# and put them into additopnal separate columns
tracking <- tracking |> 
  mutate(file = str_remove(file, ".txt")) |>
  mutate(file = str_remove(file, "track/")) |>
  extract(file, remove = 
            FALSE,
          into = c("type", "conc"), 
          regex = "([^_]{2,3})_(.+)") 


# Plot --------------------------------------------------------------------

# plot speed for each type and concentration
tracking |> 
  ggplot(aes(x = conc, y = length, color = type)) +
  geom_boxplot() 

