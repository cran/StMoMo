#' Forecast mortality rates using a Stochastic Mortality Model
#' 
#' Forecast mortality rates using a Stochastic Mortality Model fit.
#' The period indexes \eqn{\kappa_t^{(i)}, i = 1,..N,} are forecasted
#' using ether a Multivariate Random Walk with Drift (MRWD) or 
#' \eqn{N} independent ARIMA\eqn{(p, d, q)} models. The cohort index 
#' \eqn{\gamma_{t-x}} is forecasted using an ARIMA\eqn{(p, d, q)}. 
#' By default an ARIMA\eqn{(1, 1, 0)} with a constant is used.
#' 
#' @param object an object of class \code{"fitStMoMo"} with the fitted 
#' parameters of a stochastic mortality model.
#' @param h number of years ahead to forecast.
#' @param level confidence level for prediction intervals of the 
#' period and cohort indices.
#' @param oxt optional matrix/vector or scalar of known offset to be 
#' added in the forecasting. This can be used to specify any a priori 
#' known component to be added to the forecasted predictor.
#' @param gc.order a specification of the ARIMA model for the cohort effect: 
#' the three components \eqn{(p, d, q)} are the AR order, the degree of 
#' differencing, and the MA. The default is an ARIMA\eqn{(1, 1, 0)}.
#' @param gc.include.constant a logical value indicating if the ARIMA model
#' should include a constant value. The default is \code{TRUE}. 
#' @param jumpchoice option to select the jump-off rates, i.e. the rates 
#' from the final year of observation, to use in projections of mortality 
#' rates. \code{"fit"}(default) uses the fitted rates and \code{"actual"} 
#' uses the actual rates from the final year.
#' @param kt.method optional forecasting method for the period index. 
#' The alternatives are \code{"mrwd"}(default) and \code{"iarima"}. See details.
#' @param kt.order  an optional matrix with one row per period index
#' specifying the ARIMA models: for the ith row (ith period index) the three 
#' components \eqn{(p, d, q)} are the AR order, the degree of  differencing, 
#' and the MA order. If absent the arima models are fitted using 
#' \code{\link[forecast]{auto.arima}}. This argument is only used when
#' \code{kt.method} is \code{"iarima"}.
#' @param kt.include.constant an optional vector of logical values 
#' indicating if the ARIMA model for the ith period index should include a 
#' constant value. The default is \code{TRUE}.  This argument is only used 
#' when \code{kt.method} is \code{"iarima"}. 
#' @param kt.lookback optional argument to specify the look-back window to use
#' in the estimation of the time series model for the period indexes. By 
#' default all the estimated values are used. If 
#' \code{kt.lookback} is provided then the last \code{kt.lookback} 
#' years of \eqn{\kappa_t^{(i)}, i = 1,..N,} are used.
#' @param gc.lookback optional argument to specify the look-back window to use
#'        in the estimation of the ARIMA model for the cohort effect. By 
#'        default all the estimated values are used in estimating the ARIMA 
#'        model. If \code{gc.lookback} is provided then the last 
#'        \code{gc.lookback} years of \eqn{\gamma_{t-x}} are used.
#' @param ... other arguments for \code{\link{iarima}}.
#'  
#' @return A list of class \code{"forStMoMo"} with components:
#' 
#' \item{rates}{ a matrix with the point forecast of the rates.}
#' \item{ages}{ vector of ages corresponding to the rows of \code{rates}.}
#' \item{years}{vector of years for which a forecast has been produced. This
#'  corresponds to the columns of \code{rates}.}
#'  
#' \item{kt.f}{ forecasts of period indexes of the model. This is a list with 
#' the \code{model} fitted to \eqn{\kappa_t}; the \code{mean}(central) 
#' forecast, the \code{lower} and \code{upper} limits of the prediction 
#' intervals; the confidence \code{level} associated with the prediction 
#' intervals; and the \code{years} for which a forecast was produced. If the 
#' model does not have any age-period terms (i.e. \eqn{N=0}) this is set to 
#' \code{NULL}.}
#'   
#' \item{gc.f}{ forecasts of cohort index of the model. This is a list with 
#' the \code{model} fitted to \eqn{\gamma_c}; the \code{mean}(point) forecast,
#' the \code{lower} and \code{upper} limits of the prediction intervals; the
#' confidence \code{level} associated with the prediction intervals; and the 
#' \code{cohorts} for which a forecast was produced. If the mortality model
#' does not have a cohort effect this is set to \code{NULL}.} 
#' 
#' \item{oxt.f}{ the offset used in the forecast.}
#' 
#' \item{fitted}{ a matrix with the fitted in-sample rates of the model for 
#' the years for which the mortality model was fitted.}
#'  
#' \item{model}{the model fit from which the forecast was produced.}
#'
#' \item{jumpchoice}{Jump-off method used in the forecast.}
#' 
#' \item{kt.method}{method used in the forecast of the period index.}
#' 
#' @details
#' If \code{kt.method} is \code{"mrwd"}, fitting and forecasting of 
#' the time series model for the  period indexes is done with a 
#' Multivariate Random Walk with Drift using the function 
#' \code{\link{mrwd}}.
#' 
#' If \code{kt.method} is \code{"iarima"}, fitting and forecasting of 
#' the time series model for the  period indexes is done with \eqn{N} 
#' independent arima models using the function \code{\link{iarima}}. 
#' See this latter function for details on input arguments 
#' \code{kt.order} and \code{kt.include.constant}.  
#' 
#' Fitting and forecasting of the ARIMA model for the cohort index
#' is done with function \code{\link[forecast]{Arima}} from package 
#' \pkg{forecast}. See the latter function for further details on 
#' input arguments \code{gc.order} and \code{gc.include.constant}. 
#' 
#' Note that in some cases forecast of the cohort effects may be
#' needed for a horizon longer than \code{h}. This is the case when 
#' in the fitted model the most recent cohorts have been zero weighted. 
#' The forecasted cohorts can be seen in \code{gc.f$cohorts}. 
#' 
#' @examples 
#' #Lee-Carter (random walk with drift)
#' LCfit <- fit(lc(), data = EWMaleData, ages.fit = 55:89)
#' LCfor <- forecast(LCfit)
#' plot(LCfor)
#' 
#' #Lee-Carter (forecast with ARIMA(1,1,2) with drift )
#' LCfor.iarima1 <- forecast(LCfit, kt.method = "iarima", kt.order = c(1, 1 , 2))
#' plot(LCfor.iarima1)
#' 
#' #Lee-Carter (forecast with auto.arima)
#' LCfor.iarima2 <- forecast(LCfit, kt.method = "iarima")
#' plot(LCfor.iarima2)
#' 
#' #CBD (Multivariate random walk with drift)
#' CBDfit <- fit(cbd(), data = central2initial(EWMaleData), ages.fit = 55:89)
#' CBDfor <- forecast(CBDfit)
#' plot(CBDfor, parametricbx = FALSE)
#' 
#' #CBD (Independent Arima models)
#' kt.order <- matrix(c(1, 1, 2,  #ARIMA(1, 1, 2) for k[1]
#'                      0, 1, 1), #ARIMA(0, 1, 1) for k[2]
#'                    nrow = 2, ncol = 3, byrow = TRUE)
#' CBDfor.iarima <- forecast(CBDfit, kt.method = "iarima", kt.order = kt.order)
#' plot(CBDfor.iarima, parametricbx = FALSE)
#' 
#' #APC: Compare forecast with different models for the cohort index
#' wxt <- genWeightMat(55:89,  EWMaleData$years, clip = 3)
#' APCfit <- fit(apc(), data = EWMaleData,  ages.fit = 55:89, 
#'               wxt = wxt)
#' APCfor1 <- forecast(APCfit)
#' plot(APCfor1, parametricbx = FALSE, nCol = 3)
#' APCfor2 <- forecast(APCfit, gc.order = c(0, 2, 2))
#' plot(APCfor2, only.gc = TRUE)
#' plot(c(APCfit$years, APCfor1$years), 
#'      cbind(APCfor1$fitted, APCfor1$rates)["65", ], 
#'      type = "l", xlab = "year", ylab = "Mortality rate at age 65", 
#'      main = "Forecasts with different models for gc")
#' lines(APCfor2$years, APCfor2$rates["65", ], col = "blue")
#' points(APCfit$years, (APCfit$Dxt / APCfit$Ext)["65", ], pch = 19) 
#' 
#' #Compare Lee-Carter forecast using: 
#' #  1. Fitted jump-off rates and all history for kt
#' #  2. Actual jump-off rates and all history for kt
#' #  3. Fitted jump-off rates and only history for 
#' #     the past 30 years of kt (i.e 1982-2011)
#' 
#' LCfor1 <- forecast(LCfit)
#' LCfor2 <- forecast(LCfit, jumpchoice = "actual")
#' LCfor3 <- forecast(LCfit, kt.lookback = 30) 
#' 
#' plot(LCfit$years, (LCfit$Dxt / LCfit$Ext)["60", ],
#'      xlim = range(LCfit$years, LCfor1$years),
#'      ylim = range((LCfit$Dxt / LCfit$Ext)["60", ], LCfor1$rates["60", ],
#'                   LCfor2$rates["60", ], LCfor3$rates["60", ]),
#'      type = "p", xlab = "year", ylab = "rate",
#'      main = "Lee-Carter: Forecast of mortality rates at age 60")
#' lines(LCfit$years, fitted(LCfit, type = "rates")["60", ])
#' lines(LCfor1$years, LCfor1$rates["60", ], lty = 2)
#' lines(LCfor2$years, LCfor2$rates["60", ], lty = 3, col = "blue")
#' lines(LCfor3$years, LCfor3$rates["60", ], lty = 4, col = "red")
#' legend("topright",legend = c("Fitted jump-off", "Actual jump-off", 
#'        "Fitted jump-off, 30 year look-back"), 
#'        lty = 1:3, col = c("black", "blue", "red"))
#' @export
forecast.fitStMoMo <-function(object, h = 50, level = c(80, 95), oxt = NULL,
                              gc.order = c(1, 1, 0),
                              gc.include.constant = TRUE,
                              jumpchoice = c("fit", "actual"),
                              kt.method = c("mrwd", "iarima"),
                              kt.order = NULL,
                              kt.include.constant = TRUE,
                              kt.lookback = NULL, gc.lookback = NULL,
                              ...) {
  
  jumpchoice <- match.arg(jumpchoice)
  kt.method <- match.arg(kt.method)
  for (i in 1:length(level)) { 
    if (level[i] > 0 & level[i] < 1) 
      level[i] <- 100 * level[i]
    else if (level[i] < 0 | level[i] > 99.99) 
      stop("Confidence limit out of range")
  }
  level <- sort(level)
  #forecast kt  
  kt <- object$kt
  years <- object$years
  nYears <- length(years)
  if (is.null(kt.lookback)) kt.lookback <- nYears 
  if (kt.lookback <= 0)
    stop("kt.lookback must be positive")
  kt.lookback <- min(c(kt.lookback, nYears))
  yearsFor <- (years[nYears] + 1):(years[nYears] + h)
  agesFor <- object$ages
  nAges <- length(object$ages)
  kt.h <- kt
  kt.f <- NULL
  kt.model <- NULL
  years.h <- years
  years.f <- yearsFor
  if (object$model$N > 0) {
    kt.nNA <- max(which(!is.na(kt[1, ])))
    kt.hNA <- nYears - kt.nNA
    if (kt.method == "mrwd")
      kt.model <- mrwd(kt[, (1 + nYears - kt.lookback):kt.nNA])
    else if (kt.method == "iarima") 
      kt.model <- iarima(kt[, (1 + nYears - kt.lookback):kt.nNA], 
                         order = kt.order, 
                         include.constant = kt.include.constant, ...)
    kt.for <- forecast(kt.model, h = h + kt.hNA, level = level)
    if (kt.hNA > 0) {
      years.h <- years[-((kt.nNA+1):nYears)]
      years.f <- c(years[(kt.nNA+1):nYears], years.f)
      kt.h <-array(kt.h[, 1:kt.nNA], c(nrow(kt), kt.nNA))
      dimnames(kt.h)[[2]] <- years.h      
    }
    kt.lower <- kt.for$lower
    kt.upper <- kt.for$upper
    kt.f <- list(mean = kt.for$mean, lower = kt.lower, upper = kt.upper,
                 level = level, model = kt.model, years = years.f)    
  }  
  #forecast gc
  gc <- object$gc
  cohorts <- object$cohorts
  nCohorts <- length(cohorts)
  if (is.null(gc.lookback)) gc.lookback <- nCohorts 
  if (gc.lookback <= 0)
    stop("gc.lookback must be positive")
  gc.lookback <- min(c(gc.lookback, nCohorts))
  gc.h <- gc
  cohorts.h <- cohorts
  gc.model <- NULL
  gc.f <- NULL
  cohorts.f <- (cohorts[nCohorts] + 1):(cohorts[nCohorts] + h)
  if (!is.null(object$model$cohortAgeFun)) {
    gc.nNA <- max(which(!is.na(gc)))
    gc.hNA <- nCohorts - gc.nNA
    gc.model <- forecast::Arima(gc[(1 + nCohorts - gc.lookback):gc.nNA], 
                                order = gc.order, 
                                include.constant = gc.include.constant) 
    gc.for <- forecast(gc.model, h = h + gc.hNA, level = level) 
    
  if (gc.hNA > 0) {      
      gc.h <- gc[-((gc.nNA+1):nCohorts)]
      cohorts.h <- cohorts[-((gc.nNA + 1):nCohorts)]
      cohorts.f <- c(cohorts[(gc.nNA + 1):nCohorts], cohorts.f)
    }   
    gc.f <- list(mean = as.vector(gc.for$mean), 
                 lower = gc.for$lower, 
                 upper = gc.for$upper, level = level, 
                 model = gc.model, cohorts = cohorts.f)
    
    names(gc.f$mean) <- dimnames(gc.f$upper)[[1]] <- dimnames(gc.f$lower)[[1]] <- cohorts.f
  }  
  #Offset
  if (is.null(oxt)) oxt <- 0
  oxt.f <- matrix(oxt, nrow = nAges, ncol = h)
  colnames(oxt.f) <- yearsFor
  rownames(oxt.f) <- agesFor
  #predict rates
  rates <- predict(object, years = c(years.h, years.f), 
                   kt = cbind(kt.h, kt.f$mean), gc = c(gc.h, gc.f$mean),
                   oxt = cbind(object$oxt, oxt.f), type = "rates")
  
  #Apply jump-off option
  forcastRates <- rates[, (nYears + 1):(nYears + h)]
  fittedRates <- rates[, 1:nYears]
  if (jumpchoice == "actual") {
    jumpoffRates <- (object$Dxt / object$Ext)[, nYears]
    forcastRates <- forcastRates * jumpoffRates / fittedRates[ , nYears]
  }
  
  #prepare output
  structure(list(rates = forcastRates, ages = agesFor, years = yearsFor, 
                 kt.f = kt.f, gc.f = gc.f, oxt.f = oxt.f, 
                 fitted = fittedRates, model = object,
                 jumpchoice = jumpchoice, kt.method = kt.method,
                 call = match.call()), 
            class = "forStMoMo")
}

#' @export 
print.forStMoMo <- function(x,...) {
  cat("Stochastic Mortality Model forecast")
  cat(paste("\nCall:", deparse(x$call)))
  cat("\n\n")
  print(x$model$model)  
  cat(paste("\n\nkt model:", x$kt.method))
  if (x$kt.method == "iarima") {
    if (x$model$model$N > 0) {
      for ( i in 1:x$model$model$N){
        cat(paste("\n   kt[",i,"]: ", 
                  arima.string(x$kt.f$model$models[[i]]), sep = ""))
      }
    }
  }
  if (!is.null(x$gc.f))
    cat(paste("\ngc model: ", arima.string(x$gc.f$model), sep = ""))
  cat(paste("\nJump-off method:", x$jumpchoice))
  cat("\nData: ", x$model$data$label)
  cat("\nSeries: ", x$model$data$series)
  cat(paste("\nYears in forecast:", min(x$years), "-", max(x$years)))
  cat(paste("\nAges in forecast:", min(x$ages), "-", max(x$ages), "\n"))  
}
