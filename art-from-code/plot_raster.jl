using ColorSchemes
using Distributions
using Images
using Random

function radial_waves(rng, amplitude, wavelength, n_waves, width, height)
    if (isa(amplitude, Number))
        amplitude = repeat([amplitude], n_waves)
    end
    if (isa(wavelength, Number))
        wavelength = repeat([wavelength], n_waves)
    end
    @assert length(amplitude) == n_waves
    @assert length(wavelength) == n_waves
    center_x = rand(rng, Uniform(1, width), n_waves)
    center_y = rand(rng, Uniform(1, height), n_waves)
    M = zeros((height, width))
    for x in 1:width, y in 1:height, i in 1:n_waves
        phase = norm([x - center_x[i], y - center_y[i]]) / wavelength[i]
        # Not sure how fast to make it die off
        M[y, x] += cos(phase) * amplitude[i] / sqrt(phase)
    end
    M
end

# Globals
rng = MersenneTwister(20221007)
width = 1920
height = 1080
color_scheme = ColorSchemes.colorschemes[:diverging_bwr_40_95_c42_n256];
color_scheme = ColorSchemes.colorschemes[:vik];
n_waves = 100

art1 = radial_waves(rng, rand(rng, Uniform(), n_waves), rand(rng, Uniform(2, sqrt(height)), n_waves), n_waves, width, height)
get(color_scheme, art1)

