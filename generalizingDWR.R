
getMonthly = 
function(station = "MRC", u = sprintf("http://cdec.water.ca.gov/cgi-progs/queryMonthly?%s", station))
{
    tt = readHTMLTable(u, encoding = "UTF8", stringsAsFactors = FALSE)
    tt = tt[[1]][ -1 , -c(2, 4, 6) ]  
    tt[ , 2:3] = lapply( tt[, 2:3], as.integer)
    names(tt) = gsub("&nbsp", "", names(tt))
    tt$Date = as.Date(sprintf("1/%s", tt$Date), "%d/%m/%Y")
    tt
}




mrc = getMonthly()
bear = getMonthly("BBS")




tt = readHTMLTable("http://cdec.water.ca.gov/cgi-progs/queryMonthly?BBS", which = 2, encoding = "UTF8", 
                    stringsAsFactors = FALSE,
                    colClasses = list("character", "character", "numeric", NULL, "numeric", NULL, "Percent"))




doc = htmlParse(txt, encoding = "UTF8")
a = getNodeSet(doc, "//pre/a")
stations = XML:::trim(sapply(a, function(x) xmlValue(getSibling(x))))
names(stations) = sapply(a, xmlValue)



##  
##  structure(XML:::trim(sapply(a, function(x) xmlValue(getSibling(x)))),  
##            names = sapply(a, xmlValue))



sapply(a, xmlValue)




sapply(a, function(x) 
            xmlValue(getSibling(x)))




txt = getForm("http://cdec.water.ca.gov/cgi-progs/staMeta", station_id = "A")




getMonthly =
function(station = "MRC", 
         u = sprintf("http://cdec.water.ca.gov/cgi-progs/queryMonthly?%s", station),
         doc = htmlParse(u, encoding = "UTF8"), ...)
{
    tt = readHTMLTable(doc, stringsAsFactors = FALSE, ...)
    if(length(tt) == 0)  # there were no tables in the page.
       return(list())

    tt = tt[[1]]  # assume it is the first one! But user can specify which =  via the ...
       # Discard the columns with no name
    tt = tt[ names(tt) != "" ]

       # clean away the &nbsp
    names(tt) = gsub("&nbsp", "", names(tt))

       # check to see if the first row is made up entirely of non-numbers
       # This won't work if the table has no number columns, but that's okay for now.
    if(all(grepl("^[()A-Za-z ]*$", XML:::trim(tt[1,]))))
       tt = tt[ -1 , ]
    
    convertCols(tt)
}




convertCols =
function(df)
{
  df[ ] = lapply(df, convertCol)
  df
}




convertCol =
function(col)
{
  miss = grepl("-{2,}", col)
  if(all(miss))
     return(as.integer(rep(NA, length(col))))
  col[miss] = NA

      # all the entries are missing or digits (or negative sign)
  if(all(is.na(col) | grepl("^[-0-9,]+$", col)))
     return(as(col, "FormattedInteger"))  

      # digits but . allowed also
  if(all(is.na(col) | grepl("^[-0-9,.]+$", col)))
     return(as(col, "FormattedNumber"))

   # Dates and times  
   #  month and year
  if(all(is.na(col) | grepl("^[0-9]{2}/[0-9]{4}$", col)))
     return(as.Date(sprintf("1/%s", col), "%d/%m/%Y"))

    # 07-JAN-2015
  if(all(is.na(col) | grepl("^[0-9]{2}-[A-Z]+-[0-9]{4}$", col)))
     return(as.Date(col, "%d-%b-%Y"))

    # date and time
  if(all(is.na(col) | grepl("^[0-9]{2}/[0-9]{2}/[0-9]{4} [0-9]{2}:[0-9]{2}$", col)))  
     return(as.POSIXct(strptime(col, "%m/%d/%Y %H:%M")))

  col
}




install.packages("devtools")
library(devtools)
install_github("duncant/DWR")
library(DWR)




mrc = getMonthly(u = "http://cdec.water.ca.gov/cgi-progs/queryMonthly?MRC")
head(mrc)

        Date MON FLO MON FNF
2 2014-07-01   64830    9975
3 2014-08-01   52840    5107
4 2014-09-01   34640    1723
5 2014-10-01   28780       0
6 2014-11-01   15112    3011
7 2014-12-01   15225   12645

sapply(mrc, class)

     Date   MON FLO   MON FNF 
   "Date" "integer" "integer" 





getMonthly(u = "http://cdec.water.ca.gov/cgi-progs/queryMonthly?BBS", which = 2)




getMonthly(u = "http://cdec.water.ca.gov/cgi-progs/queryF?SHA")




getMonthly(u = "http://cdec.water.ca.gov/cgi-progs/queryF?BBS")




o = getMonthly(u = "http://cdec.water.ca.gov/cgi-progs/stages/FNFSUM", colClasses = c("character", rep("FormattedInteger", 14)))




o = getMonthly(u = "http://cdec.water.ca.gov/cgi-progs/stages/FNFSUM")

