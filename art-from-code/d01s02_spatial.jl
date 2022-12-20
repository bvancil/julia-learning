using ColorSchemes
using Distributions
using Images
using Random

function sample_cross_matrix(rng, n::Int32=10)::Matrix{Int32}
    i, j = rand(rng, 1:n, 2)
    M = zeros(Int32, (n, n))
    M[i, :] .= 1
    M[:, j] .= 1
    M
end

rng = MersenneTwister(20221007)


Gray.(sample_cross_matrix(rng, 50))
get(ColorSchemes.colorschemes[:inferno], sample_cross_matrix(rng, 50))

function radial_waves(rng, amplitude, wavelength, n_waves, size)
    if (isa(amplitude, Number))
        amplitude = repeat([amplitude], n_waves)
    end
    if (isa(wavelength, Number))
        wavelength = repeat([wavelength], n_waves)
    end
    @assert length(amplitude) == n_waves
    @assert length(wavelength) == n_waves
    coord_range = Uniform(1, size)
    coords = rand(rng, coord_range, (2, n_waves))
    M = zeros((size, size))
    for x in 1:size, y in 1:size, w in 1:n_waves
        phase = norm([x, y] - coords[:, w]) / wavelength[w]
        # Not sure how fast to make it die off
        M[y, x] += cos(phase) * amplitude[w] / sqrt(phase)
    end
    M
end

get(ColorSchemes.colorschemes[:inferno], radial_waves(rng, 1, 10, 1, 100))
get(ColorSchemes.colorschemes[:inferno], radial_waves(rng, 1, 5, 4, 100))
get(ColorSchemes.colorschemes[:inferno], radial_waves(rng, 1, 5, 40, 100))

cool_radial(rng, n_waves, size) = get(ColorSchemes.colorschemes[:inferno], radial_waves(rng, rand(rng, Uniform(), n_waves), rand(rng, Uniform(2, sqrt(size)), n_waves), n_waves, size))

cool_radial(rng, 40, 1000)

cool_radial(rng, 200, 1000)

radial_waves1(rng, n_waves, size) = radial_waves(rng, rand(rng, Uniform(), n_waves), rand(rng, Uniform(2, sqrt(size)), n_waves), n_waves, size)

rw1a = radial_waves1(rng, 100, 1000)
get(ColorSchemes.colorschemes[:diverging_bwg_20_95_c41_n256], rw1a)
get(ColorSchemes.colorschemes[:diverging_bwr_40_95_c42_n256], rw1a)

show(ColorSchemes.colorschemes[:diverging_bwr_40_95_c42_n256])

