#' Generate Partially Observed Functional Data
#'
#' This example uses a linear function accompanied by Gaussian noise.
#'
#' @param len The number of grid points.
#' @param p The number of functional curves.
#' @param q The probability of the binomial distribution used to generate noise.
#' @param M The magnitude of the noise.
#' @param pollution_type The type of contamination model to be selected, which includes symmetric contamination model, unidirectional contamination model, and partial contamination model.
#'
#' @return Returns the customized partially observable contamination model.
#'
#' @examples
#' data(exampleData)
#' data <- exampleData$PoFDintervals
#' SimulateModel <- simulateModel(len = len, p = p, q = q, M = M, alpha = alpha, pollution_type = pollution_type, observability = observability)
#' @import library(MASS) 
#' @export

simulateModel <- function(len, p, q, M, pollution_type = "symmetric") {
  # 高斯随机过程的协方差函数
  covariance_func <- function(t, s, p) {
    return ((1/2)^(abs(t-s)*p))
  }
  
  # 生成协方差矩阵
  generate_cov_matrix <- function(len, p) {
    s <- seq(0, 1, length.out = len)
    cov_matrix <- matrix(NA, nrow = len, ncol = len)
    for (i in 1:len) {
      for (j in 1:len) {
        cov_matrix[i, j] <- covariance_func(s[i], s[j], p)
      }
    }
    return(cov_matrix)
  }
  
  # 生成高斯随机过程
  generate_gaussian_process <- function(len, p) {
    cov_matrix <- generate_cov_matrix(len, p)
    gp <- mvrnorm(n=1, mu=rep(0, len), Sigma=cov_matrix)
    return(gp)
  }
  
  # 生成数据
  # 需要指定p的值
  data <- sapply(1:p, function(x) {
    t <- seq(0, 1, length.out = 200)
    term1 <- 4 * sin(t*10)
    term2 <- generate_gaussian_process(200, p)
    return(term1 + term2)
  })
  
  # 生成εi和σi的序列
  generate_epsilon_sigma <- function(len, q) {
    epsilon <- rbinom(len, size = 1, prob = q) # 以概率q生成二项分布随机变量
    sigma <- sample(c(-1, 1), len, replace = TRUE) # 以概率1/2随机选取1或-1
    return(list(epsilon = epsilon, sigma = sigma))
  }
  
  # 对称污染模型
  generate_Y_symmetric <- function(data, p, q, M) {
    Y <- data
    es_seq <- generate_epsilon_sigma(len = p, q = q)
    epsilon <- es_seq$epsilon
    sigma <- es_seq$sigma
    for (i in 1:p) {
      if (epsilon[i] == 1) {
        Y[,i] <- Y[,i] + sigma[i] * M
      }
    }
    return(Y)
  }
  
  # 单向污染模型
  generate_Y_asymmetric <- function(data, p, q, M) {
    Y <- data
    es_seq <- generate_epsilon_sigma(len = p, q = q)
    epsilon <- es_seq$epsilon
    for (i in 1:p) {
      if (epsilon[i] == 1) {
        Y[,i] <- Y[,i] + M
      }
    }
    return(Y)
  }
  # 部分污染模型
  generate_Y_partial <- function(data, p, q, M) {
    Y <- data
    es_seq <- generate_epsilon_sigma(len = p, q = q)
    epsilon <- es_seq$epsilon
    sigma <- es_seq$sigma
    Time = round(runif(n, min = 1, max = len-1))
    for (i in 1:p) {
      if (epsilon[i] == 1) {
        Y[, i][Time:length(Y[, i])] <- Y[, i][Time:length(Y[, i])] + sigma[i] * M
      }
    }
    return(Y)
  }
  
  # 根据选择的污染类型设置Y
  Y <- switch(
    pollution_type,
    "symmetric" = generate_Y_symmetric(data = data, p = p, q = q, M = M),
    "asymmetric" = generate_Y_asymmetric(data = data, p = p, q = q, M = M),
    "partial" = generate_Y_partial(data = data, p = p, q = q, M = M),
    stop("Invalid pollution type")
  )
  
  return (Y)
}