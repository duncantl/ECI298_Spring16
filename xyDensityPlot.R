
xyDensityPlot =
  #
  # Draw a scatterplot of two variables
  # Then draw the marginal densities above and to the right
  # of the plot
  #
  # Adapted from Paul Murrell and Ross Ihaka's example.
  #
  # This illustrates
  #    writing functions,
  #    using ...,
  #    detecting if an argument is missing,
  #    writing utility functions
  #    on.exit() 
  #  
  #  Illustrates the graphics functions and concepts
  #  layout(), lines(), par(), grid() (the function not package)
  #  abline(), arrows(), plot methods for "lm" and density classes,
  #  mtext & margins and of course plot.
  #
  #  x and y - numeric vectors of the same length.
  #
  #  ...  - any parameters that will be passed directly
  #       to the call to plot() to create the scatter plot.
  #
function(x = rnorm(100), y = rnorm(100), group = NULL, ..., main = "")
{
      # Get the current state of the graphics settings
    opar = par(no.readonly = TRUE)
      # Arrange that when we exit this function, we will
      # restore the settings to what they originally were
      # Leave things as they were before we got here.
    on.exit(par(opar))

      # See if the caller specified the main parameter
      # Could just use main == "", but this tests whether
      # it was specified or not which is different from
      # actually specifying main = "", rather than getting
      # the default value. 
    haveMain = !missing(main)

      # If the caller gave us a main, make certain
      # to make room to show it. We need to create outer
      # margins for the entire display. This is the oma
      # element of par.  We only want an outer margin
      # on the top of the display, not the bottom, left or right.
      # So we specify the margin for those portions of the display
      # as 0. I use names here to make it clear which is which
      # but we don't have to specify them.
      # The value 3 here means the height for 3 lines of text.
    if(haveMain)
       par(oma = c(bottom = 0, left = 0, 3, right = 0))


      # Carve the display into cells and specify which plot
      # (by number) will occupy which cells.
      # You should do this interactively outside of the function
      # call layout.show(max(m)) to see the regions
      # and which plot will go into which region.
    
    m = matrix(c(2, 2, 4, # could be 0 for no plot
                 1, 1, 3,
                 1, 1, 3),
               3, 3, byrow = TRUE)
    layout(m, heights = c(1, 2, 2),
              widths = c(2, 2, 1))
    # Try layout.show(max(m))  to see what this gives
      # The width and heights give the relative proportions
      # for the rows and columns respectively.
      # The heights of c(1, 2, 2) mean that the first row
      # gets 1/5th of the display, and the other two rows
      # get 2/5ths each of the display, after we have taken
      # into account the outer margins.


      # okay, now we can start drawing and we start with the
      # scatterplot. In order to avoid any extra space at the top
      # and the right of the plot where we put the densities,
      # we have to remove any figure margins on these sides.
      # These are different from outer margins. So we specify
      # this with the mar setting for par(). We want to keep
      # the usual margins for a plot for the bottom and left
      # and set the top and right to 0.
   
    par(mar = c(opar$mar[1:2], 0, 0))
      # now we create the scatter plot, add a light-grey grid and
      # the regression/least squares line for the linear model.
      # Note that we pass any additional parameters to plot via ...
      # We don't pass main on because we want that to go as the
      # title for the entire display, not the sub-plot.
      # Also if we did have a title for this plot, it wouldn't
      # appear as we set the top margin to 0.
    col = if(is.null(group))
             rep("black", length(x))
          else {
             group = factor(group)
             rainbow(length(levels(group)))[group]
          }
                    
    plot(x, y, col = col, ...)
    grid()
    abline(lm(y ~ x), col = "salmon", lty = "dashed")

      # This is silly as we are hard coding the value.
      # We should do this separately from our function. But how?
    arrows(-7.5, 11.5, -8, 11.9, length = .1)

       # So now we add the title, but do it in the outer margin of the
       # entire display. We use mtext() to add margin text, specify
       # the top side (3) and 
    if(haveMain)
       mtext(main, 3, outer = TRUE, cex = 1.5)    


      # Now we move onto the second sub-plot which is the density
      # of the horizontal data and we plot this above the scatterplot.
      # Again we need to fiddle with the margins to avoid
      # space between the scatterplot and the density.
      # We want no space on the bottom and top, but the same
      # margins on the left and right as for the scatterplot
      # so that the two plots are aligned horizontally
    par(mar = c(0, opar$mar[2], 0, opar$mar[4]))

      # We are going to draw the smoothed density estimate of our data
      # and then also super-impose the corresponding normal  density
      # To get this right, we need to compute the maximum value of
      # the two densities before we plot either and use this to set the
      # ylim for our density plot.  
     # We would like to use curve(dnorm(x, mean, sd), x.min, x.max)
     # to draw the normal density, but that is not easy to achieve.
     # So we write a separate functiont to compute the points of the density
     # that we can plot with lines() later.  We have this function return the
     # values of the densities  that we will draw and so we can also compute the ylim.
    d = addNormalDensity(x, add = FALSE)

      # Now we can draw the density for the data.
      # Note we want no axes or axes labels, etc. This is what axes = FALSE and ann = FALSE does
    plot(density(x), ann = FALSE, axes = FALSE, ylim = c(0, max(density(x)$y, d$y)))
    lines(d$x, d$y, col = "red", lwd = 2)
      

      #  Now we move on to the 3rd plot with the density from the vertical
      # axis, i.e. the y's.
      # This is very similar to the plot for the horizontal density
      # but we have two things to do differently.
      # Firstly, we have set the different margins to 0, here the left top and right margins
      # and we have to leave the bottom margin as the same value as used in the scatter
      # plot to ensure the two plots are aligned vertically.
      # The other thing we have to do is plot this sideways, so we plot
      # x on the vertical axis and y on the horizontal axis.
    dy = density(y)
    par(mar = c(opar$mar[1], 0, 0, 0))
    d = addNormalDensity(y, add = FALSE)
    plot(dy$y, dy$x, type = "l", ann = FALSE, axes = FALSE, xlim = c(0, max(dy$y, d$y)))
    lines(d$y, d$x, col = "red", lwd = 2)
    
    invisible(TRUE)
}

addNormalDensity =
  #
  # At each of the given x values, compute 
  # the density of the normal distribution
  # drawing them on the current plot if add is TRUE.
  # If we need to set the x and y limits of the plot
  # then we need these values first and so specify
  # add = FALSE and then draw the curve ourselves
  # with lines(ans$x, ans$y)
function(x, ..., add = TRUE)
{
    # we sort the x's because we will want to draw them with lines
    # and so connect them in order rather than the way they are
    # in the data, i.e. random order.
  x = sort(x) 
  y = dnorm(x, mean(x, na.rm = TRUE), sd(x, na.rm = TRUE))
  if(add)
      lines(x, y, ...)
  list(x = x, y = y)
}

if(TRUE) {

    # Here we will test the function.
    # We can generate bivariate normal values
    # using mvrnorm in the MASS package.
  library(MASS)
  D = mvrnorm(100, c(0, 10), matrix(c(1, .75, .75, 1), 2, 2))
    # Add a weird outlying point.
  D = rbind(D, c(-8, 12))
      # Call our function.
      # Specifying a label or title as an expression
      # makes R use plotmath to render that text.
      # See example(plotmath) for an example.
  xyDensityPlot(D[,1], D[,2], sample(c("A", "B"), nrow(D), replace = TRUE),
                 xlab = "Altitude", ylab = "Pressure",
                 main = expression(paste("Scatterplot and Density: ",
                                         mu,
                                         "= 0 & 10, ",
                                         sigma,
                                         " = 1, ",
                                         rho,
                                         " = .75" )))

}

if(FALSE) {
  # How about adding the arrow now
    arrows(-8.0, 11.5, -8, 11.9, length = .1, col = "red")
  # where did it go.
  # The grid graphics system would help us with all of this.
}
