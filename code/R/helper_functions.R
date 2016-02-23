# Function to simulate realities
simulate_realities <-
  function (models, grid, cov.model, cov.pars, nugget, seed = 2001) {
    sim_real <- list()
    n <- nrow(candi)
    for (i in 1:nrow(models)) {
      set.seed(seed)
      sim_real[[i]] <- grf(n = n, grid = grid, cov.model = models[i, 1], 
                           cov.pars = as.numeric(models[i, 2:3]),
                           nugget = as.numeric(models[i, 4]))
    }
    return (sim_real)
  }
# Function to plot the simulated realities
plot_simulate_realities <-
  function (realities) {
    values <- sapply(1:length(realities), function (i) {realities[[i]]$data})
    coords <- realities[[1]]$coords
    realities <- data.frame(coords, values)
    cn <- paste("field", 1:c(ncol(realities) - 2), sep = "")
    colnames(realities) <- c("x", "y", cn)
    coordinates(realities) <- c("x", "y")
    gridded(realities) <- TRUE
    res <- spplot(realities, xlab = "Partial Sill (0.1, 0.5, 0.9)", 
                  ylab = "Range (5, 50, 500)")
    return (res)
  }
# Function to optimize many sample configurations
optim_many_samples <- 
  function (pts, lags, iter, n = 3, seed = 2000, plotit = FALSE, 
            pairs = FALSE) {
    res <- list()
    for (i in 1:n) {
      set.seed(seed + i)
      res[[i]] <- optimPPL(points = pts, candi = candi, cutoff = cutoff, 
                           lags = lags, x.max = x.max, x.min = sqrt(2), 
                           y.max = y.max, y.min = sqrt(2), boundary = boundary,
                           iterations = iter, plotit = plotit, verbose = FALSE,
                           pairs = pairs)
    }
    return (res)
  }
# Function to create many samples using spsample
many_spsamples <-
  function (pts, n = 3, seed = 2000, type = "random", boundary) {
    res <- list()
    for (i in 1:n) {
      set.seed(seed + i)
      res[[i]] <- as.data.frame(spsample(x = boundary, n = pts, type = type))
      id <- 1:nrow(res[[i]])
      res[[i]] <- cbind(id, res[[i]])
      res[[i]] <- as.matrix(res[[i]])
    }
    return (res)
  }
# Function to evaluate the resulting samples regarding the number of points 
# or point-pairs per lag
check_samples <-
  function (samples, id = c("points", "pairs", "random", "systematic"), ...) {
    n <- length(samples[[1]])
    n <- c(1:2, 1:n * 3)
    
    res <- lapply(1:length(samples), function (i) {
      res <- lapply(samples[[i]], countPPL, ...)
    })
    res <- lapply(res, function (x) {
      do.call(cbind, x)
    })
    res <- lapply(1:length(res), function (i) {
      res[[i]][, n]
    })
    names(res) <- id
    return (res)
  }
# Function to plot the samples
plot_samples <-
  function (samples, n, phd = FALSE) {
    n1 <- length(samples)
    samples <- unlist(samples, recursive = FALSE)
    n2 <- length(samples)
    n3 <- sapply(samples, nrow)
    samples <- do.call(rbind, samples)
    type <- rep(c("points", "point-pairs", "random", "systematic"), 
                each = n2 / n1)
    type <- unlist(sapply(1:length(type), function (i) {rep(type[i], n3[i])}))
    repet <- rep(LETTERS[1:c(n2 / n1)], n1)
    repet <- unlist(sapply(1:length(repet), 
                           function (i) {rep(repet[i], n3[i])}))
    samples <- data.frame(samples[, -1], type, repet)
    if (phd) { # PhD thesis defence
      xyplot(y ~ x | type, data = as.data.frame(samples), pch = 20, 
             subset = repet == "B",
             cex = 0.2, ylim = c(0, 500), xlim = c(0, 500),
             xlab = NULL, ylab = NULL, 
             scales = list(draw = FALSE),
             # main = paste("n = ", n, sep = ""), 
             aspect = "iso") 
    } else {
      xyplot(y ~ x | type + repet, data = as.data.frame(samples), pch = 20, 
             cex = 0.2, ylim = c(0, 500), xlim = c(0, 500),
             xlab = NULL, ylab = NULL, 
             scales = list(draw = TRUE),
             # main = paste("n = ", n, sep = ""), 
             aspect = "iso")  
    }
  }
# Function to plot the distribution of points (or point-pairs per lag)
plot_ppl_distribution <- 
  function (samples, lags, cutoff, candi, pairs = FALSE, ...) {
    dat <- check_samples(samples = samples, lags = lags, cutoff = cutoff, 
                         candi = candi, pairs = pairs)
    cn <- rep(names(dat), each = nrow(dat[[1]]))
    dat <- do.call(rbind, dat)
    dat <- as.vector(t(dat[, 3:5]))
    type <- rep(c("point", "pairs", "random", "systematic"), each = 3 * 7)
    lag <- rep(rep(1:7, each = 3), 4)
    dat <- data.frame(n = dat, type, lag)
    res <- bwplot(lag ~ n | type, data = dat, ...)
    return (res)
  }
# Function to sample the simulated realities
sample_simulated_realities <- 
  function (samples, realities) {
    tmp <- lapply(samples, function (x) {
      sapply(1:length(realities), function (i) realities[[i]]$data[x[, 1]])
    })
    res <- lapply(1:length(samples), function (i) {
      cbind(samples[[i]], tmp[[i]])
    })
    return (res)
  }
# Function to calibrate the linear mixed models
calibrate_lmm <-
  function (samples, ini.cov.pars = c(0.5, 25), fix.nugget = FALSE,
            nugget = c(0, 0.5, 1), lik.method = "REML") {
    res <- lapply(samples, function (x) {
      sam <- lapply(4:ncol(x), function (i) {
        likfit(geodata = list(coords = x[, 2:3], data = x[, i]),
               ini.cov.pars = ini.cov.pars, fix.nugget = fix.nugget, 
               nugget = nugget, lik.method = lik.method)
      })
      sam <- t(sapply(sam, function (x) x[c(4, 5, 2)]))
    })
    id <- rep(1:length(samples), each = nrow(res[[1]]))
    res <- cbind(id, do.call(rbind, res))
    return (res)
  }
# Function to plot the estimated nugget variance
plot_nugget <- 
  function (data, n = 49) {
    xyplot(nugget.1 ~ nugget | sample + as.factor(range), data = data, 
           pch = 20, scales = list(relation = "free"), ylab = "Estimated", 
           xlab = "True", main = paste("Nugget (n = ", n, ")", sep = ""),
           panel = function(...) {
             panel.xyplot(...)
             panel.abline(a = 0, b = 1)
           })
  }
# Function to plot the estimated partial sill
plot_partial_sill <- 
  function (data, n = 49) {
    xyplot(sigmasq ~ p_sill | sample + as.factor(range), data = data, 
           pch = 20, scales = list(relation = "free"), ylab = "Estimated", 
           xlab = "True", main = paste("Partial sill (n = ", n, ")", sep = ""),
           panel = function(...) {
             panel.xyplot(...)
             panel.abline(a = 0, b = 1)
           })
  }
# Function to plot the estimated range
plot_range <- 
  function (data, n = 49) {
    xyplot(phi ~ range | sample + as.factor(c(p_sill / c(nugget + p_sill))),
           data = data, pch = 20, scales = list(relation = "free"), 
           ylab = "Estimated", xlab = "True", 
           main = paste("Range (n = ", n, ")", sep = ""),
           panel = function(...) {
             panel.xyplot(...)
             panel.abline(a = 0, b = 1)
           })
  }
