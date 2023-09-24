using validator

using Test
using DataFrames

@testset "validator.jl" begin

    df = DataFrame(:id => [1, 2, 3, 4], :out_str => ["One", "Two", "Three", "Four"])
    schema = Dict("id" => validator.Check(checks=[x -> x < 30], col_types=[Int64]), ["id", "out_str"] => validator.Check(col_types=[Int64, String]))
    @test validator.validate(df, schema) == true

    df = DataFrame(:id => [1, 2, 3, 4], :out_str => ["One", "Two", "Three", "Four"])
    schema = Dict("id" => validator.Check(checks=[x -> x > 5], col_types=[Int64]))
    @test validator.validate(df, schema) == false

end
