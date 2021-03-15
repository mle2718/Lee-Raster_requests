# R script to create folders for a project

fmp<-"Herring"
action<-"Framework7"

# Setup directories for R_code
dir.create(file.path("R_code",fmp,action), recursive=TRUE)

# Setup directories for images
dir.create(file.path("images",fmp,action), recursive=TRUE)

# Setup directories for raw_data
dir.create(file.path("raw_data",fmp,action),  recursive=TRUE)

# Setup directories for raw_data
dir.create(file.path("input_data",fmp,action),  recursive=TRUE)

# Setup directories for geotiffs
dir.create(file.path("geotiffs",fmp,action),  recursive=TRUE)

# Setup directories for stata_code
dir.create(file.path("stata_code",fmp,action),  recursive=TRUE)

# Setup directories for tables
dir.create(file.path("tables",fmp,action),  recursive=TRUE)
