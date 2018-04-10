#Web Crawling for FTP of PubMed

library(curl)
library(plyr)

### Base URL
url.base = "ftp://ftp.ncbi.nlm.nih.gov/pubmed/updatefiles/"

### Get file list
con = curl(url.base, "r", new_handle(dirlistonly = TRUE))
file.list = read.table(con, stringsAsFactors=FALSE, fill=TRUE)[[1]]
close(con)

### Get .xml.gz files
file.list <- sort(file.list[grepl(".xml.gz$", file.list)])
#file.list <- sort(file.list[grepl(".html", file.list)])

### Download all .xml.gz files
download <- function(file.name){
  url  <- paste0(url.base, file.name)
  #path <- paste0("download/", file.name)
  path <- paste0("C:/R/XML_Crawling_test/", file.name)
  curl_fetch_disk(url, path)
}
l_ply(file.list, download)

#===============================================================
