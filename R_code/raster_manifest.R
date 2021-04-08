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
  
  fl$STATE = sapply(fl$STRIPGRID, USE.NAMES=F, function(zz) {
    temp = do.call(rbind,strsplit(as.character(zz), split = "/"))
    return(temp[(NCOL(temp)-2)]) })
  
  table(fl$YEAR)

  message("
  The cross-tab looked like this on April 8, 2021.  Yours should look similar.
        1996  1997  1998  1999  2000  2001  2002  2003  2004  2005  2006  2007  2008  2009  2010  2011  2012  2013  2014  2015  2016  2017  2018  2019
  CN       0     0     0     0     4     1     0     0     0     0     0     1     0     0     0     0     0     0     2     0     0     0     0     0
  CT    2222  2132  2381  2152  2533  2820  2825  2516  2532  2631  2492  2308  2127  1954  1990  1844  2095  1590  1354  1507  1529  1243  1227  1124
  DE     142   104    98    82    75   202   113   153   134   175   187   103   171   132    73    74    75    76    82    82   105   114    73   102
  FL       0     1     0     0     0     0     0     0     1     0     0     0     2     0     0     0     0     0     0     0     0     0     0     0
  GA       0     0     0     0     0     2     0     3     0     0     0     0     0     0     0     1     0     0     0     0     0     0     0     0
  MA   42581 38977 39421 38499 44414 47471 43992 41860 39668 40357 41156 38163 36351 36493 37234 35211 37570 31726 31702 30449 34054 32738 33288 31137
  MD    1690  1615  1281  1123  1393  1123  1037  1554  1703  2756  3860  2789  2767  2821  1986  1678  1419  1126  1326  1425  1232   988   973  1133
  ME   25413 22809 20776 21100 26057 25924 22202 23741 22483 22559 21189 18667 18602 18088 19622 16273 15170 13708 13018 12380 12235 12563 11802 10729
  NA       0     0     0     2     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0    38     0     0     8     0
  NC    1018  1116  1670  1835  2501  2920  2670  2041  2074  1235  1551  1655  1513  1563  1755  1890  1446  1328  1542  1607  1647  1881  1617  1370
  NH    5130  4333  4354  4373  5942  6921  6155  5459  5560  5191  5003  5207  4891  5087  4453  4585  4704  4251  3979  3662  3737  3715  3578  3323
  NJ    7648  8014  9995  9880 11273 12692 12172 15174 17002 20534 19295 19844 17611 16877 13838 14946 13409 11942 11607 11585 12958 11370 10805 10333
  NY    8495  9165  9999 10022 13273 12620 15593 19589 21537 20832 22284 23749 11632 12116 11135 10872 10406  9776  8818  7959  9381  8782  7574  7386
  OTHR     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0  2599
  PA       0     0     0     0     0     0     0     4     0     0     0     0     0     0     0     0     3     0     0     0     0     0     0     0
  RI   11846 12656 13443 12863 12230 12760 12616 11631 11673 12153 13038 12773 11885 11210 11401 10864 10366 11057 10815 10106 11077 10938 10068  9470
  SC       3     4     6     4     2    13     2     6     2     0     0     0     1     0     1     2     8     3     0     0     0     0     0     0
  VA    1363  1611  2544  3333  3612  3573  4081  4363  5174  6226  5662  3286  3183  3021  3171  3884  3149  3059  2716  2766  2762  2394  2119  2213 ")
  
  
  table(fl$STATE, fl$YEAR)
  
