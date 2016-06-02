
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

