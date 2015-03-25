# Spatial simulated annealing

## Search graph

The search graph corresponds to the set of effective candidate locations for
a point being jittered in a given iteration. The size of the search graph,
i.e. the maximum distance that a point can be moved around, is correlated
with the concept of **temperature**. A larger search graph is equivalent
to higher temperatures, which potentially result in more movement or
"agitation"" of the set of points or "particles".

The current implementation of spatial simulated annealing uses a
**linear cooling schedule** depending upon the number of iterations to
control the size of the search graph. The equations are as follows:

```
x.max.b <- x.max.a - k / iterations * (x.max.a - x.min)
y.max.b <- y.max.a - k / iterations * (y.max.a - y.min)
```

where `x.max.a` and `y.max.a` are the maximum allowed shift in the
x and y coordinates in the current iteration, `x.min` and `y.min`
are the minimum required shift in the x and y coordinates, and `x.max.b`
and `y.max.b` are the maximum allowed shift in the x and y coordinates
in the next iteration. `iterations` is the total number of iterations
and `k` is the current iteration.

## Acceptance probability

The acceptance probability is the chance of accepting a new system
configuration that is worse than the current system configuration. The
concept of acceptance probability is related with that of
**temperature**. A higher acceptance probability is equivalent to higher
temperatures, which potentially result in more movement or
"agitation"" of the set of points or "particles".

Using a low initial acceptance probability turns the spatial simulated
annealing into a *greedy* algorithm. It will converge in a shorter time,
but the solution found is likely to be a local optimum instead of the global
optimum. Using a high initial acceptance probability ($>0.8$) usually is
the wisest choice.

An **exponential cooling schedule** depending upon the number of
iterations is used in the current implementation of the spatial simulated
annealing to control the acceptance probability. The acceptance probability
at each iteration is calculates as follows:

```
actual_prob <- acceptance$initial * exp(-k / acceptance$cooling)
```

where `actual_prob` is the acceptance probability at the `k`-th
iteration, `acceptance$initial` is the initial acceptance probability,
and `acceptance$cooling` is the exponential cooling factor.

## Starting system configuration

Unidimensional criterion such as the number of points per lag distance class
are dependent on the starting system configuration by definition. This means
that, depending on the parameters passed to the spatial simulated annealing
algorithm, many points will likely to stay close to their starting positions.
It would be reasonable to use a starting system configuration that is close
to the global optimal, but such thing is not feasible.

Increasing the initial acceptance probability does not guarantee the
independence from the starting system configuration. The most efficient
option in the current implementation of the spatial simulated annealing
algorithm is to start using the entire spatial domain as search graph. This
is set using the interval of the x and y coordinates to set `x.max`
and `y.max` (See above).

An alternative is to start jittering (randomly perturbing) several points at
a time and use a cooling schedule to **exponentially** decrease the
number of points jittered at each iteration. The current implementation of
the spatial simulated annealing does not explore such alternative. The
cooling schedule would be as follows:

```
new.size <- round(c(old.size - 1) * exp(-k / size.factor) + 1)
```

where `old.size` and `new.size` are the number of points jittered
in the previous and next iterations, `size.factor` is the cooling
parameter, and `k` is the number of the current iteration. The larger
the difference between the starting system configuration and the global
optimum, the larger the number of points that would need to be jittered in
the first iterations. This will usually increase the time spent on the first
iterations.

## Number of iterations

The number of iterations has a large influence on the performance of the
spatial simulated annealing algorithm. The larger the number of possible
system configurations, the higher should the number of iterations be.

The number of possible system configurations increases with:

* a high initial acceptance probability
* the use of an infinite set of candidate locations
* the use of a very dense finite set of candidate locations

## Objective functions

Here we provide a description of the implementation of the objective functions
in \strong{spsann}. We also describe the utopia and nadir points, which can
help in the construction of multi-objective optimization problems.