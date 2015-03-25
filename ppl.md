---
title: "Points (or point-pairs) per lag-distance class - PPL"
author: "Alessandro Samuel-Rosa"
date: "24/02/2015"
output:
  html_document:
    toc: yes
  pdf_document:
    toc: yes
  word_document: default
---

# Introduction

It is long known that the variogram is central to geostatistics (Matheron1969;
WebsterEtAl2007). As such, several methods have been proposed to create
sample patterns to estimate the variogram efficiently (deGruijterEtAl2006;
Mueller2007; WebsterEtAl2013). The first methods were based on estimation of the
variogram using the classic method of moments (BreslerEtAl1982; Russo1984;
WarrickEtAl1987). Modern methods focus on the robust maximum likelihood
estimators of the variogram (Lark2002; Zimmerman2006; Mueller2007). The later
usually require some knowledge about the variogram model.

More recently a Bayesian approach has been suggested to enable taking into
account the uncertainty of the estimated variogram model parameters when
selecting sample locations (ZhuEtAl2005; DiggleEtAl2006). This approach requires
the *a priori* specification of the spatial correlation function and the
interval of possible values for its parameters.

Although theoretically sound, the Bayesian approach does is sub-optimal when we
are very uncertain about the variogram model parameters. The less we know, the
less efficient a Bayesian sample pattern is in estimating the true variogram
model (ZhuEtAl2005). It is a quite efficient approach when we are uncertain only
about the nugget and/or the partial sill. But when we are uncertain about the
range parameter or about the three parameters altogether, its efficiency can be
similar to that of a regularly spaced sample pattern (ZhuEtAl2005).

An adaptive Bayesian approach was suggested as an alternative to overcome the
weaknesses of the single-phase Bayesian approach (MarchantEtAl2006). In adaptive
Bayesian sampling one starts with a reconnaissance survey and, as knowledge
about the environmental variable is constructed, the sample pattern is adapted
iteratively to maximize its efficiency given the chosen optimizing criterion.
Alike its single-phase counterpart, the adaptive Bayesian approach is 
computationally intensive and requires a minimum previous knowledge about the
form of the variogram model.

Practical implementation of the Bayesian methods mentioned above is unrealistic
if the sample pattern needs to be optimized for more than a couple of 
environmental variables. Also, due to several reasons, we usually are unable to
specify the variogram model and the respective ranges of possible parameters. As
such, we propose a new method that avoids complicated and time-consuming
calculations. The optimization of the sample pattern relies on the main
assumption that we are completely ignorant about the spatial variation of the
environmental variable.

# Relevant spatial scales

Sampling to identify the variogram model and estimate its parameters should
concentrate on the relevant pair-wise distances, that is, the relevant
spatial scales on which environmental variables vary (Lark2011). MuellerEtAl1999
observed that the distribution of pair-wise distances of the
best sample patterns had a mode close to the range parameter of the variogram
model. Lark2002 showed that when the range of spatial dependency is short,
the resulting distribution of pair-wise distances is bimodal, with the first
mode close to zero distance units, and the second mode at about half the maximum
distance across the spatial domain.

The extensive literature on sampling for variogram estimation, including the 
studies cited above, provides the basis for the definition of a few 
rules-of-thumb. In general, if we know that a significant part of the variation
is structured at short distances, then several clusters of sample points should
be placed throughout the spatial domain. The size of the clusters, i.e. the
number of sample points in each cluster, depends on the degree of spatial
dependence of the environmental variable. With smaller spatial dependency,
the sample points should be assigned to a few large clusters to obtain a
reliable estimate of the nugget variance. Smaller clusters can be used when the
degree of spatial dependency is larger. This will yield a more homogeneous
coverage of the spatial domain, although this is not necessary for variogram 
estimation if we assume a constant mean and variance. If both the degree and
range of spatial dependency are large, then sample points can be spread
throughout the spatial domain, but retaining a few clusters to estimate the
nugget variance.

## A conservative solution

How do we concentrate on the relevant spatial scales if we are completely
ignorant about the spatial variation of the environmental variable?
BreslerEtAl1982, Russo1984, and WarrickEtAl1987 proposed the use of a general
purpose, *conservative solution*. According to WarrickEtAl1987, the location of
the sample points should be determined as to match a uniform frequency 
distribution of pair-wise distances. In other words, to cover uniformly the
variogram space. Being a conservative solution, it was implicitly sub-optimal
for a given variogram model (MuellerEtAl1999; Lark2002), but expected to be
globally optimal for an infinite set of unknown variogram models. 

At first, the idea of having a uniform distribution of pair-wise distances
seems to be appropriate, specially when the number of affordable sample points
is small. Conservative solutions are usually chosen when the amount of resources
available is limited. The same logic is used to optimize sample patterns to
select between a linear and a non-linear structure to model the deterministic
part of the spatial variation of an environmental variable. We sample uniformly
along the marginal distribution of each environmental covariate 
(MinasnyEtAl2006b).

### Critiques and solutions

The method proposed by WarrickEtAl1987 has been criticized for several
reasons. The first critique is due to the fact that the hypothesized global
optimality of the method for an infinite set of unknown variogram models has not
been proved mathematically nor corroborated by empirical evidence (Lark2002).

A common critique to the ideas of BreslerEtAl1982, Russo1984, and 
WarrickEtAl1987 is that they were rooted on the use of the method-of-moments
to fit a continuous function to the binned empirical variogram. It is known that
the estimates of the method-of-moments are affected by the correlation between
the sequence of classes of pair-wise distances and that more robust methods
exist (DiggleEtAl2002). Maximum likelihood methods estimate model parameters
using all data points, avoiding the need for an *ad hoc* definition of classes
of pair-wise distances that generally smooth out the structure of the spatial
process (Lark2000).

Although being an interesting description of a sample pattern, it is known that
sample patterns with the same distribution of pair-wise distances can have
completely different spatial configurations (MuellerEtAl1999). This occurs for
two reasons. First, the distribution of pair-wise distances is an unidimensional
measure that does not consider the shape and orientation of the spatial domain
being sampled. Second, the position of every sample point is defined relative to
only a fraction of the whole set of sample points. This can ultimately result
in significantly different estimates of the variogram model parameters if our
assumption of a constant mean and variance is incorrect.

The way how the location of every sample point is defined has another negative
consequence. The optimized sample pattern is commonly formed by a single large 
cluster of sample points, with a few points scattered throughout the spatial 
domain. We say that the sample pattern is highly redundant, that is, poorly
informative. This is particularly inappropriate for variogram estimation due to 
the high correlation between the estimates of the variogram model parameters
(MuellerEtAl1999).

A solution to maximize the amount of information produced by a sample pattern
is to divide the spatial domain into equal-size strata within which we 
distribute the sample points (PettittEtAl1993; deGruijterEtAl2006). Because
PettittEtAl1993 also wanted to sample all possibly relevant spatial scales, they
distributed the sample points along transects separated by exponentially growing
distances (0.25, 1, 5, 25, and 125 metres). This is a safe sampling solution
when no information on the magnitude or scale of variation of a environmental
variable is available.

The method proposed by PettittEtAl1993 has another important feature. The use of
exponential distances yields a cluster of points separated by short distances
within each stratum. The use of spatial strata guarantees that there will be
clusters of points spread throughout the entire spatial domain. This is
particularly important because it enables a more accurate estimation of the
nugget variance. The only weakness, aiming at the construction of an
optimization algorithm, is that it is unknown which criterion the method
minimizes or maximizes, being essentially heuristic.

# Points per lag-distance class

We propose a general purpose objective function to optimize sample patterns for
the estimation of variogram parameters when we are ignorant about the spatial
variation of the environmental variable. In such a scenario, we can only explore
a distance measure. WarrickEtAl1987 showed that distance-related parameters
control the spread of points and the coverage of the spatial domain. Many later
studies that assumed the form of the variogram model to be known observed that
the range parameter plays a large control of the spatial configuration of the
sample pattern, specially its clustering degree (MuellerEtAl1999; Lark2002; 
ZhuEtAl2005; Zimmerman2006).

The distribution of pair-wise distances is a useful description of a sample
pattern. However, its use is rooted on the use of the method-of-moments for
variogram estimation. Instead of point-pairs, maximum likelihood methods
estimate model parameters using all data points. To maximize the amount of 
information of the data points, we need every sample point to produce 
information for every possibly relevant spatial scale. As such, we need the
location of every sample point to be defined relative to every other sample
point. We also need to define the possibly relevant spatial scales. The logical 
solution is to explore exponential spacings to enable an accurate estimate of 
the nugget variance, but also cover the entire variogram space.

The upper limit of the variogram space should be defined as half the the maximum
distance across the spatial domain (TruongEtAl2013). This is because the
estimates of the variogram for distances larger than half the maximum distance
across the sampling grid are highly uncertain (Lark2002). The possibly relevant
spatial scales can be defined exploring the geostatistical concept of 
lag-distance classes. Using exponential spacings up to half the maximum
distance across the spatial domain, and defining the location of every sample 
point relative to every other sample point, will create a sample pattern with 
small clusters scattered throughout the spatial domain.

The proposed method is defined by the following objective: having all sample 
points contributing to all possibly relevant spatial scales. The method is
implemented in the function `optimPPL()` of the ***spsann*** package. The method
proposed by WarrickEtAl1987 is implemented as well for comparison purposes, and
can be used setting `pairs = FALSE`. We now describe the definitions used in
the current implementation.

## Distances

The definition of a distance measure is fundamental in our method. The current
implementation uses Euclidean distances between the sample points. This requires
the coordinates to be projected. The user is responsible for making sure that
this requirement is attained. Contributions to allow the use of non-projected 
coordinates are welcome.

## Types of lags

Our interest is on the use of exponentially growing lag-distance classes.
However, we also implemented uniformly spaced lags for comparison purposes. The 
choice between one and another is made using the argument `lags.type`.

Uniformly spaced lags are used setting `lags.type = "equidistant"`. They are
created by simply dividing the interval from 0.0001 up to the value passed to
the argument `cutoff` by the required number of lags. The minimum value of 
0.0001 guarantees that a point does not form a pair with itself. The argument
`cutoff` corresponds to the maximum separation distance up to which the 
lag-distance classes are defined. We recommend the cut-off to be set to half the 
maximum distance across the spatial domain.

The exponentially spaced lag-distance classes are used setting 
`lags.type = "exponential"`. The spacings are defined by the base $b$ of the
exponential expression $b^n$, where $n$ is the required number of lags. The base
is defined using the argument `lags.base`. For example, the default 
`lags.base = 2` creates lags that are sequentially defined as half of the
immediately preceding larger lag. If `cutoff = 100` and `lags = 4`, the limits
of the lag-distance classes will be as follows:

```r
> c(0.0001, rev(100 / (2 ^ c(1:4))))
[1]  0.0001  6.2500 12.5000 25.0000 50.0000
```

## Criteria

The main goal of our method is to produce a sample pattern with a uniform 
distribution of the number of points per lad-distance class (**PPL**). This 
can be achieved in our implementation setting `criterion = "distribution"`. 
Mathematically speaking, we minimize the sum of differences between a 
pre-specified wanted distribution and the observed distribution of points (or 
point-pairs, if `pairs = TRUE`) per lag-distance class. Consider that we aim at
having the following distribution of points per lag:

```r
> goal <- c(10, 10, 10, 10, 10)
```

and that the observed distribution of points per lag is as follows:

```r
> obs <- c(1, 2, 5, 10, 10)
```

The criterion value is:

```r
> sum(goal - obs)
[1] 22
```

The objective of the algorithm is, at each iteration, to match the two 
distributions, that is:

```r
> obs <- c(10, 10, 10, 10, 10)
> sum(goal - obs)
[1] 0

```

This criterion is of the same type as that proposed by WarrickEtAl1987. However,
the same objective can be achieved using another criterion, possibly less 
computationally demanding. We define it as maximizing the minimum number of
points (or point-pairs) observed over all lag-distance classes. It is used
setting `criterion = "minimum"`. Consider that we observe the following
distribution of points per lag in the first iteration:

```r
> obs <- c(1, 2, 5, 10, 10)
```

The objective in the second iteration will be to increase the number of points
in the first lag ($n = 1$). Consider that we then have the following resulting
distribution:

```r
> obs <- c(5, 2, 5, 10, 10)
```

Now the objective will be to increase the number of points in the second lag
($n = 2$). The optimization continues until it is not possible to increase the
number of points in any of the lags, that is, when:

```r
> obs <- c(10, 10, 10, 10, 10)
```

This shows that the result of using `criterion = "minimum"` is similar to that 
of using `criterion = "distribution"`. However, the resulting sample pattern can
be significantly different.

We expected to find significant differences in the running time of the algorithm
when using one criterion or another. This is because when we use 
`criterion = "distribution"` we have to perform one arithmetic operation 
(difference) for every lag and then compute the sum of the differences. Using 
`criterion = "minimum"` should be faster because we only have to search for the
smallest value in the vector of counts. After a few tests we concluded that the
difference is not significant, probably due to the limitations of R. Since 
`criterion = "distribution"` is a more sensitive criterion because it takes all
lags into account, convergence is likely to be attained with a smaller number
of iterations. This obviously also depends on the other parameters passed to the
algorithm. Our recommendation is to use `criterion = "distribution"`.

It is important to note that using `criterion = "distribution"` corresponds to a
*minimization* problem. On the other hand, using `criterion = "minimum"` 
corresponds to a *maximization* problem. We solve this inconsistency 
substituting the criterion that has to be maximized by its inverse. For
convenience we multiply the resulting value by a constant -- the wanted number
of points or point-pairs per lag. If we are aiming at the number of points per
lag, the objective function value $f_{points}$ is calculates as follows:

$$
f_{points} = \frac{n}{min(\mathbf{x}) + 1}
$$

where $n$ is the total number of sample points, and $\mathbf{x}$ is the vector 
of counts of points per lag-distance class. If we are aiming at the number of
point-pairs per lag, the objective function value $f_{pairs}$ is calculates as:

$$
f_{pairs} = \frac{l}{min(\mathbf{x}) + 1}
$$

where $l$ is the wanted number of point-pairs per lag-distance class, and
$\mathbf{x}$ is the vector of counts of point-pairs per lag-distance class. The
wanted number of point-pairs per lag $l$ is calculated as follows 
(WarrickEtAl1987):

$$
l = \frac{n \times (n - 1)}{2 \times nl}
$$

where $nl$ is the number of lag-distance classes. This procedure allows us to
define both problems as minimization problems.

## Utopia and nadir points

In theory, we should be able to calculate the exact utopia and nadir points of
**PPL**. If the objective is to have a uniform distribution of points (or 
point-pairs) per lag, the worst case scenario is to have all points (or 
point-pairs) in a single lag. The utopia point would be equal to zero, and 
the nadir point would be obtained directly by evaluating the wanted distribution
of points (or point-pairs) per lag.

However, there are many aspects that influence the definition of the utopia and
nadir points. The most important is the number of sample points. In general, the
larger the number of sample points, the larger the nadir point. This is because
the objective function is based on the number of points (or point-pairs) per 
lag. But the nadir point increases only up to a certain level because, as the
number of sample points increases it becomes more difficult to have all points
(or point-pairs) in the same lag.

The utopia point becomes closer to zero with the decrease of the number of
sample points. With a too large sample, it becomes more difficult to evenly
distribute the sample points (or point-pairs) among lags. This is specially
significant if the size of the lags is small, showing that there also is an
influence of the size of the various lag-distance classes.

A third element that must be considered is the size and shape of the spatial 
domain. First, because it is intimately related with the definition of the lags
and the amount of jittering allowed for every point. Second, because a sample 
can only be defined as large or small relative to the spatial domain. The third
influence of the spatial domain appears when the ratio between its major and 
minor axes is considerably large. This restricts the set of candidate locations
for the sample points, resulting in many lags not being large enough to 
accommodate the wanted number of points (or point-pairs).

# Example

We present an example using the `meuse` dataset contained in the R-package 
***sp*** (BivandEtAl2008).

```r
# load required packages and datasets
require(pedometrics)
require(spsann)
require(sp)
require(rgeos)
require(SpatialTools)
data(meuse.grid)
```

In this example we use the object `meuse.grid` to define the set of candidate 
locations for the sample points (`candi`). We also use the `meuse.grid` to
define the boundary of the spatial domain (`boundary`). Note that it is
necessary to add a column to `candi` with the indexes of each candidate 
location.

```r
# Candidate locations and boundary
candi <- meuse.grid[, 1:2]
coordinates(candi) <- ~ x + y
gridded(candi) <- TRUE
boundary <- as(candi, "SpatialPolygons")
boundary <- gUnionCascaded(boundary)
candi <- coordinates(candi)
candi <- matrix(cbind(1:nrow(candi), candi), ncol = 3)
```

We now set the arguments that have to be passed to the function `optimPPL()`.
The maximum jittering in the x and y coordinates is defined using the bounding
box of the spatial domain. This means that the values attributed to each 
coordinate are not necessarily the same. The minimum jittering for both
coordinate is defined as equal to the grid spacing. The cut-off is set to half 
the diagonal of the bounding box of the spatial domain.

```r
# Other settings
x.max <- diff(bbox(boundary)[1, ])
y.max <- diff(bbox(boundary)[2, ])
x.min <- 40
y.min <- 40
cutoff <- sqrt((x.max * x.max) + (y.max * y.max)) / 2
iterations <- 1000
points <- 100
lags <- 7
lags.base <- 2
criterion <- "distribution"
lags.type <- "exponential"
pairs <- FALSE
```

We use seven exponentially spaced lag-distance classes, sequentially defined as
half the immediately larger preceding lag. Our goal is to have a uniform
distribution of points per lag and use 1000 iterations to let the algorithm
achieve it. We define the random seed so that we can reproduce the results.

```r
# Run the algorithm
set.seed(2001)
res <- optimPPL(points = points, candi = candi, lags = lags, pairs = pairs,
                lags.base = lags.base, criterion = criterion, cutoff = cutoff,
                lags.type = lags.type,  x.max = x.max, x.min = x.min, 
                y.max = y.max, y.min = y.min, boundary = boundary,
                iterations = iterations)
```

There are two other important functions implemented in the ***spsann*** package:
`countPPL()`, which counts the number of points (or point-pairs) per lag, and
`objPPL()`, which computes the objective function value for a given sample
pattern. We see that the number of iterations was not enough to obtain an
uniform distribution of points per lag. There are only 65 points contributing
to the first lag class. The objective function value is somewhat high (65)
since we expected it to be close to zero.

```r
# Evaluate the results
countPPL(points = res, lags = lags, lags.type = lags.type, pairs = pairs,
         lags.base = lags.base, cutoff = cutoff)
  lag.lower lag.upper points
1    0.0001    40.625     65
2   40.6250    81.250     80
3   81.2500   162.500     92
4  162.5000   325.000     99
5  325.0000   650.000     99
6  650.0000  1300.000    100
7 1300.0000  2600.000    100
objPPL(points = res, lags = lags, lags.type = lags.type, pairs = pairs,
       lags.base = lags.base, cutoff = cutoff, criterion = criterion)
[1] 65
```
