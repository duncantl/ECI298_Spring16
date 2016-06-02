
x = rnorm(100, 4.3)




 -n/2 *log(2 * pi) - n/2*log(sigma^2) - (1/2*sigma^2) * sum( (x - mu)^2 )




function(mu)
  - 1/2 * sum( (x - mu)^2 )




negLogLik = 
function(mu)
   1/2 * sum( (x - mu)^2 )




genNegLikFunc =
function(sampleValues)
{
  function(mu)
     1/2 * sum( (sampleValues - mu)^2 )
}




fun = genNegLikFunc(x)




x1 = rnorm(100, -2)
x2 = rnorm(100, 45.9)




fun1 = genNegLikFunc(x1)
fun2 = genNegLikFunc(x2)




fun1(0)

[1] 313.8726

fun2(0)

[1] 104648.5





optimize(fun1, c(-10, 10))

$minimum
[1] -2.241545

$objective
[1] 62.64643





mean(x1)
[1] -2.241545




optimize(fun2, c(-100, 100))

$minimum
[1] 45.73636

$objective
[1] 57.72158





optim(0, fun2)

$par
[1] 45.7375

$value
[1] 57.72164

$counts
function gradient 
      42       NA 

$convergence
[1] 0

$message
NULL





optim(0, fun2, method = "Brent", lower = -100, upper = 100)




rm(x1, x2)




fun1(-2)

