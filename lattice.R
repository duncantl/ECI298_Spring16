
plot(-1* d$LONGITUDE, d$LATITUDE)




plot(-1* d$LONGITUDE, d$LATITUDE, pch = ".")




plot(-1* d$LONGITUDE, d$LATITUDE, pch = ".", xlab = "Longitude", ylab = "Latitude")




map('county', xlim = c(-125, -113), ylim = c(30, 44))
points(-1* d$LONGITUDE, d$LATITUDE, pch = ".", col = "red")

