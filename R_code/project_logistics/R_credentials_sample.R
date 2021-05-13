
id<-"<yourid>"
solepw<-"<yoursole_pwd>"
novapw<-"<yournova_pwd>"


# Assemble connection to SOLE

drv<-dbDriver("Oracle")
shost <- "<sole.full.path.to.server.gov>"
port <- port_number_here
ssid <- "<ssid_here>"

sole.connect.string<-paste(
  "(DESCRIPTION=",
  "(ADDRESS=(PROTOCOL=tcp)(HOST=", shost, ")(PORT=", port, "))",
  "(CONNECT_DATA=(SID=", ssid, ")))", sep="")
sole_conn<-dbConnect(drv, id, password=solepw, dbname=sole.connect.string)


# Assemble connection to NOVA

nhost <- "nova.full.path.to.server.gov"
port <- port_number_here
ssid2 <- "<nova"

nova.connect.string<-paste(
  "(DESCRIPTION=",
  "(ADDRESS=(PROTOCOL=tcp)(HOST=", nhost, ")(PORT=", port, "))",
  "(CONNECT_DATA=(SID=", ssid2, ")))", sep="")
nova_conn<-dbConnect(drv, id, password=novapw, dbname=nova.connect.string)

# IPs or paths to the network drives
network_location_desktop = "//999.999.999.9/"
network_location_server = "//net/"
