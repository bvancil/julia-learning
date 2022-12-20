# Read in a schema
using Schemata

schema = readschema(joinpath(dirname(pathof(Schemata)), "..", "test/schemata/fever.toml"))
ts = schema.tables[:mytable]  # TableSchema for mytable

# Construct/import a table (any object that satisfies the Tables.jl interface)
using DataFrames

table = DataFrame(
    patientid=[1, 2, 3, 4],
    age=[11, 22, 33, 444],  # Note that 444 is not in the set of valid values according to the schema
    dose=["small", "medium", "large", "medium"],
    fever=[false, true, true, false]
)

# Transform the table to comply with the schema.
# Values that are unparseable or invalid are set to missing.
# Return the transformed data, a table of input data issues and a table of output data issues.
outdata, input_issues, output_issues = compare(ts, table)
