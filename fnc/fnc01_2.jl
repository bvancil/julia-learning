using FundamentalsNumericalComputation

A(α, β) = diagm(
    0 => ones(5),
    1 => -ones(4),
    3 => [α-β; 0],
    4 => [β]
)
α = 0.1;
β = 10 .^ (1:12);
AbsAcc = [];
for β in β
    # @show [β abs(FNC.backsub(A(α, β), [α; 0; 0; 0; 1])[1] - 1.)]
    push!(AbsAcc, abs(FNC.backsub(A(α, β), [α; 0; 0; 0; 1])[1] - 1.))
end
pretty_table((β=β, AbsAcc=AbsAcc), ["β" "|x₁-1|"])
