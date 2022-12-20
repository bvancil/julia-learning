using CSV, GLM, Plots, TypedTables

data = CSV.File("./Julia for Talented Amateurs/Series 05/housingdata.csv")

X = data.size
Y = round.(Int, data.price / 1000)
t = Table(X=X, Y=Y)

gr(size=(600, 600))
p_scatter = scatter(X, Y,
    xlims=(0, 5000),
    ylims=(0, 800),
    xlabel="Size (ft²)",
    ylabel="Price (k\$\$)",
    title="Housing Prices in Portland",
    legend=false,
    color=:red
)

ols = lm(@formula(Y ~ X), t)

plot!(X, predict(ols), color=:green, linewidth=3)

newX = Table(X=[1250])
predict(ols, newX)

# ML approach

epochs = 0
gr(size=(600, 600))
p_scatter = scatter(X, Y,
    xlims=(0, 5000),
    ylims=(0, 800),
    xlabel="Size (ft²)",
    ylabel="Price (k\$\$)",
    title="Housing Prices in Portland (epochs = $epochs)",
    legend=false,
    color=:red
)
theta_0 = 0.0 # intercept
theta_1 = 0.0 # slope

h(x) = theta_0 .+ theta_1 * x

plot!(X, h(X), color=:blue, linewidth=3)

m = length(X)
y_hat = h(X)

function cost(X, Y)
    (1 / (2 * m)) * sum((y_hat - Y) .^ 2)
end

J = cost(X, Y)

J_history = []

push!(J_history, J)

function pd_theta_0(X, Y)
    (1 / m) * sum(y_hat - Y)
end

function pd_theta_1(X, Y)
    (1 / m) * sum((y_hat - Y) .* X)
end

alpha_0 = 9.0e-2
alpha_1 = 8.0e-8

# Repeat here
theta_0_temp = pd_theta_0(X, Y)
theta_1_temp = pd_theta_1(X, Y)

theta_0 -= alpha_0 * theta_0_temp
theta_1 -= alpha_1 * theta_1_temp

y_hat = h(X)
J = cost(X, Y)
push!(J_history, J)

epochs += 1
plot!(X, y_hat, color=:blue, alpha=0.5,
    title="Housing Prices in Portland (epochs = $epochs)"
)

# Repeat

gr(size=(600, 600))
p_line = plot(0:epochs, J_history,
    xlabel="Epochs",
    ylabel="Cost",
    title="Learning Curve",
    legend=false,
    color=:blue,
    linewidth=2
)

