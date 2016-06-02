
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

