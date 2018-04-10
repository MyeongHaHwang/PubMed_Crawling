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


#install.packages("fst")
library(fst)
#install.packages("httr")
library(httr)
library(RCurl)
library(stringr)
library(XML)
library(plyr)

#define the ftp / extract the file names
ftp <- "ftp://ftp.ncbi.nlm.nih.gov/pubmed/baseline/"
ftp_files <- getURL(URLencode(ftp),dirlistonly=TRUE)
ftp_files

#split by "\r\n"
filenames <- str_split(ftp_files, "\r\n")[[1]]

#remove the particular character in list
grep(".md5",filenames) 
filenames[grep(".md5",filenames)]
filenames_xml <- Filter(function(x) !any(grepl(".md5",x)),filenames)
filenames_xml <- Filter(function(x) !any(grepl(".html",x)),filenames_xml)
#filenames_xml <- Filter(function(x) !any(grepl(".xml",x)),filenames_xml)
filenames_xml[1:20]

#defined the function
downloadFTP <- function(filename, folder, handle){
  dir.create(folder, showWarnings = FALSE)
  fileurl <- str_c(ftp, filename)
  if(!file.exists(str_c(folder, "/", filename))){
    content<-try(getURL(fileurl, curl = handle))
    write(content, str_c(folder, "/", filename))
    Sys.sleep(2)
    #Sys.sleep(1)
  }
}

handle_test <- getCurlHandle(ftp.use.epsv = FALSE)

#l_ply: Split List, Apply Function, And Discard Results.
l_ply(filenames_xml, downloadFTP,
      folder = "C:/R/XML_Crawling_test",
      handle = handle_test
      )

#====================================================================================
#Crawling Test for FTP Server

#install.packages("RCurl")
#install.packages("stringr")
#install.packages("XML")
#install.packages("plyr")
library(RCurl)
library(stringr)
library(XML)
library(plyr)
#Sys.getenv("R_LIBS_USER")
ftp <- "ftp://cran.r-project.org/pub/R/web/views/"
ftp_files <- getURL(ftp, dirlistonly = TRUE)
ftp_files

#extract the file's names
filenames <- str_split(ftp_files, "\r\n")[[1]] 
#extract the file including "html"
filenames_html <- unlist(str_extract_all(filenames, ".+(.html)"))
filenames_html[1:3]

#same method equal to upper codes
#filenames_html <- getURL(ftp, customrequest = "NLST *.html")
#filenames_html = str_split(filenames_html, "\\\r\\\n")[[1]]

downloadFTP <- function(filename, folder, handle){
  dir.create(folder, showWarnings = FALSE)
  fileurl <- str_c(ftp, filename)
  if(!file.exists(str_c(folder, "/", filename))){
    content<-try(getURL(fileurl, curl = handle))
    write(content, str_c(folder, "/", filename))
    Sys.sleep(1)
  }
}

handle <- getCurlHandle(ftp.use.epsv = FALSE)
l_ply(filenames_html, downloadFTP,
      folder = "C:/R/HTML_Crawling_test",
      handle = handle)
