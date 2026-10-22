// data
data {
  int<lower=1> T;   // number of observations
  int<lower=1> m;   // number of states
  array[T] real y;  // observations
}

// parameters
parameters {
  ordered[m] mu;                  // means of the state-dependent distributions
  array[m] real<lower=0> sigma;   // standard deviations of the state-dependent distributions
  array[m] simplex[m] gamma;      // rows of Gamma, gamma[i] is the i-th row
}

// transformed parameters
transformed parameters {
  matrix[m, m] Gamma;
  row_vector[m] delta;

  for (i in 1:m) {
    Gamma[i] = gamma[i]';
  }
  delta = rep_row_vector(1, m) / (identity_matrix(m) - Gamma + rep_matrix(1, m, m));
}

// model
model {
  matrix[m, T] log_omega;  // log densities of each observation under each state

  // Priors
  mu ~ normal(0, 5);
  sigma ~ gamma(2, 0.5);  // shape 2 and rate 0.5, vanishes at zero
  for (i in 1:m) {
    gamma[i] ~ dirichlet(rep_vector(1, m));
  }

  // State-dependent log densities
  for (t in 1:T) {
    for (j in 1:m) {
      log_omega[j, t] = normal_lpdf(y[t] | mu[j], sigma[j]);
    }
  }

  // Likelihood through the forward algorithm
  target += hmm_marginal(log_omega, Gamma, delta');
}