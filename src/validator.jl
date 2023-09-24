module validator
import Base.@kwdef

export validate, Check

@kwdef mutable struct Check
    checks = []
    optional = nothing
    do_nothing = false
    col_types = nothing
end


function basic_check(x, df)
    if x ∈ names(df)
        nothing
        return true
    else
        println("ERROR: Column $x not present in dataframe")
        return false
    end
end

function check_existence(df, col_names)
    for col in col_names
        if typeof(col) <: String
            basic_check(col, df)
        else
            for c in col
                basic_check(c, df)
            end
        end
    end
end

function validate(df, schema)
    col_names = keys(schema)
    check_existence(df, col_names)
    for (col_names, checker) in pairs(schema)
        column_types = checker.col_types
        if column_types !== nothing
            actual_col_types = eltype(df[!, col_names])
        else
            println("Warning: Column types not specified")
        end
        for check in checker.checks
            results = check.(df[!, col_names])
            print(results)
            if false ∈ results
                println("Checks for column $col_names not passed")
                return false
            end
        end
    end
    return true
end

end # module validator
