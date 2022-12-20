# An experiment with making a package and dealing with colors

module KUBrand

using AlgebraOfGraphics
using CairoMakie
using Colors
using ColorSchemes
import ColorTypes
using Distributions
using LaTeXStrings

brand_colors = Dict{String,Color}(
    "Kansas Blue" => colorant"#0051BA",
    "Crimson" => colorant"#E8000D",
    "Jayhawk Yellow" => colorant"#FFC82D",
    "Signature Gray" => colorant"#85898A",
    "Night" => colorant"#003459",
    "Lake" => colorant"#2767FF",
    "Sky" => colorant"#73CBF2",
    "Fog" => colorant"#8E9FBC",
    "Steam" => colorant"#DDE5ED",
    "Brick" => colorant"#971B2F",
    "Fire" => colorant"#FF3042",
    "Wheat" => colorant"#F2A900",
    "Terra Cotta" => colorant"#C66E4E",
    "Limestone" => colorant"#D7D2CB",
    "Kansas Blue - step 1" => colorant"#1479FB",
    "Kansas Blue - step 2" => colorant"#0170FF",
    "Kansas Blue - step 3" => colorant"#004091",
    "Kansas Blue - step 4" => colorant"#003171",
    "Crimson - step 1" => colorant"#FB5A62",
    "Crimson - step 2" => colorant"#FB2F39",
    "Crimson - step 3" => colorant"#B90009",
    "Crimson - step 4" => colorant"#900007",
    "Steam - step 1" => colorant"#E7ECF2",
    "Steam - step 2" => colorant"#F2F5F8",
    "Limestone - step 1" => colorant"#DFDBD5",
    "Limestone - step 2" => colorant"#F4F4F2",
    "Fog - step 1" => colorant"#A5B2C9",
    "Fog - step 2" => colorant"#E3E7EE",
    "Sky - step 1" => colorant"#B6E2F5",
    "Sky - step 2" => colorant"#DCF2FC",
    "Gray 1" => colorant"#F1F1F1",
    "Gray 2" => colorant"#D9D9D9",
    "Gray 3" => colorant"#AAAAAA",
    "Gray 4" => colorant"#7E7E7E",
    "Text Gray" => colorant"#333333",
    "Whitish" => colorant"#F2F5F8",
    "Blackish" => colorant"#151412",
)




function example_plot()
    N = 40

    x = [0:N; 0:N]

    y = [
        cumsum([0; rand(Poisson(2.3), N) - rand(Poisson(3.1), N)])
        cumsum([0; rand(Poisson(3.4), N) - rand(Poisson(2.2), N)])
    ]
    group = [fill("control", N + 1); fill("treatment", N + 1)]

    df = (; x, y, group)

    layers = visual(Lines) + visual(Scatter) * mapping(marker=:group => "Group")
    # Note the current limitation in the LaTeXString font
    plt = data(df) * layers * mapping(
              :x => "Time [days]",
              :y => L"Change in enrollment ($\Delta N$)",
              color=:group => "Group"
          )

    fg = draw(plt; axis=(
        title="Performance of groups over time",
        subtitle="where adding and dropping are Poisson processes",
    ))
end

example_plot()

ku_theme = Theme(
    Axis=(
        backgroundcolor=brand_colors["Whitish"],
        leftspinevisible=false,
        rightspinevisible=false,
        bottomspinevisible=false,
        topspinevisible=false,
        subtitlealign=:left,
        subtitlecolor=brand_colors["Gray 4"],
        titlealign=:left,
        titlecolor=brand_colors["Night"],
        xgridcolor=brand_colors["Steam"],
        xlabelcolor=brand_colors["Night"],
        xtickcolor=brand_colors["Gray 4"],
        xticklabelcolor=brand_colors["Gray 4"],
        ygridcolor=brand_colors["Steam"],
        ylabelcolor=brand_colors["Night"],
        ytickcolor=brand_colors["Gray 4"],
        yticklabelcolor=brand_colors["Gray 4"],
    ),
    font="Arial Narrow",
    fontsize=16,
    Legend=(
        framecolor=brand_colors["Night"],
        labelcolor=brand_colors["Night"],
        titlecolor=brand_colors["Night"],
    ),
    Lines=(
        linewidth=4,
        linestyle=:solid,
    ),
    palette=(
        color=map(x -> brand_colors[x], ["Kansas Blue", "Crimson"]),
    ),
    Scatter=(
        markersize=10,
        markerstrokecolor=brand_colors["Whitish"],
        markerstrokewidth=2
    ),
)

with_theme(example_plot, ku_theme)

ColorTypes.hue(color::RGB)::Float32 = convert(LCHuv, color).h
ColorTypes.chroma(color::RGB)::Float32 = convert(LCHuv, color).c
luminance(color::RGB)::Float32 = convert(LCHuv, color).l

function hcl_match(color::RGB, match::RGB; h::Bool=false, c::Bool=false, l::Bool=false)::RGB
    color_hcl = convert(LCHuv, color)
    match_hcl = convert(LCHuv, match)
    new_h = h ? match_hcl.h : color_hcl.h
    new_c = c ? match_hcl.c : color_hcl.c
    new_l = l ? match_hcl.l : color_hcl.l
    convert(RGB, LCHuv(new_l, new_c, new_h))
end

kansas_blue = brand_colors["Kansas Blue"]
crimson = brand_colors["Crimson"]
[kansas_blue, hcl_match(crimson, kansas_blue; c=true, l=true), hcl_match(kansas_blue, crimson; c=true, l=true), crimson]

function diverging_palette(color1::RGB, color2::RGB, n)
    Colors.diverging_palette(
        hue(color1),
        hue(color2),
        n;
        c=0.8,
        s=0.9,
        b=0.7,
        w=0.5
    )
end
p = diverging_palette(brand_colors["Kansas Blue"], brand_colors["Crimson"], 256)
[luminance(c) for c in p]
[chroma(c) for c in p]
color_scheme = ColorSchemes.ColorScheme(p)
brand_palettes = Dict{Symbol,ColorScheme}(
    :div_blue_red => ColorScheme(
        hcl_match.(
            ColorSchemes.colorschemes[:vik].colors,
            diverging_palette(brand_colors["Kansas Blue"], brand_colors["Crimson"], 256);
            h=true
        ),
        "Diverging Blue-White-Red",
        "notes here"
    ),
    :div_blue_red_sci_vik => ColorSchemes.colorschemes[:vik],
)
brand_palettes[:div_blue_red]

end
