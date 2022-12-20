using Symbolics

@variables x y
z = x^2 + y


A = [x^2+y 0 2x
    0 0 2y
    y^2+x 0 0]

using Latexify
latexify(A)


@variables t
D = Differential(t)
z = t + t^2
D(z)


expand_derivatives(D(z))

Symbolics.jacobian([x + x * y, x^2 + y], [x, y])

simplify(2x + 2y)

B = simplify.([t+t^2+t+t^2 2t+4t
    x+y+y+2t x^2-x^2+y^2])

simplify.(substitute.(B, (Dict(x => y^2),)))

V = substitute.(B, (Dict(x => 2.0, y => 3.0, t => 4.0),))

Symbolics.value.(V)