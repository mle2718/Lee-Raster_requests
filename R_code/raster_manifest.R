#Rscript to save the full raster manifest to an Rds. If you are doing lots of operations on the individual rasters, this will save a little time.

todaysdate = as.Date(Sys.time())

desktopUse = ifelse(unname(Sys.info()["sysname"]) == "Windows", TRUE, FALSE)

if (desktopUse) { # set the root path of the network, based on whether on desktop or server
  network_location = "//155.206.139.2/"
  system("ipconfig", intern = TRUE)
} else {
  network_location = "//net/"
}
raster_folder = file.path(network_location,"work5/socialsci/Geret_Rasters/Data/individualrasters")
output_f = file.path(network_location,"/home2/mlee/READ-SSB-Lee-Raster_requests/raw_data")

message("Creating output folder if it doesnt exist..")
dir.create(file.path(output_f), showWarnings=T)
stopifnot(file.exists(output_f))
message("Done.")


  # detect number of cores and output warning
  if (parallel::detectCores() > 90 ) {
    message("Using Venus server. Allocating 30 cores..")
    max.nodes = 30  # Set to 12 when working on Server?
  } else {
    warning("Possibly using desktop or Mars server with fewer cores, it's recommened to use the Venus server
            when running this function. Allocating 8 cores..", immediate. = TRUE, call. = FALSE)
    max.nodes = 8
    desktopUse = TRUE
  }



  # set local/changable variables
  # TODO: use flat files on desktop computer to save time and change things for Windows instead of Linux
  message("Compiling list of rasters ..")
  filelist = lapply(as.list(list.dirs(path=raster_folder, recursive=F)), list.files, recursive=T, full.names=T, pattern="*.gri")

  message("Finished.")
  # Create one single-column dataframe with all elements in form of the filepath, but R recgonizes it only as text
  # Dataframe with ~1.8 million records (comercial only)
  message("Compiling filepaths of rasters ..")
  #The following create new dataframe fields for IDnum and year..
  fl = do.call(rbind, lapply(filelist, function(xx) {
    xx = as.data.frame(xx, stringsAsFactors=F)
    names(xx) = "FILEPATH"
    return(xx) }) )

  #fl = paste(sd,"individualrasters","MA","2013","70766.grd",sep="/")
  #fl = as.data.frame(fl)
  names(fl) <- "FILEPATH"

  fl$STRIPGRID =  sapply(fl$FILEPATH, USE.NAMES=F, function(zz) {
    strsplit(x = as.character(zz), split = ".gri")[[1]]
  })
  fl$IDNUM = sapply(fl$STRIPGRID, USE.NAMES=F, function(zz) {
    temp = do.call(rbind,strsplit(as.character(zz), split = "/"))
    return(temp[NCOL(temp)]) })

  fl$YEAR = sapply(fl$STRIPGRID, USE.NAMES=F, function(zz) {
    temp = do.call(rbind,strsplit(as.character(zz), split = "/"))
    return(temp[(NCOL(temp)-1)]) })

  saveRDS(fl, file = file.path(output_f,paste0("raster_manifest_",todaysdate,".Rds")))
  
  table(fl$YEAR)
message("Finished. ")

