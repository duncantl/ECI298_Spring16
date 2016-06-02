
u = "http://cdec.water.ca.gov/cgi-progs/queryF?SHA"
tt = readHTMLTable(u, which = 1, encoding = "UTF8", stringsAsFactors = FALSE)
tt = tt[-1,]
names(tt) = gsub("&nbsp", "", names(tt))
tt = tt[ names(tt) != "" ]
tt[, -1 ] = mapply(as, tt[, -1], c("numeric", "integer", "integer", "integer"))
tmp = strptime(tt[,1], "%m/%d/%Y %H:%M")
tt[, 1] = tmp

