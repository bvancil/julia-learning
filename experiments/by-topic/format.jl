# Create an object with meaningful representation and helper functions

struct Strm
    code::Int16
end

year(t::Strm) = 1600 + t.code ÷ 10
termcode(t::Strm) = mod(t.code, 10)
function term(t::Strm)::String
    tc = termcode(t)
    rv = if tc in [1, 2, 3, 4]
        "spring"
    elseif tc in [5, 6, 7]
        "summer"
    else
        "fall"
    end
    return rv
end
Base.show(io::IO, t::Strm) = print(io, year(t), ' ', term(t))

@show Strm(4022)
