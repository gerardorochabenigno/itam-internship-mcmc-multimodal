// data
data {
  int<lower=1> T;  // number of observations
  int<lower=1> m;  // number of states
  array[T] real y;  // observations, y coincides with the name in stan_data
}

// parameters
parameters{
    ordered[m] mu;                      // means of state dependent distributions (now is a ordered array)
    array[m] real <lower=0> sigma;      // standard deviation of state dependent distributions
    array[m] simplex[m] gamma;          // rows of Gamma, gamma[i] is the i-th row 
    
}

// transformed parameters
transformed parameters{
    matrix[m,m] Gamma;
    row_vector<lower=0, upper=1>[m] delta;


    for (i in 1:m){
        Gamma[i] = gamma[i]';
    }
    delta = rep_row_vector(1, m)/(identity_matrix(m) - Gamma + rep_matrix(1,m,m));
}

// model
model{

    vector[m] log_alpha;

    // Prior of the means
    mu ~ normal(0,5);

    // Prior of the deviation
    sigma ~ normal(0,2); // Restriction on sigma guarantees this is half normal

    // Prior of Gamma
    for (i in 1:m){
        gamma[i] ~ dirichlet(rep_vector(1,m));
    }

    // initialize forward log-weights
    for (j in 1:m) {
        log_alpha[j] = log(delta[j]) + normal_lpdf(y[1] | mu[j], sigma[j]);
    }

    // Verosimilitud
    for (t in 2:T){
        vector[m] log_alpha_new;
        for (j in 1:m){
            log_alpha_new[j] = log_sum_exp(log_alpha + log(Gamma[, j])) + normal_lpdf(y[t] | mu[j], sigma[j]);
        }
        log_alpha = log_alpha_new;        
    }
    target += log_sum_exp(log_alpha);
}