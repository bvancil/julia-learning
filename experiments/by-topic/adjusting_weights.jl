using Random
using StatsBase
import StatsBase

n_samples = 10000
sample_space = 1:10
weights_base = uweights(length(sample_space))

rng = MersenneTwister(20221223)

reference = sample(rng, sample_space, weights_base, n_samples)
println(countmap(reference))

StatsBase.@weights AdjustingWeights

@doc """
    AdjustingWeights(vs, wsum=sum(vs))

Construct an `AdjustingWeights` vector with weight values `vs`.
A precomputed sum may be provided as `wsum`.

Adjusting weights describe a non-random relative importance (usually between 0 and 1)
for each observation. As the weights are sampled, they adjust to reduce samples already produced,
giving a generalization of sampling without replacement.


""" AdjustingWeights

adjweights(vs::AbstractVector{<:Real}) = AdjustingWeights(vs)
adjweights(vs::AbstractArray{<:Real}) = AdjustingWeights(vect(vs))

function StatsBase.sample(
    rng::AbstractRNG, sample_space::AbstractArray{T}, weights::AdjustingWeights, 
    n_samples::Integer;
    nudge_factor::Float64 = 1.0
) where T
    correction = let    
        event_rate = 1 / length(weights)
        event_rate * nudge_factor - 1e-4
    end
    target_weights = weights ./ sum(weights)
    running_weights = collect(target_weights)

    # We sample the indices internally, for now hoping that they are conventional
    Base.require_one_based_indexing(sample_space)
    internal_sample_space = 1:length(sample_space)
    samples = Array{Int64}(undef, n_samples)
    for i in 1:n_samples
        samples[i] = sample(rng, internal_sample_space, Weights(running_weights))
        # All becomeing more likely...
        running_weights .+= target_weights
        if maximum(running_weights) > 1000
            println("Be more alert for overflows!")
        end
        # ...except for the one we just generated
        running_weights[samples[i]] -= correction
        # Fix underflow
        if running_weights[samples[i]]  < 0
            running_weights[samples[i]]  = 0
            println("Underflow on index $(samples[i])")
        end
    end
    [sample_space[index] for index in samples]
end

test = sample(rng, sample_space, AdjustingWeights(weights_base), n_samples)

println(countmap(test))

function extreme_diffs(rng, sample_space, weights_base, n_samples, n_replications)
    [
        let
            reference = sample(rng, sample_space, weights_base, n_samples)
            mae_reference = maximum(abs.(counts(reference) .- n_samples / length(sample_space)))
            test = sample(rng, sample_space, AdjustingWeights(weights_base), n_samples)
            mae_test = maximum(abs.(counts(test) .- n_samples / length(sample_space)))
            mae_test - mae_reference
        end
        for _ in 1:n_replications
    ]
end

ed = extreme_diffs(rng, sample_space, weights_base, n_samples, 100000)
countmap(ed)
mean(ed)
std(ed)

# Not quite the resounding success I had hoped for. I think this might need some tuning.