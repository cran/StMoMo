% GGGenerated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/docStMoMo.R
\docType{data}
\name{EWMaleData}
\alias{EWMaleData}
\title{England and Wales male mortality data}
\format{A list  with the following components:
\describe{
  \item{Dxt}{ matrix of deaths data.}
  \item{Ext}{ matrix of exposures data (mid year population estimates).}
  \item{ages}{ vector of ages.}
  \item{years}{ vector of years.}
  \item{type}{ the type of exposure in the data (central).}
  \item{series}{ name of the extracted seriesin this case males.}
  \item{label}{ label of the data.}
}}
\source{
Human Mortality Database \url{http://www.mortality.org/}.
}
\usage{
EWMaleData
}
\description{
Age-specific deaths and exposures for England and Wales from
the Human Mortality Database. This is an object of class StMoMoData.
}
\details{
\code{EWMaleData} contains deaths and exposures for England and
Wales males for the period 1961-2011 and for ages 0-100.
Data taken from the Human Mortality Database on 5 November 2014.
}
\references{
Human Mortality Database (2014). University of California,
Berkeley (USA), and Max Planck Institute for Demographic Research (Germany).
Available at \url{www.mortality.org}.
}
\seealso{
\code{\link{StMoMoData}}
}
\keyword{datasets}

