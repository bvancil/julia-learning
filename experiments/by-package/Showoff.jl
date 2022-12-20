using Showoff

struct Percent
    value::Float64
end

function Showoff.showoff(xs::AbstractArray{Percent})
    return [string(x, "%") for x in showoff([100 * x.value for x in xs])]
end


map(println, showoff([Percent(rand()) for _ in 1:20]))