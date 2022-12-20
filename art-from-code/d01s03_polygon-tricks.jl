using Random

using DataFrames
using Distributions
using Luxor

# Global constants

# Origin O
O = Point(0, 0)

# I'm going to make the choice that a polygon doesn't 
# duplicate the first point, since Luxor allows us to draw
# a polygon with the `close=true` argument.

const Segment = Tuple{Point,Point}
const Polygon = Vector{Point}

# Helper functions
function cycle_left(xs::Vector{T})::Vector{T} where {T}
    if length(xs) < 2
        return xs
    end
    vcat(xs[2:end], [xs[1]])
end

function cycle_right(xs::Vector{T})::Vector{T} where {T}
    if length(xs) < 2
        return xs
    end
    vcat([xs[end]], xs[1:(end-1)])
end

segments(p::Polygon)::Base.Iterators.Zip{Tuple{Polygon,Polygon}} = zip(p, cycle_left(p))
lengths(p::Polygon)::Vector{Float64} = map(s -> distance(s...), segments(p))

function sample_edge(rng::AbstractRNG, p::Polygon)
    # Imagine choosing a percentage of the perimeter to
    # travel. We start with the first point as 0%.
    prob = rand(rng, Uniform())
    cum_prob_endpoints = begin
        ls = lengths(p)
        cum_ls = cumsum(ls)
        cum_ls ./ cum_ls[end]
    end
    # FIXME: This code sucks! and doesn't work.
    # Vertex index you just passed when stopping
    i₀ = findfirst(x -> prob < x, cum_prob_endpoints)
    # Vertex index you haven't yet reached when stopping
    i₁ = i₀ % (length(p) - 1) + 1
    # Vertex you just passed when stopping
    V₀ = p[i₀]
    # Vertex you haven't yet reached when stopping
    V₁ = p[i₁]
    # affine parameter
    t = (
        (prob - (i₀ == 1 ? 0 : cum_prob_endpoints[i₀]))
        /
        (cum_prob_endpoints[i₀+1] - cum_prob_endpoints[i₀])
    )
    println("prob = $(prob); i₀ = $(i₀); i₁ = $(i₁); V₀ = $(V₀); V₁ = $(V₁); t = $(t)")
    (1 - t) .* V₀ .+ t .* V₁
end

rng = MersenneTwister(20221127)
square = ngon(O, 1, 4)
sample_edge(rng, square)
function wrap_plot(f::Function; output="results/polygon.svg", size=500)
    Drawing(size, size, output)
    origin()
    f()
    finish()
    preview()
end

function draw_circle()
    setcolor("red")
    circle(Point(0, 0), 100, action=:fill)
end

wrap_plot(draw_circle; size=500)

function plot_square()
    setcolor("red")
    poly(100 .* Point.(square.x, square.y), action=:fill, close=true)
    # ngon(Point(0, 0), 100, 6, action=:fill)
end

wrap_plot(plot_square; size=200)

perimeter(polygon::Vector{Point}) = sum((p, q) -> distance(p, q), zip(polygon[1:(end-1)], polygon[2:end]))
