print(load("~/Data/housing.rda"))
i = sample(nrow(housing), 30000)
h = housing[i,]
f = sapply(h, is.factor)
h[f] = lapply(h[f], droplevels)

h = subset(h, price < 4e6 & bsqft < 5000)


xyplot(price ~ bsqft | county, h, groups = br, auto.key = list(columns = 8), pch = ".", xlab = "Building size (square feet)", ylab = "Price ($)")





#panel functions

