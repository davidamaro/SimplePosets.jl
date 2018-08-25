# Experimental functions for linear extensions

export linear_extension, all_linear_extensions


"""
`linear_extension(P)` returns a linear extension of the poset `P`.
"""
function linear_extension(P::SimplePoset{T}) where T
    result = T[]
    PP = deepcopy(P)
    while card(PP)>0
        M = minimals(PP)
        append!(result, M)
        for x in M
            delete!(PP,x)
        end
    end
    return result
end



_LX_table = Dict{SimplePoset, Set}()
export clear_LX_table

"""
`clear_LX_table()` releases cached results computed by
`all_linear_extensions`.
"""
function clear_LX_table()
    global _LX_table = Dict{SimplePoset, Set}()
    nothing
end

"""
`all_linear_extensions(P)` returns the `Set` of all linear extensions
of `P`. This can take a very long time and eat up a lot of memory
(which can be freed using `clear_LX_table`).
"""
function all_linear_extensions(P::SimplePoset)::Set
    # see if we already have an answer
    global _LX_table
    if haskey(_LX_table,P)
        return _LX_table[P]
    end

    T = element_type(P)
    result::Set = Set{Array{T,1}}()
    if card(P) == 0
        return result
    end
    if card(P) == 1
        L = elements(P)
        push!(result, L)
        return result
    end

    M = maximals(P)
    for x in M
        PP = deepcopy(P)
        delete!(PP,x)
        PP_exts = all_linear_extensions(PP)
        for L in PP_exts
            LL = deepcopy(L)
            append!(LL,[x])
            push!(result, LL)
        end
    end
    _LX_table[P] = result   # save this answer
    return result
end
