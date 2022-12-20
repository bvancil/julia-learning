using Plots
theme(:default)
τ = 2π
domain = LinRange(0, τ, 100)


plot(
    domain,
    sin.(domain),
    title="Harmonic motion",
    xlabel="time (s)",
    ylabel="distance (m)",
    label="sin(t)",
    xticks=([0, τ / 4, τ / 2, 3τ / 4, τ], ["0", "τ/4", "τ/2", "3τ/4", "τ"]),
    legend=:bottomleft
)
plot!(
    domain,
    cos.(domain),
    label="cos(t)"
)

using RDatasets
using DataFrames

iris = dataset("datasets", "iris")

first(iris, 10)

theme(:ggplot2)
scatter(
    iris.SepalLength,
    iris.SepalWidth,
    xlabel="sepal length [cm]",
    ylabel="sepal width [cm]",
    group=iris.Species,
    markercolor=[:firebrick :lightseagreen :magenta],
    markersize=iris.PetalWidth * 10,
    alpha=0.25
)

