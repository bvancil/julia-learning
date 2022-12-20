using PalmerPenguins, DataFrames

penguins = dropmissing(DataFrame(PalmerPenguins.load()))
first(penguins, 6)

using AlgebraOfGraphics, CairoMakie
set_aog_theme!()

axis = (width=225, height=225)
penguin_frequency = data(penguins) * frequency() * mapping(:species)

draw(penguin_frequency; axis)


fg = draw(penguin_frequency; axis)
save("figure.png", fg, px_per_unit=3) # save high-resolution png


plt = penguin_frequency * mapping(color=:island)
draw(plt; axis)

plt = penguin_frequency * mapping(color=:island, dodge=:island)
draw(plt; axis)


plt = penguin_frequency * mapping(color=:island, stack=:island)
draw(plt; axis)


penguin_bill = data(penguins) * mapping(:bill_length_mm, :bill_depth_mm)
draw(penguin_bill; axis)


penguin_bill = data(penguins) * mapping(
    :bill_length_mm => (t -> t / 10) => "bill length (cm)",
    :bill_depth_mm => (t -> t / 10) => "bill depth (cm)",
)
draw(penguin_bill; axis)



plt = penguin_bill * mapping(color=:species)
draw(plt; axis)


plt = penguin_bill * linear() * mapping(color=:species)
draw(plt; axis)



plt = penguin_bill * (linear() + mapping()) * mapping(color=:species)
draw(plt; axis)



layers = linear() + mapping(marker=:sex)
plt = penguin_bill * layers * mapping(color=:species)
draw(plt; axis)


layers = linear() + mapping(col=:sex)
plt = penguin_bill * layers * mapping(color=:species)
draw(plt; axis)



layers = linear() + mapping()
plt = penguin_bill * layers * mapping(color=:species, col=:sex)
draw(plt; axis)


using AlgebraOfGraphics: density
plt = penguin_bill * density(npoints=50) * mapping(col=:species)
draw(plt; axis)


plt *= visual(colormap=:grayC, colorrange=(0, 6))
draw(plt; axis)


axis = (type=Axis3, width=300, height=300)
layer = density() * visual(Wireframe, linewidth=0.05)
plt = penguin_bill * layer * mapping(color=:species)
draw(plt; axis)



axis = (width=225, height=225)
layer = density() * visual(Contour)
plt = penguin_bill * layer * mapping(color=:species)
draw(plt; axis)



layers = density() * visual(Contour) + linear() + mapping()
plt = penguin_bill * layers * mapping(color=:species)
draw(plt; axis)


layers = density() * visual(Contour) + linear() + visual(alpha=0.5)
plt = penguin_bill * layers * mapping(color=:species)
draw(plt; axis)



body_mass = :body_mass_g => (t -> t / 1000) => "body mass (kg)"
layers = linear() * mapping(group=:species) + mapping(color=body_mass, marker=:species)
plt = penguin_bill * layers
draw(plt; axis)


body_mass
typeof(body_mass)

