# Evaluation of the use of the number of points per lag distance-class as a
# criterion to optimize sample configurations for variogram estimation
rm(list = ls())

require(spsann)
require(sp)
require(rgeos)

# Generate the spatial domain and sampling/prediction grid
nx <- ny <- 100
s1 <- 1:nx
s1 <- s1 - 0.5
s2 <- s1
candi <- expand.grid(s1 = s1, s2 = s2)
plot(candi, asp = 1, pch = 0)

# Optimize the sample configurations
coordinates(candi) <- ~ s1 + s2
gridded(candi) <- TRUE
boundary <- as(candi, "SpatialPolygons")
boundary <- gUnionCascaded(boundary)
candi <- coordinates(candi)
candi <- matrix(cbind(1:nrow(candi), candi), ncol = 3)
x.max <- diff(bbox(boundary)[1, ])
y.max <- diff(bbox(boundary)[2, ])
cutoff <- sqrt((x.max * x.max) + (y.max * y.max)) / 2

# Points per lag
set.seed(2001)
sample_a <- optimPPL(points = 50, candi = candi, cutoff = cutoff, lags = 6,
                     x.max = x.max, x.min = 2, y.max = y.max, y.min = 2,
                     boundary = boundary, iterations = 50000, plotit = FALSE,
                     verbose = FALSE)

# Point-pairs per lag
set.seed(2001)
sample_b <- optimPPL(points = 50, candi = candi, cutoff = cutoff, lags = 6,
                     x.max = x.max, x.min = 2, y.max = y.max, y.min = 2,
                     boundary = boundary, iterations = 50000, plotit = FALSE,
                     pairs = TRUE, verbose = FALSE)

# Random sample
sample_c <- as.data.frame(spsample(x = boundary, n = 50, type = "random"))
id <- 1:nrow(sample_c)
sample_c <- cbind(id, sample_c)
sample_c <- as.matrix(sample_c)

# Systematic sample
sample_d <- as.data.frame(spsample(x = boundary, n = 50, type = "regular"))
id <- 1:nrow(sample_d)
sample_d <- cbind(id, sample_d)
sample_d <- as.matrix(sample_d)

# Evaluate the resulting samples (points per lag)
aa <- countPPL(points = sample_a, candi = candi, lags = 6, cutoff = cutoff)
bb <- countPPL(points = sample_b, candi = candi, lags = 6, cutoff = cutoff)
cc <- countPPL(points = sample_c, candi = candi, lags = 6, cutoff = cutoff)
dd <- countPPL(points = sample_d, candi = candi, lags = 6, cutoff = cutoff)
points_res <- data.frame(lowwer = aa[, 1], upper = aa[, 2], points = aa[, 3],
                         pairs = bb[, 3], random = cc[, 3], regular = dd[, 3])
rm(aa, bb, cc, dd)
points_res

# Evaluate the resulting samples (point-pairs per lag)
aa <- countPPL(sample_a, candi = candi, lags = 6, cutoff = cutoff, pairs = TRUE)
bb <- countPPL(sample_b, candi = candi, lags = 6, cutoff = cutoff, pairs = TRUE)
cc <- countPPL(sample_c, candi = candi, lags = 6, cutoff = cutoff, pairs = TRUE)
dd <- countPPL(sample_d, candi = candi, lags = 6, cutoff = cutoff, pairs = TRUE)
pairs_res <- data.frame(lowwer = aa[, 1], upper = aa[, 2], points = aa[, 3],
                        pairs = bb[, 3], random = cc[, 3], regular = dd[, 3])
rm(aa, bb, cc, dd)
pairs_res

# Plot samples
par(mfrow = c(2, 2))
plot(boundary)
points(sample_a[, 2:3], cex = 0.5, pch = 20)
plot(boundary)
points(sample_b[, 2:3], cex = 0.5, pch = 20)
plot(boundary)
points(sample_c[, 2:3], cex = 0.5, pch = 20)
plot(boundary)
points(sample_d[, 2:3], cex = 0.5, pch = 20)

# Define variogram models according to Lark (2002)
model <- "exponential"
range <- c(10, 30, 50)
p_sill <- c(0.1, 0.5, 0.9)
models <- cbind(model = rep(model, 9),
                expand.grid(p_sill = p_sill, range = range))
models$nugget <- 1 - models$p_sill
models$model <- as.character(models$model)

# Simulate realities
require(geoR)
sim_real <- list()
n <- nrow(candi)
for (i in 1:nrow(models)) {
  set.seed(2001)
  sim_real[[i]] <- grf(n = n, grid = candi[, 2:3], cov.model = models[i, 1],
                       cov.pars = as.numeric(models[i, 2:3]),
                       nugget = as.numeric(models[i, 4]))
}
par(mfrow = c(3, 3))
for (i in 1:length(sim_real)) {
  image(sim_real[[i]])
}

# Sample simulated realities

 




