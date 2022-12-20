using Random

using CategoricalArrays
using DataFrames
# Bogumił Kamiński

n = 100
rng = Random.MersenneTwister(20220704)

df = DataFrames.DataFrame(
    ch1=rand(rng, "ABC", n),
    ch2=rand(rng, "XYZ", n),
    bool1=rand(rng, Bool, n),
    unif1=rand(rng, Float64, n),
    norm1=Random.randn(rng, Float64, n),
    norm2=Random.randn(rng, Float64, n),
    exp1=Random.randexp(rng, Float64, n),
    n1=rand(rng, 1:4, n),
    cat1=CategoricalArrays.categorical(rand(rng, [missing, "Male", "Female", "Non-binary", "Other"], n)),
)

@show df
