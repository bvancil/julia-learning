using VegaLite, VegaDatasets

dataset("cars") |>
@vlplot(
    :point,
    x = :Horsepower,
    y = :Miles_per_Gallon,
    color = :Origin,
    width = 400,
    height = 400
)
