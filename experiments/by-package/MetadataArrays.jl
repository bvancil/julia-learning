using MetadataArrays

v = ["John", "John", "Jane", "Louise"];
s = MetadataArray(v, Dict("John" => "Treatment", "Louise" => "Placebo", "Jane" => "Placebo"))

@show parent(s)
@show metadata(s)
