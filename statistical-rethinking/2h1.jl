# FIXME
proportion(xs) = xs ./ sum(xs)
species = ['A', 'B']
p_twins_given_species = [.1, .2]
prior_species = [1, 1]
p_twin1 = p_twins_given_species .* prior_species
p_twin1_twin2 = p_twins_given_species .^ 2 .* prior_species
p_twin2_given_twin1 = p_twin1_twin2 ./ p_twin1
