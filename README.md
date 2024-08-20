# TMoPOFD: Trimmed Mean for Partially Observed Functional Data

This repository contains the simulation code for the **Trimmed Mean for Partially Observed Functional Data (TMoPOFD)**, based on the Partially Observed Integrated Functional Depth (POIFD) method.

## Overview

This software accompanies the paper titled *“Trimmed Mean for Partially Observed Functional Data”* by Yixiao Wang, which extends the work on the POIFD method. The work primarily references the following studies:

- **Integrated Depths for Partially Observed Functional Data**  
  *Authors*: A. Elías, R. Jiménez, A. M. Paganoni, L. M. Sangalli  
  *Journal*: Journal of Computational and Graphical Statistics (2022)  
  *DOI*: [10.1080/10618600.2022.2070171](https://doi.org/10.1080/10618600.2022.2070171)

- **Trimmed Means for Functional Data**  
  *Authors*: Ricardo Fraiman, Graciela Muniz  
  *Institutions*: Universidad de San Andrés, Buenos Aires, Argentina & Universidad de la República, Montevideo, Uruguay  
  *Year*: May 2001  
  *AMS 1980 Subject Classifications*: 62G07, 62G05

This code aims to define the trimmed mean for partially observed functional data using the POIFD method and to establish the strong convergence of this estimator.

### Mathematical Definition

The $\alpha$-trimmed mean for partially observed functions is defined as the mean of the $n - [n\alpha]$ deepest observed values. More precisely, for $\beta > 0$, the sample version of the trimmed mean is given by:

$$
\hat{\mu}_{n}(t) = \frac{\sum_{i=1}^{n} \mathbf{1}_{[\beta,+\infty)}\left(POIFD_{n}\left(X_{i}\right)\right)\mathbf{1}_{X_{i}(t)\text{ is observed}} X_{i}}{\sum_{i=1}^{n} \mathbf{1}_{[\beta,+\infty)}\left(POIFD_{n}\left(X_{i}\right)\right)\mathbf{1}_{X_{i}(t)\text{ is observed}}} ,
$$

where $\beta$ satisfies:

$$
\frac{1}{n} \sum_{i=1}^{n} \mathbf{1}_{[\beta,+\infty)}\left(POIFD_{n}\left(X_{i}\right)\right) \simeq 1-\alpha .
$$

## Test Usage

Below is an example of how to simulate data and plot the trimmed mean using this code:

```r
# Simulate the data
SimulateModel <- simulateModel(
  len = 200,
  p = 50,
  q = 0.3,
  M = 10,
  pollution_type = "asymmetric"
)

# Plot the data
plotTrimmedMean(data, alpha = 0.3, type = "FMD")
```
<img src="IMAGE/example.png" style="display: block; margin: auto;" />
