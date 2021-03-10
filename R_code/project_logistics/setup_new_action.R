# R script to create folders for a project

fmp<-"Herring"
action<-"Framework7"

# Setup directories for R_code
dir.create(file.path(root,"R_code",fmp,action), recursive=TRUE)

# Setup directories for images
dir.create(file.path(root,"images",fmp,action), recursive=TRUE)

# Setup directories for raw_data
dir.create(file.path(root,"raw_data",fmp,action),  recursive=TRUE)

# Setup directories for stata_code
dir.create(file.path(root,"stata_code",fmp,action),  recursive=TRUE)

# Setup directories for tables
dir.create(file.path(root,"tables",fmp,action),  recursive=TRUE)
