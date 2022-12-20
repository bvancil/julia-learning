using Revise
using Colors
using Distributions
using DataFrames
using Random
using VegaDatasets
using VegaLite

τ = 2π

function get_rectangles(rng, n)
    uniform = Uniform()
    return DataFrame([
        :r₀ => 0.5 .+ rand(rng, uniform, n),
        :r₀_offset => rand(rng, uniform, n),
        :r₁ => 0.7 .+ rand(rng, uniform, n),
        :r₁_offset => rand(rng, uniform, n),
        :θ₀ => τ * rand(rng, uniform, n),
        :θ₀_offset => τ * rand(rng, uniform, n),
        :θ₁ => τ * rand(rng, uniform, n),
        :θ₁_offset => τ * rand(rng, uniform, n),
        :shade => rand(rng, uniform, n),
        :size => rand(rng, uniform, n)
    ])
end


rng = MersenneTwister(20220926)
df = get_rectangles(rng, 10)

df |>
@vlplot(
    mark = :arc,
    radius2 = :r₀,
    radius2Offset = :r₀_offset,
    radius = :r₁,
    radiusOffset = :r₁_offset,
    theta = :θ₀,
    thetaOffset = :θ₀_offset,
    theta2 = :θ₁,
    theta2Offset = :θ₁_offset,
    color = {:shade, legend = nothing},
    opacity = {0.2}
)
