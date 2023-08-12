functions {
    // define function which describes the ODE system
       vector ode1(real t, vector y, vector theta) {
            vector[2] dydt;
            real T = y[1];
            real C = y[2];
            real dCdt;
            if (t < 2024) {
                dCdt = theta[3] * exp(theta[4] * (t-1958));
            }
            else {
                dCdt = theta[3] * exp(theta[4] * (2024-1958) - 0.005 * (t-2024));
            }
            dydt[1] = theta[1] * dCdt + theta[2] * C;
            dydt[2] = dCdt;
            return dydt;
    }
}

data {
    // any external data that is needed 
    int<lower = 1> N;
    int<lower = 1> L;
    real years[N];
    real new_years[L];
    vector[N] co2;
    vector[N] temp;
    vector[2] y0;
    real t0;
}

parameters {
    // any parameters in the model
    vector[4] theta; // alpha, beta, gamma, phi stored in this vector
    vector[2] init; // the initial value of the CO2 and temp
    real<lower=0> sigma_temp;
    real<lower=0> sigma_co2;
}

transformed parameters {
    // the mean temperature and co2 is represented as the soln 
    // to the ODE system described above
    vector[2] mu[N] = ode_rk45(ode1, init, t0, years, theta);
}


model {
    //priors on parameters
    //use least squares estimates as the mean
    //parameter value and assume normally distributed priors
    theta[1] ~ normal(0.029, 0.005);
    theta[2] ~ normal(-7.89e-5, 1e-5);
    theta[3] ~ normal(0.875, 0.1);
    theta[4] ~ normal(0.018, 0.005);
    sigma_temp ~ normal(0, 0.1);
    sigma_co2 ~ normal(0, 3.5);
    init ~ normal(y0, [0.05, 0.5]);

    //model specification
    temp ~ normal(mu[, 1], sigma_temp);
    co2 ~ normal(mu[, 2], sigma_co2);
}

generated quantities {
   //sample mu for each year numerous times to get a credible interval 
   vector[2] model_output[L];
   model_output = ode_rk45(ode1, init, t0, new_years, theta);
}

