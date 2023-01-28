proportion(xs) = xs ./ sum(xs)
species = ['A', 'B']
p_twins_given_species = [.1, .2]
prior_species = [1, 1]
p_species_given_twin1 = proportion(p_twins_given_species .* prior_species)
