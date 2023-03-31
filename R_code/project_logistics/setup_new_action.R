# R script to create folders for a project

fmp<-"Herring"
action<-"Framework9"

library(here)
here::i_am("R_code/project_logistics/setup_new_action.R")

# Setup directories for R_code
dir.create(here("R_code",fmp,action), recursive=TRUE)

# Setup directories for images
dir.create(here("images",fmp,action), recursive=TRUE)

# Setup directories for raw_data
dir.create(here("raw_data",fmp,action),  recursive=TRUE)

# Setup directories for raw_data
dir.create(here("input_data",fmp,action),  recursive=TRUE)

# Setup directories for geotiffs
dir.create(here("geotiffs",fmp,action),  recursive=TRUE)

# Setup directories for stata_code
dir.create(here("stata_code",fmp,action),  recursive=TRUE)

# Setup directories for tables
dir.create(here("tables",fmp,action),  recursive=TRUE)
