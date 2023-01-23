using Distributions
using StatsPlots

proportion(xs) = xs ./ sum(xs)

size = 20
p_grid = range(0.0, 1.0, length=size)
prior = p_grid .>= 0.5

function posterior(n_water, n_total, p_grid, prior)
    likelihood = [pdf(Binomial(n_total, p), n_water) for p in p_grid]
    unstd_posterior = likelihood .* prior
    proportion(unstd_posterior)
end

posterior1 = posterior(3, 3, p_grid, prior)
posterior2 = posterior(3, 4, p_grid, prior)
posterior3 = posterior(5, 7, p_grid, prior)

plot(
    p_grid, 
    posterior1; 
    xlabel="probability of water", 
    ylabel="posterior probability",
    title="Q1 ($size points)",
    markershape=:circle
)

plot(
    p_grid, 
    posterior2; 
    xlabel="probability of water", 
    ylabel="posterior probability",
    title="Q2 ($size points)",
    markershape=:circle
)

plot(
    p_grid, 
    posterior3; 
    xlabel="probability of water", 
    ylabel="posterior probability",
    title="Q3 ($size points)",
    markershape=:circle
)
