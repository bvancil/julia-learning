p_W_given_Earth = 0.7
p_L_given_Earth = 1 - p_W_given_Earth
p_W_given_Mars = 0
p_L_given_Mars = 1 - p_W_given_Mars
prior_Earth = 0.5
prior_Mars = 0.5
proportion(xs) = xs ./ sum(xs)
posterior_Earth_given_L = proportion(
    [p_L_given_Earth p_L_given_Mars]
    .*
    [prior_Earth prior_Mars]
)[1]
