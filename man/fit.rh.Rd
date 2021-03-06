% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RHModel.R
\name{fit.rh}
\alias{fit.rh}
\title{Fit a Renshaw and Haberman (Lee-Carter with cohorts) mortality model}
\usage{
\method{fit}{rh}(object, data = NULL, Dxt = NULL, Ext = NULL,
  ages = NULL, years = NULL, ages.fit = NULL, years.fit = NULL,
  oxt = NULL, wxt = NULL, start.ax = NULL, start.bx = NULL,
  start.kt = NULL, start.b0x = NULL, start.gc = NULL, verbose = TRUE,
  tolerance = 1e-04, iterMax = 10000, ...)
}
\arguments{
\item{object}{an object of class \code{"rh"} created with function 
\code{\link{rh}}.}

\item{data}{an optional object of type StMoMoData containing information on
deaths and exposures to be used for fitting the model. This is typically created 
with  function \code{\link{StMoMoData}}. If this is not provided then the fitting 
data is taken from arguments, \code{Dxt}, \code{Ext}, \code{ages}, \code{years}.}

\item{Dxt}{optional matrix of deaths data.}

\item{Ext}{optional matrix of observed exposures of the same dimension of 
\code{Dxt}.}

\item{ages}{optional vector of ages corresponding to rows of \code{Dxt} and 
\code{Ext}.}

\item{years}{optional vector of years corresponding to rows of \code{Dxt} and 
\code{Ext}.}

\item{ages.fit}{optional vector of ages to include in the fit. Must be a 
subset of \code{ages}.}

\item{years.fit}{optional vector of years to include in the fit. Must be a 
subset of \code{years}.}

\item{oxt}{optional matrix/vector or scalar of known offset to be used in fitting
the model. This can be used to specify any a priori known component to be added to 
the predictor during fitting.}

\item{wxt}{optional matrix of 0-1 weights to be used in the fitting process. 
This can be used, for instance, to zero weight some cohorts in the data.
See \code{\link{genWeightMat}} which is a helper function for defining 
weighting matrices.}

\item{start.ax}{optional vector with starting values for \eqn{\alpha_x}.}

\item{start.bx}{optional matrix with starting values for \eqn{\beta_x^{(i)}}.}

\item{start.kt}{optional matrix with starting values for \eqn{\kappa_t^{(i)}}.}

\item{start.b0x}{optional vector with starting values for \eqn{\beta_x^{(0)}}.}

\item{start.gc}{optional vector with starting values for \eqn{\gamma_c}.}

\item{verbose}{a logical value. If \code{TRUE} progress indicators are 
printed as the model is fitted. Set \code{verbose = FALSE} to silent the 
fitting and avoid progress messages.}

\item{tolerance}{a positive numeric value specifying the tolerance 
level for convergence.}

\item{iterMax}{a positive integer specifying the maximum number of 
iterations to perform.}

\item{...}{arguments to be passed to or from other methods.}
}
\value{
\item{model}{ the object of class \code{"rh"} defining the fitted 
  stochastic mortality model.}
  
  \item{ax}{ vector with the fitted values of the static age function 
  \eqn{\alpha_x}. If the model does not have a static age function or 
  failed to fit this is set to \code{NULL}.}
    
  \item{bx}{ matrix with the values of the period age-modulating functions 
  \eqn{\beta_x^{(i)}, i=1, ..., N}. If the \eqn{i}-th age-modulating 
  function is non-parametric (e.g. as in the Lee-Carter model) 
  \code{bx[, i]} contains the estimated values. If the model does not have 
  any age-period terms (i.e. \eqn{N=0}) or failed to fit this is set to 
  \code{NULL}.}
  
  \item{kt}{ matrix with the values of the fitted period indexes 
  \eqn{\kappa_t^{(i)}, i=1, ..., N}. \code{kt[i, ]} contains the estimated 
  values of the \eqn{i}-th period index. If the model does not have any 
  age-period terms (i.e. \eqn{N=0}) or failed to fit this is set to 
  \code{NULL}.}
  \item{b0x}{ vector with the values of the cohort age-modulating function 
  \eqn{\beta_x^{(0)}}. If the age-modulating function is non-parametric 
  \code{b0x} contains the estimated values. If the model does not have a 
  cohort effect or failed to fit this is set to \code{NULL}.}
    
  \item{gc}{ vector with the fitted cohort index \eqn{\gamma_{c}}.
  If the model does not have a cohort effect or failed to fit this is set
  to \code{NULL}.}
  
  \item{data}{ StMoMoData object provided for fitting the model.}
  
  \item{Dxt}{ matrix of deaths used in the fitting.}
  
  \item{Ext}{ matrix of exposures used in the fitting.}
  
  \item{oxt}{ matrix of known offset values used in the fitting.}
  
  \item{wxt}{ matrix of 0-1 weights used in the fitting.}
  
  \item{ages}{ vector of ages used in the fitting.}
  
  \item{years}{ vector of years used in the fitting.}
  
  \item{cohorts}{ vector of cohorts used in the fitting.}
  
  \item{fittingModel}{ output from the iterative fitting algorithm.}
  
  \item{loglik}{ log-likelihood of the model. If the fitting failed to 
  converge this is set to \code{NULL}.}
  
  \item{deviance}{ deviance of the model. If the fitting failed to 
  converge this is set to \code{NULL}.}
 
  \item{npar}{ effective number of parameters in the model. If the fitting
  failed to converge this is set to \code{NULL}.}
   
   \item{nobs}{ number of observations in the model fit. If the fitting
   failed to converge this is set to \code{NULL}.}

   \item{fail}{ \code{TRUE} if a model could not be fitted and 
   \code{FALSE} otherwise.}    
           
   \item{conv}{ \code{TRUE} if the model fitting converged and 
   \code{FALSE} if it didn't.}
}
\description{
Fit a Renshaw and Haberman (Lee-Carter with cohorts) mortality model
using the iterative Newton-Raphson procedure presented in Algorithm 1
of Hunt and Villegas (2015). This approach helps solve the 
well-known robustness and converges issues of the Lee-Carter model 
with cohort-effects.
}
\examples{

LCfit <-  fit(lc(), data = EWMaleData, ages.fit = 55:89)
wxt <- genWeightMat(55:89,  EWMaleData$years, clip = 3)
RHfit <- fit(rh(), data = EWMaleData, ages.fit = 55:89, 
             wxt = wxt, start.ax = LCfit$ax,
             start.bx = LCfit$bx, start.kt = LCfit$kt)
plot(RHfit)
 
#Impose approximate constraint as in Hunt and Villegas (2015)    
\dontrun{
RHapprox <- rh(approxConst = TRUE)
RHapproxfit <- fit(RHapprox, data = EWMaleData, ages.fit = 55:89, 
                    wxt = wxt)
plot(RHapproxfit) 
}

}
\references{
Hunt, A., & Villegas, A. M. (2015). Robustness and convergence in the 
Lee-Carter model with cohorts. Insurance: Mathematics and Economics, 
64, 186-202.
}
