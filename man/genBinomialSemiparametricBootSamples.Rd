% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bootstrapfitStMoMo.R
\name{genBinomialSemiparametricBootSamples}
\alias{genBinomialSemiparametricBootSamples}
\title{Generate Binomial semiparametric bootstrap samples}
\usage{
genBinomialSemiparametricBootSamples(D, E, nBoot)
}
\arguments{
\item{D}{matrix of deaths}

\item{E}{matrix of exposures}

\item{nBoot}{number of bootstrap samples to produce.}
}
\value{
a list of length \code{nBoot} of matrices with sampled deaths
}
\description{
Generate Binomial semiparametric bootstrap samples using a suitable 
adaptation of the Poisson procedure described in Brouhns et al (2005).
}
\references{
Brouhns, N., Denuit M., & Van Keilegom, I. (2005). Bootstrapping the 
Poisson log-bilinear model for mortality forecasting. 
Scandinavian Actuarial Journal, 2005(3), 212-224.
}
\keyword{internal}
