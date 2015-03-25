# Random perturbation (jittering)

This function perturbs the coordinates of spatial points adding random noise,
a process also known as 'jittering'. There are two ways of jittering
the coordinates. They differ on how the the set of candidate locations is
defined.

## Finite set of candidate locations

**NOTE**: The current implementation does not enable to define the direction of
the perturbation, nor to perturb more than one point at a time.

The first method uses a finite set of candidate locations for the perturbed
points. This method usually is the fastest because it does not require the
use of complex routines to check if the perturbed point falls inside the
spatial domain. Since the candidate locations is a finite set, any perturbed
point will inexorably fall inside the spatial domain. This is a very
important feature in optimization exercises with complex objective functions
such as simulated annealing when repetitive perturbation is required.

The arguments `x.min`, `y.min`, `x.max`, and `y.max` are used to define a
rectangular window containing the set of effective candidate locations for the
point defined with the argument `which.point`. The new location is then
randomly sampled from the set of effective candidate locations and checked
against existing points to avoid duplicates.

## Infinite set of candidate locations

**NOTE**: The current version does not accept using an infinite set of
candidate locations.

The second method can be much slower than the first depending on the number of
points, on the shape of the area and on how the other arguments are set. This
method does not use a finite set of candidate locations. Instead, the number of
candidate locations is infinite. Its domain can be defined using the argument
`where`. The reason for the larger amount of time demanded is that the method
has two internal steps to 1) check if the perturbed point falls inside the
spatial domain, and b) check if two of more points have coincident coordinates
(set using argument `zero`). Using an infinite set of candidate locations will
usually allow obtaining better results in optimization exercises such as
spatial simulated annealing. However, the amount of time may be prohibitive
depending on the complexity of the problem.

The sub-argument `max` in both arguments `x.coord` and `y.coord` defines the
lower and upper limits of a uniform distribution:

```
runif(n, min = -max, max = max)
```

The quantity of noise added to the coordinates of the point being perturbed is
sampled from this uniform distribution. By default, the maximum quantity of
random noise added to the x and y coordinates is, respectively, equal to half
the width and height of the bounding box of the set of points. This is
equivalent to a vector **h** of length equal to half the diagonal of the
bounding box. Therefore, a larger jittering is allowed in the longer coordinate
axis (x or y).

The direction of the perturbation is defined by the sign of the values sampled
from the uniform distribution. This means that the perturbation can assume any
direction from 0 to 360 degrees. By contrast, the function `jitter2d()` in the
R-package **geoR** samples from a uniform distribution a value for the length
of the vector **h** and a value for the direction of the perturbation.

`spJitter()` allows to set the minimum quantity of random noise added to a
coordinate with the sub-argument `min`. The absolute difference between the
original coordinate value and the jittered coordinate value is used to evaluate
this constraint. If the constraint is not met, `min` receives the sign of the
value sample from the uniform distribution and is added to the original
coordinate value. This does not guarantee that the perturbation will be in the
same direction, but in the same quadrant.

When a spatial domain is defined, `spJitter()` evaluates if the perturbed
points fall inside it using the function \code{\link[rgeos]{gContains}} from
the R-package **rgeos**. All points falling outside the spatial domain are
identified and have their original coordinates jittered one again. Every new
coordinate falling inside the spatial domain is accepted. Every point falling
outside the spatial domain has its coordinates jittered till it falls inside
the spatial domain. The number of iterations necessary to meet this constraint
depends on the complexity of the shape of the spatial domain. `spJitter()`
tries to speed up the process by linearly decreasing the maximum quantity of
noise added to the coordinates at each iteration. If the number of iterations
was not enough to guarantee all points inside the spatial domain, `spJitter()`
returns the jittered SpatialPoints with a warning message informing how many
points do not meet the constraint.