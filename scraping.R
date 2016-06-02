
library(XML)




install.packages("XML")




library(XML)




u = "http://cdec.water.ca.gov/cgi-progs/queryMonthly?MRC"
tt = readHTMLTable(u)
class(tt)
length(tt)
str(tt)




tt = readHTMLTable(u, encoding = "UTF8", stringsAsFactors = FALSE)

tt[[1]]
      Date  MON FLO&nbsp   MON FNF&nbsp 
1                     AF             AF 
2  07/2014         64830 r         9975 
3  08/2014         52840 r         5107 
4  09/2014         34640 r         1723 
5  10/2014         28780              0 
6  11/2014         15112           3011 
7  12/2014         15225          12645 
8  01/2015         14890 e         6543 
9  02/2015          2116          24628 
10 03/2015         12817          19548 
11 04/2015         14321          29879 
12 05/2015         14240          42386 
13 06/2015         15346          20700 
14 07/2015         26732          10891 
15 08/2015         13404           3422 
16 09/2015          7591           1446 
17 10/2015         18262            731 
18 11/2015         14995          13344 
19 12/2015         15612          38100 
20 01/2016         15493          67684 
21 02/2016         14202          58817 
22 03/2016         14743         170074 
23 04/2016         28352         172816 
24 05/2016            --             -- 
25 06/2016            --             -- 





dim(tt[[1]])

[1] 25  6





names(tt[[1]])

[1] "Date"         ""             "MON FLO&nbsp" ""             "MON FNF&nbsp" ""            





tt = tt[[1]][, -c(2, 4, 6) ]  
head(tt)

     Date MON FLO&nbsp MON FNF&nbsp
1                   AF           AF
2 07/2014        64830         9975
3 08/2014        52840         5107
4 09/2014        34640         1723
5 10/2014        28780            0
6 11/2014        15112         3011





tt = tt[-1, ]




tt[ , 2:3] = lapply( tt[, 2:3], as.integer)

Warning messages:
1: In lapply(tt[, 2:3], as.integer) : NAs introduced by coercion
2: In lapply(tt[, 2:3], as.integer) : NAs introduced by coercion





head(tt)

     Date MON FLO&nbsp MON FNF&nbsp
2 07/2014        64830         9975
3 08/2014        52840         5107
4 09/2014        34640         1723
5 10/2014        28780            0
6 11/2014        15112         3011
7 12/2014        15225        12645





sapply(tt, class)

        Date MON FLO&nbsp MON FNF&nbsp 
 "character"    "integer"    "integer" 





names(tt)[2:3] = c("MON FLO", "MON FNF")



##  
##  names(tt) = gsub("&nbsp", "", names(tt))



names(tt)

[1] "Date"    "MON FLO" "MON FNF"





tmp = as.Date(sprintf("1/%s", tt$Date))
head(tmp)

[1] "0001-07-20" "0001-08-20" "0001-09-20" "0001-10-20" "0001-11-20" "0001-12-20"





tmp = as.Date(sprintf("1/%s", tt$Date), "%d/%m/%Y")
head(tmp)

[1] "2014-07-01" "2014-08-01" "2014-09-01" "2014-10-01" "2014-11-01" "2014-12-01"

range(tmp)

[1] "2014-07-01" "2016-06-01"





tt$Date = tmp




getMonthly = 
function(u = "http://cdec.water.ca.gov/cgi-progs/queryMonthly?MRC")
{
    tt = readHTMLTable(u, encoding = "UTF8", stringsAsFactors = FALSE)
    tt = tt[[1]][ -1 , -c(2, 4, 6) ]  
    tt[ , 2:3] = lapply( tt[, 2:3], as.integer)
    names(tt) = gsub("&nbsp", "", names(tt))
    tt$Date = as.Date(sprintf("1/%s", tt$Date), "%d/%m/%Y")
    tt
}




mrc = getMonthly()




u = "http://cdec.water.ca.gov/cgi-progs/queryMonthly"
numYears = 3
start = as.Date("2010-1-1")
q = sprintf("%s?%s&d=%s+00:00&span=%dyears", u, "MRC", start, numYears)
txt = htmlParse(q)




o = getMonthly(q)

        Date MON FLO MON FNF
2 2007-01-01   19170   16050
3 2007-02-01   16880   37029
4 2007-03-01   63960   68726
5 2007-04-01   74420   93563
6 2007-05-01  113100  103195
7 2007-06-01  116400   28923





u = "http://cdec.water.ca.gov/cgi-progs/queryF?SHA"
tt = readHTMLTable(u, which = 1, encoding = "UTF8", stringsAsFactors = FALSE)
tt = tt[-1,]
names(tt) = gsub("&nbsp", "", names(tt))
tt = tt[ names(tt) != "" ]
tt[, -1 ] = mapply(as, tt[, -1], c("numeric", "integer", "integer", "integer"))
tmp = strptime(tt[,1], "%m/%d/%Y %H:%M")
tt[, 1] = tmp




u = "http://cdec.water.ca.gov/cgi-progs/stages/FNFSUM"
tt = readHTMLTable(u, encoding = "UTF8", stringsAsFactors = FALSE, which = 1, skip.rows = 1, header = TRUE,
                   colClasses = c("character", rep("FormattedInteger", 14)))
head(tt)

                       V1    V2    V3      V4      V5     V6      V7     V8 V9 V10 V11 V12 V13    V14     V15
1 KLAMATH R COPCO-ORLEANS 33392 52041  632423 1089323 756087 1419407 708768 NA  NA  NA  NA  NA 708768 4691441
2   SALMON R AT SOMES BAR  7551 14590  161901  335881 215068  427061 226000 NA  NA  NA  NA  NA 226000 1388052
3   TRINITY R AT LEWISTON  8304 10510   55709  224984 181930  446763 259044 NA  NA  NA  NA  NA 259044 1187244
4         EEL R AT SCOTIA  2761 10259 1097073 2206481 597955 2188849 272400 NA  NA  NA  NA  NA 272400 6375778
5 RUSSIAN R AT HEALDSBURG     0   740   84975  299163  63801  364563  35413 NA  NA  NA  NA  NA  35413  848655
6     NAPA R NR ST HELENA     0     0    1682   16393   2850   29159   2398 NA  NA  NA  NA  NA   2398   52482





dim(tt)

[1] 36 15

table(sapply(tt, class))

character   integer 
        1        14 





doc = htmlParse(u, encoding = "UTF8")
tblNode = getNodeSet(doc, "//table")[[1]]
tt = readHTMLTable(tblNode, encoding = "UTF8", stringsAsFactors = FALSE, which = 1, skip.rows = 1, header = TRUE,
                   colClasses = c("character", rep("FormattedInteger", 14)))




tblNode[[2]]

<tr><td bgcolor="e0e0e0"><b>Stream </b></td>
<td bgcolor="e0e0e0"><b>Oct</b></td><td bgcolor="e0e0e0"><b>Nov</b></td><td bgcolor="e0e0e0"><b>Dec</b></td><td bgcolor="e0e0e0"><b>Jan</b></td><td bgcolor="e0e0e0"><b>Feb</b></td><td bgcolor="e0e0e0"><b>Mar</b></td><td bgcolor="e0e0e0"><b>Apr</b></td><td bgcolor="e0e0e0"><b>May</b></td><td bgcolor="e0e0e0"><b>Jun</b></td><td bgcolor="e0e0e0"><b>Jul</b></td><td bgcolor="e0e0e0"><b>Aug</b></td><td bgcolor="e0e0e0"><b>Sep</b></td><td bgcolor="e0e0e0"><b><font color="000080">AJRO </font></b></td>
<td bgcolor="e0e0e0"><b><font color="000080">WYRO </font></b></td>
</tr> 





xmlSApply(tblNode[[2]], xmlValue)

       td      text        td        td        td        td        td        td        td        td        td        td        td        td        td      text        td      text 
"Stream "      "\n"     "Oct"     "Nov"     "Dec"     "Jan"     "Feb"     "Mar"     "Apr"     "May"     "Jun"     "Jul"     "Aug"     "Sep"   "AJRO "      "\n"   "WYRO "      "\n" 





xpathSApply(tblNode, "./tr[2]/td", xmlValue)

 [1] "Stream " "Oct"     "Nov"     "Dec"     "Jan"     "Feb"     "Mar"     "Apr"     "May"     "Jun"     "Jul"     "Aug"     "Sep"     "AJRO "   "WYRO "  





names(tt) = xpathSApply(tblNode, "./tr[2]/td", xmlValue)




u = "http://www.cnrfc.noaa.gov/ensembleProduct.php?id=EXQC1&prodID=6"
tt = readHTMLTable(u, encoding = "UTF8")
length(tt)




tt = readHTMLTable(u, encoding = "UTF8", which = 8)




doc = htmlParse(u, encoding = "UTF8")
tblNode = getNodeSet(doc, "//table[ contains(tr[1], 'Monthly Streamflow Volume')]")[[ 1 ]] # the only table in the result




removeNodes(tblNode[[1]])




tblNode[[1]]

<tr>
  <td width="5%" bgcolor="#666666" align="center" class="blue-background">
    <b>Prob</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Jun</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Jul</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Aug</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Sep</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Oct</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Nov</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Dec</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Jan</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Feb</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Mar</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> Apr</b>
  </td>
  <td width="7%" bgcolor="#666666" align="center" class="blue-background">
    <b> May</b>
  </td>
</tr>





tblNode[[ xmlSize(tblNode) ]]

<tr>
  <td colspan="13" align="left" bgcolor="#FFFFFF" class="normalText">Note: MP/Avg is the "Most Probable Monthly Value (50%)" divided by the "Monthly Avg" (displayed as a %)</td>
</tr> 





removeNodes( tblNode[[ xmlSize(tblNode) ]] )




tt = readHTMLTable(tblNode, colClasses = c("character", rep("numeric", 12)))




u = "http://cdec.water.ca.gov/cgi-progs/queryMonthly?MRC"
doc = htmlParse(u, encoding = "UTF8")
h = getNodeSet(doc, "//table/tr[1]//font/i/a/@href")  # very specific

[[1]]
                                                                                                    href 
"/jspplot/jspPlotServlet.jsp?sensor_no=5317&end=06/01/2016+17:55&geom=small&interval=720&cookies=cdec01" 
attr(,"class")
[1] "XMLAttributeValue"

[[2]]
                                                                                                    href 
"/jspplot/jspPlotServlet.jsp?sensor_no=5316&end=06/01/2016+17:55&geom=small&interval=720&cookies=cdec01" 
attr(,"class")
[1] "XMLAttributeValue"

attr(,"class")
[1] "XMLNodeSet"





lapply(h, function(x) parseURI(x)$query)




library(RCurl)
sapply(h, function(x) getFormParams(parseURI(x)$query)["sensor_no"])




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

