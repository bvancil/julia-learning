proportion(xs) = xs ./ sum(xs)
species = ['A', 'B']
p_twins_given_species = [.1, .2]
p_single_given_species = [1 - p for p in p_twins_given_species]
prior_species = [1, 1]
p_species_given_twin1_single2 = proportion(
    p_twins_given_species .* p_single_given_species .* prior_species
)
