% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/J.R
\name{J}
\alias{J}
\title{The correction factor J for a standardized mean difference.}
\usage{
J(statistics, design)
}
\arguments{
\item{statistics}{a list of pre-computed statistics. The statistics to provide
depend on the design:
- for "between": \code{n1}, \code{n2}, the sample sizes of the two groups;
- for "within":  \code{n}, and \code{r} or \code{rho} the correlation between
the measure;
- for "single":  \code{n}.}

\item{design}{the design of the measures (\code{"within"}, \code{"between"}, or \code{"single"});}
}
\value{
The correction factor for unbiasing a Cohen's $d_p$.
The return value is internally a dpObject which can be
displayed with print, explain or summary/summarize.
}
\description{
\code{J()} computes the correction factor to get an unbiased Cohen's $d_p$ in either within-
subject, between-subject design and single-group design. See
\insertCite{l22,gc18,;textual}{CohensdpLibrary}.
}
\details{
This function decreases the degrees of freedom by 1 in within-subject design when the population
rho is unknown.
}
\examples{

# example in which the means are 114 vs. 101 with sds of 14.3 and 12.5 respectively
J( statistics = list( n1 = 12, n2 = 12 ), 
   design     = "between")

# example in a repeated-measure design
J( statistics = list( n = 12, rho = 0.53 ), 
   design     = "within")

# example with a single-group design where mu is a population parameter
J( statistics = list( n = 12 ), 
   design     = "single")

# The results can be displayed in three modes
res <- J( statistics = list( n = 12 ), 
          design     = "single")

# a raw result of the Cohen's d_p and its confidence interval
res              

# a human-readable output
summarize( res ) 

# ...and a human-readable ouptut with additional explanations
explain( res )   
                 
}
\references{
\insertAllCited{}
}
