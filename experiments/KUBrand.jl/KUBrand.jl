# An experiment with making a package and dealing with colors

module KUBrand

using AlgebraOfGraphics
using CairoMakie
using Colors
using ColorSchemes
using ColorVectorSpace
import ColorTypes
using Distributions
using FixedPointNumbers
using LaTeXStrings
using PerceptualColourMaps
import Base
import Random

function print_as_tableau(color_scheme::ColorScheme, n::Int64 = 19)
    color_list = get(color_scheme, range(0, 1, length = n))
    for color in color_list
        println("            <color>#", hex(color), "</color>")
    end
end

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
    "Devil's Gray" => colorant"#666666",
    "White" => colorant"#FFFFFF",
    "Whitish" => colorant"#F2F5F8",
    "Black" => colorant"#000000",
    "Blackish" => colorant"#151412",
)

Dict(name => convert(LCHuv, brand_colors[name]) for name in keys(brand_colors))


function example_plot()
    N = 40

    x = [0:N; 0:N]
    Random.seed!(20240425)
    y = [
        cumsum([0; rand(Poisson(2.3), N) - rand(Poisson(3.1), N)])
        cumsum([0; rand(Poisson(3.4), N) - rand(Poisson(2.2), N)])
    ]
    group = [fill("control", N + 1); fill("intervention", N + 1)]

    df = (; x, y, group)

    layers = visual(Lines) + visual(Scatter) * mapping(marker=:group => "Group")
    # Note the current limitation in the LaTeXString font
    plt = data(df) * layers * mapping(
        :x => "Time [days]",
        # :y => L"Change in enrollment ($\Delta N$)",
        :y => "Change in enrollment (ΔN)",
        color=:group => "Group"
    )

    fg = draw(plt; axis=(
        title="The intervention registered more students",
        subtitle="compared to the business-as-usual control",
    ))
end

# example_plot()

ku_theme = Theme(
    Axis=(
        backgroundcolor=brand_colors["White"],
        leftspinevisible=false,
        rightspinevisible=false,
        bottomspinevisible=false,
        topspinevisible=false,
        subtitlealign=:left,
        subtitlecolor=brand_colors["Kansas Blue"],
        subtitlefont=:titles,
        subtitlesize=16,
        titlealign=:left,
        titlecolor=brand_colors["Kansas Blue"],
        titlefont=:titles,
        titlesize=20,
        xgridcolor=brand_colors["Gray 3"],
        xlabelcolor=brand_colors["Text Gray"],
        xlabelsize=14,
        xtickcolor=brand_colors["Devil's Gray"],
        xticklabelcolor=brand_colors["Text Gray"],
        xticklabelsize=11,
        ygridcolor=brand_colors["Gray 3"],
        ylabelcolor=brand_colors["Text Gray"],
        ylabelsize=14,
        ytickcolor=brand_colors["Devil's Gray"],
        yticklabelcolor=brand_colors["Text Gray"],
        yticklabelsize=11,
    ),
    fonts=(;
        regular = "Noto Sans",
        titles = "Noto Sans Display Condensed Semibold"
    ),
    fontsize=16,
    Legend=(
        framecolor=brand_colors["Devil's Gray"],
        labelcolor=brand_colors["Text Gray"],
        labelsize=11,
        titlecolor=brand_colors["Text Gray"],
        titlesize=11,
    ),
    Lines=(
        linewidth=4,
        linestyle=:solid,
    ),
    palette=(
        # color=map(x -> brand_colors[x], ["Text Gray", "Kansas Blue"]),
        color=[brand_colors["Devil's Gray"], brand_colors["Text Gray"]],
        # color=[brand_colors["Text Gray"], ColorSchemes.okabe_ito.colors[5]],
    ),
    Scatter=(
        markersize=10,
        markerstrokecolor=brand_colors["White"],
        markerstrokewidth=2
    ),
)

# with_theme(example_plot, ku_theme)

ColorTypes.hue(color::RGB)::Float32 = convert(LCHuv, color).h
ColorTypes.chroma(color::RGB)::Float32 = convert(LCHuv, color).c
luminance(color::RGB)::Float32 = convert(LCHuv, color).l
luminance(color::LCHuv)::Float32 = color.l

function lighten(color::RGB, gain)::RGB
    color_hcl = convert(LCHuv, color)
    new_h = color_hcl.h
    new_c = color_hcl.c
    if 0 <= gain
        new_l = 100 - (100 - color_hcl.l) * (1 - gain)
    else
        new_l = color_hcl.l * (1 + gain)
    end
    # Clamp to between 0 and 1
    new_l = min(100, max(0, new_l))
    convert(RGB{Colors.FixedPointNumbers.N0f8}, LCHuv(new_l, new_c, new_h))
end

darken(color::RGB, loss)::RGB = lighten(color, -loss)

function set_l(color::RGB, new_l)::RGB
    color_hcl = convert(LCHuv, color)
    convert(RGB, LCHuv(new_l, color_hcl.c, color_hcl.h))
end

function set_c(color::RGB, new_c)::RGB
    color_hcl = convert(LCHuv, color)
    convert(RGB, LCHuv(color_hcl.l, new_c, color_hcl.h))
end

function hcl_match(color::RGB, match::RGB; h::Bool=false, c::Bool=false, l::Bool=false)::RGB
    color_hcl = convert(LCHuv, color)
    match_hcl = convert(LCHuv, match)
    new_h = h ? match_hcl.h : color_hcl.h
    new_c = c ? match_hcl.c : color_hcl.c
    new_l = l ? match_hcl.l : color_hcl.l
    convert(RGB, LCHuv(new_l, new_c, new_h))
end

function adjust_chroma(color::Union{RGB, LCHuv}, new_chroma_value)::LCHuv
    color_hcl = convert(LCHuv, color)
    return LCHuv(color_hcl.l, new_chroma_value, color_hcl.h)
end

# [
#     brand_colors["Kansas Blue"],
#     hcl_match(brand_colors["Crimson"], brand_colors["Kansas Blue"]; c=true, l=true),
#     hcl_match(brand_colors["Kansas Blue"], brand_colors["Crimson"]; c=true, l=true),
#     brand_colors["Crimson"]
# ]

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

"""Alter color_scheme to match beginning and ending colors' hues better."""
function warp_diverging(color_scheme::ColorScheme, color1::RGB, color2::RGB, exponent::Float64 = 3.0)
    new_color_scheme = [color for color in color_scheme]
    for (index, color) in enumerate(color_scheme)
        affine_parameter = index / length(color_scheme)
        # 1 at ends and 0 in middle:
        warping_ratio = abs(2 * affine_parameter - 1) ^ exponent
        target_color = (affine_parameter <= 0.5) ? color1 : color2
        color_hcl = convert(LCHuv, color)
        new_luminance = color_hcl.l
        new_chroma = color_hcl.c
        new_hue = warping_ratio * hue(target_color) + (1 - warping_ratio) * color_hcl.h
        new_color_scheme[index] = convert(RGB, LCHuv(new_luminance, new_chroma, new_hue))
    end
    new_color_scheme
end

function sequential_palette(color1::RGB, n::Int64=20)
    color1_hsb = convert(HSB, color1)
    saturation = color1_hsb.s
    brightness = color1_hsb.v
    Colors.sequential_palette(
        hue(color1),
        n;
        c=0.8,
        s=saturation,
        b=brightness,
        w=0.15,
        d=1.0,
        wcolor=color1
    )
end

cvd_panel(colors) = [colors'; protanopic.(colors)'; deuteranopic.(colors)'; tritanopic.(colors)']

light_to_blue = sequential_palette(brand_colors["Kansas Blue"], 20)
night_to_blackish = range(brand_colors["Night"], stop=brand_colors["Blackish"], length=5)
night_to_gray = range(brand_colors["Night"], stop=lighten(brand_colors["Signature Gray"], 0.1), length=4)
brand_palettes = Dict{Symbol,ColorScheme}(
    :div_blue_red => ColorScheme(
        warp_diverging(
            ColorSchemes.colorschemes[:vik],
            brand_colors["Kansas Blue"],
            brand_colors["Crimson"]
        ),
        "Diverging Blue-White-Red",
        "Based on vik"
    ),
    :vik => ColorSchemes.colorschemes[:vik],
    :light_to_blue => ColorScheme(
        sequential_palette(brand_colors["Kansas Blue"], 20)
    ),
    :light_to_blue2 => ColorScheme(
        range(brand_colors["Whitish"], stop=brand_colors["Kansas Blue"], length=20)
    ),
    :night_to_blue => ColorScheme(
        range(brand_colors["Night"], stop=brand_colors["Kansas Blue"], length=20)
    ),
    :dark_to_blue => ColorScheme(
        range(brand_colors["Blackish"], stop=brand_colors["Kansas Blue - step 2"], length=20)
    ),
    :steam_to_night => ColorScheme(
        range(brand_colors["Steam"], stop=brand_colors["Night"], length=20)
    ),
    :steam_to_night5 => ColorScheme(
        range(brand_colors["Steam"], stop=brand_colors["Night"], length=5)
    ),
    :wheat_to_blue => ColorScheme(
        range(brand_colors["Wheat"], stop=brand_colors["Kansas Blue"], length=20)
    ),
    :yellow_to_brick => ColorScheme(
        range(brand_colors["Jayhawk Yellow"], stop=brand_colors["Brick"], length=5)
    ),
    :yellow_to_bluestep4 => ColorScheme(
        vcat(
            range(brand_colors["Jayhawk Yellow"], stop=colorant"#ff7e4e", length=5),
            range(colorant"#ff7e4e", stop=colorant"#d94774", length=5)
        )

    ),
    :PaulTol_muted => ColorScheme(
        [
            RGB{N0f8}(46/255, 37/255, 133/255),
            RGB{N0f8}(126/255, 41/255, 84/255),
            RGB{N0f8}(220/255, 205/255, 125/255),
            RGB{N0f8}(51/255, 117/255, 56/255),
            RGB{N0f8}(93/255, 168/255, 153/255),
            RGB{N0f8}(148/255, 203/255, 236/255),
            RGB{N0f8}(194/255, 106/255, 119/255),
            RGB{N0f8}(159/255, 74/255, 150/255),
            RGB{N0f8}(221/255, 221/255, 221/255),
        ]
    ),
    :OkabeIto => ColorScheme(
        [
            RGB{N0f8}(0/255, 0/255, 0/255),
            RGB{N0f8}(0/255, 114/255, 178/255),
            RGB{N0f8}(86/255, 180/255, 233/255),
            RGB{N0f8}(213/255, 94/255, 0/255),
            RGB{N0f8}(240/255, 228/255, 66/255),
            RGB{N0f8}(0/255, 158/255, 115/255),
            RGB{N0f8}(230/255, 159/255, 0/255),
            RGB{N0f8}(204/255, 121/255, 167/255),
        ]
    ),
    :KUOkabeIto => ColorScheme(
        [
            RGB{N0f8}(0/255, 0/255, 0/255),
            hcl_match(RGB{N0f8}(0/255, 114/255, 178/255), brand_colors["Kansas Blue"]; h=true),
            hcl_match(RGB{N0f8}(86/255, 180/255, 233/255), brand_colors["Kansas Blue"]; h=true),
            hcl_match(RGB{N0f8}(213/255, 94/255, 0/255), brand_colors["Crimson"]; h=true),
            hcl_match(RGB{N0f8}(240/255, 228/255, 66/255), brand_colors["Jayhawk Yellow"]; h=true),
            RGB{N0f8}(0/255, 158/255, 115/255),
            RGB{N0f8}(230/255, 159/255, 0/255),
            RGB{N0f8}(204/255, 121/255, 167/255)
        ]
    ),
    :KUQualitative4 => ColorScheme(
        [
            brand_colors["Kansas Blue"],
            hcl_match(brand_colors["Crimson"], brand_colors["Kansas Blue"]; c=true, l=true),
            set_l(hcl_match(brand_colors["Jayhawk Yellow"], brand_colors["Kansas Blue"]; c=true), 70),
            #hcl_match(brand_colors["Signature Gray"], brand_colors["Kansas Blue"]; l=true),
            brand_colors["Signature Gray"]
        ]
    ),
    :KUQualitative => ColorScheme(
        [
            brand_colors["Kansas Blue"],
            hcl_match(brand_colors["Crimson"], brand_colors["Kansas Blue"]; c=true, l=true),
            set_l(hcl_match(brand_colors["Jayhawk Yellow"], brand_colors["Kansas Blue"]; c=true), 70),
            brand_colors["Signature Gray"],
            hcl_match(brand_colors["Signature Gray"], brand_colors["Kansas Blue"]; l=true),
            brand_colors["Black"],
            set_l(brand_colors["Sky"], 65),
            set_l(set_c(brand_colors["Brick"], 38), 40),
            # colorant"#DC8811",
            # colorant"#D88d42",
            set_l(set_c(brand_colors["Wheat"], 70), 70),
            # set_l(set_c(brand_colors["Wheat"], 62), 70),
            brand_colors["Terra Cotta"],
            # brand_colors["Gray 4"],
        ]
    )
)


p = brand_palettes[:KUQualitative]
cvd_panel(p.colors)
print_as_tableau(p, length(p.colors))
convert(LCHuv, p.colors[3])

p = brand_palettes[:vik]
cvd_panel(p.colors)
print_as_tableau(p, 19)


p = brand_palettes[:steam_to_night5]
print_as_tableau(p, 5)

p = ColorSchemes.colorschemes[:vik]
p = brand_palettes[:dark_to_blue]
p = brand_palettes[:div_blue_red]
get(p, range(0, 1, length = 19))
get(p, range(0, 1, length = 11))
get(p, range(0, 1, length = 7))
print_as_tableau(p, 19)

plot([hue(c) for c in p])
plot([luminance(c) for c in p])
plot([chroma(c) for c in p])
convert(LCHuv, brand_colors["Kansas Blue"])
convert(LCHuv, brand_colors["Crimson"])



print_as_tableau(brand_palettes[:div_blue_red])
print_as_tableau(ColorSchemes.vik)
brand_palettes[:light_to_blue2]
print_as_tableau(brand_palettes[:light_to_blue2], 20)
print_as_tableau(brand_palettes[:dark_to_blue], 20)

# Work on paired palettes.

grouped = [
    LCHuv(new_luminance, new_chroma, new_hue)
    for new_hue in hue.([brand_colors["Kansas Blue"], brand_colors["Crimson"], brand_colors["Jayhawk Yellow"]])
    for new_luminance in [37, 50, 66]
    for new_chroma in chroma.([(brand_colors["Kansas Blue"])])
]

grouped2 = [
    LCHuv(new_luminance, new_chroma, new_hue)
    for new_hue in hue.([brand_colors["Kansas Blue"], brand_colors["Crimson"], brand_colors["Jayhawk Yellow"]])
    for new_luminance in [37, 50, 66]
    for new_chroma in [100]
]

grouped3 = [
    LCHuv(new_luminance, new_chroma, new_hue)
    for new_hue in hue.([brand_colors["Kansas Blue"], brand_colors["Crimson"], brand_colors["Jayhawk Yellow"]])
    for new_luminance in [25, 45, 66]
    for new_chroma in [100]
]

grouped = [
    LCHuv(new_luminance, new_chroma, new_hue)
    for new_hue in hue.([brand_colors["Kansas Blue"], brand_colors["Crimson"], brand_colors["Jayhawk Yellow"]])
    for new_luminance in [37, 50, 66]
    for new_chroma in chroma.([(brand_colors["Jayhawk Yellow"])])
]

cvd_panel(grouped)
[brand_colors["Kansas Blue"], MSC(hue(brand_colors["Kansas Blue"]))]

function color_distance(color1, color2)
    return sqrt(
        (hue(color1) - hue(color2)) ^ 2
        + (chroma(color1) - chroma(color2)) ^ 2
        + (luminance(color1) - luminance(color2)) ^ 2
    )
end
color_distance(brand_colors["Kansas Blue"], brand_colors["Crimson"])
function distances(colors1, colors2, distance_function = color_distance)
    return reshape([
        distance_function(color1, color2)
        for color1 in colors1
        for color2 in colors2
    ], (length(colors1), length(colors2)))
end
distances([brand_colors["Kansas Blue"], brand_colors["Crimson"], brand_colors["Jayhawk Yellow"]], [brand_colors["Kansas Blue"], brand_colors["Crimson"], brand_colors["Jayhawk Yellow"]])

function Base.rand(type::Type{T}) where T<:LCHuv
    return convert(LCHuv, rand(RGB))
end

"""Maximize total distance and minimum between the colors"""
function dispersed_categorical(n_colors::Int, chroma_values::Vector{Float32}, fixed_colors::Vector{LCHuv{Float32}})::ColorScheme
    output_colors = Vector{LCHuv{Float32}}(undef, n_colors)
    n_fixed = length(fixed_colors)
    fixed_range = Base.OneTo(n_fixed)
    if 0 < n_fixed
        output_colors[fixed_range] = fixed_colors
    end
    full_range = Base.OneTo(n_colors)
    mutable_range = (n_fixed + 1):n_colors
    for i in mutable_range
        output_colors[i] = rand(LCHuv{Float32})
    end
    
    # objectives
    maximum_minimum = 0
    total_distance = 0
    for round in 1:10000
        total_distance = 0
        for i in mutable_range
            partial_distance = 0
            minimum = 1e200
            for j in full_range
                distance = color_distance(output_colors[i], output_colors[j])
                partial_distance += distance
                if 0 < distance < minimum
                    minimum = distance
                end
            end
            maximum_minimum = max(maximum_minimum, minimum)
            total_distance += partial_distance

            candidate_color = rand(LCHuv{Float32})
            chroma_choice = rand(chroma_values)
            candidate_color = adjust_chroma(candidate_color, chroma_choice)
            is_better = true
            for j in full_range
                if i != j
                    if color_distance(candidate_color, output_colors[j]) < maximum_minimum 
                        is_better = false
                        break
                    end
                end
            end
            if is_better
                output_colors[i] = candidate_color
            end
        end
    end
    println((maximum_minimum, total_distance))
    return ColorScheme(output_colors)
end


Random.seed!(20240424 + 97)
c6_7 = dispersed_categorical(
    7,
    [chroma(brand_colors["Kansas Blue"])],
    [brand_colors["Kansas Blue"], brand_colors["Crimson"], convert(LCHuv, brand_colors["Wheat"])]
);
print_as_tableau(c6_7, 7)
cvd_panel(c6_7.colors)


Random.seed!(20240422 + 10)
c6_10 = dispersed_categorical(
    6,
    [chroma(brand_colors["Kansas Blue"])],
    [brand_colors["Kansas Blue"], brand_colors["Crimson"], brand_colors["Jayhawk Yellow"]]
);
print_as_tableau(c6_10, 6)
cvd_panel(c6_10.colors)


Random.seed!(20240422 + 3)
c6_3 = dispersed_categorical(
    6,
    [chroma(brand_colors["Kansas Blue"])],
    [brand_colors["Kansas Blue"], brand_colors["Crimson"], brand_colors["Jayhawk Yellow"]]
)
print_as_tableau(c6_3, 6)
cvd_panel(c6_3.colors)

Random.seed!(20240422 + 2)
c6_2 = dispersed_categorical(
    6,
    [chroma(brand_colors["Kansas Blue"])],
    [brand_colors["Kansas Blue"], brand_colors["Crimson"], brand_colors["Jayhawk Yellow"]]
)
print_as_tableau(c6_2, 6)
cvd_panel(c6_2.colors)

cvd_panel(grouped2)
end
