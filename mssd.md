# Mean squared shortest distance - MSSD

## Distances

Euclidean distances between points are calculated. This computation requires
the coordinates to be projected. The user is responsible for making sure that
this requirement is attained.

## Matrix of distances

Calculating the matrix of Euclidean distances between all sample points and all
prediction locations is computationally expensive. As such, the full matrix of
distances is calculated only once for the initial system configuration before
the first iteration. At each iteration, only the distance between the new
sample point and all prediction locations is calculated. This numeric vector is
used to replace the column of the matrix of distances which contained the
distances between the old jittered sample point and all prediction locations.
The mean squared shortest distance of the new system configuration is then
calculated using the updated matrix of distances. The whole procedure is done
at the C++-level to speed-up the computation.

## Utopia and nadir points

The MSSD is a bi-dimensional criterion because it explicitly takes
into account both y and x coordinates. It aims at the spread of points in
the geographic space. This is completely different from the number of points
per lag distance class which is an uni-dimensional criterion -- it aims
at the spread on points in the variogram space. It is more difficult to
calculate the utopia and nadir points of a bi-dimensional criterion.

The **utopia** ($f^{\circ}_{i}$) point of MSSD is only known to be larger than
zero. It could be approximated using the k-means algorithm, which is much
faster than spatial simulated annealing, but does not guarantee to return the
true utopia point. The **nadir** ($f^{max}_{i}$) point is obtained when all
sample points are clustered in one of the "corners"" of the spatial domain.
This cannot be calculated and has to be approximated by simulation or using the
knowledge of the diagonal of the spatial domain (the maximum possible distance
between two points).

One alternative strategy is to first optimize a set of sample points using the
MSSD as criterion and then create geographic strata. In the multi-objective
optimization one would then have to define an unidimensional criterion aiming
at matching the optimal solution obtained by the minimization of the MSSD. One
such uni-dimensional criterion would be the difference between the expected
distribution and the observed distribution of sample points per geographic
strata. This criterion would aim at having at least one point per geographic
strata -- this is similar to optimizing sample points using the number of
points per lag distance class.

A second uni-dimensional criterion would be the difference between the expected
MSSD and the observed MSSD. This criterion would aim at having the points
coinciding with the optimal solution obtained by the minimization of the MSSD.
In both cases the utopia point would be exactly zero ($f^{\circ}_{i} = 0$). The
nadir point could be easily calculated for the first uni-dimensional criterion,
but not for the second.