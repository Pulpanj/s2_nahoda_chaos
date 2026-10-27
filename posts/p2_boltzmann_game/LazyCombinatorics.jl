
module LazyCombinatorics

export Permutations, Combinations, CombinationsRep,
    Variations, VariationsRep

############################
# Utility: ensure vector
############################
_to_vec(xs) = collect(xs)

############################
# 1) Permutations (bez opakování)
############################

struct Permutations{T}
    xs::Vector{T}
end


Permutations(xs) = Permutations(_to_vec(xs))

Base.iterate(p::Permutations) = iterate(p, (copy(p.xs), false))

function Base.iterate(::Permutations, state)
    xs, started = state
    if !started
        return (copy(xs), (xs, true))
    end
    if nextperm!(xs)
        return (copy(xs), (xs, true))
    else
        return nothing
    end
end

# in-place lexicographic next permutation
function nextperm!(a)
    n = length(a)
    i = n - 1
    while i ≥ 1 && a[i] ≥ a[i+1]
        i -= 1
    end
    i == 0 && return false
    j = n
    while a[j] ≤ a[i]
        j -= 1
    end
    a[i], a[j] = a[j], a[i]
    reverse!(a, i+1, n)
    return true
end

############################
# 2) Combinations (bez opakování)
############################

struct Combinations{T}
    xs::Vector{T}
    k::Int
end

Combinations(xs, k) = Combinations(_to_vec(xs), k)

function Base.iterate(c::Combinations)
    n, k = length(c.xs), c.k
    k > n && return nothing
    idx = collect(1:k)
    return (c.xs[idx], idx)
end

function Base.iterate(c::Combinations, idx)
    n, k = length(c.xs), c.k
    i = k
    while i ≥ 1 && idx[i] == n - (k - i)
        i -= 1
    end
    i == 0 && return nothing
    idx[i] += 1
    for j in (i+1):k
        idx[j] = idx[j-1] + 1
    end
    return (c.xs[idx], idx)
end

############################
# 3) CombinationsRep (s opakováním)
############################

struct CombinationsRep{T}
    xs::Vector{T}
    k::Int
end

CombinationsRep(xs, k) = CombinationsRep(_to_vec(xs), k)

function Base.iterate(c::CombinationsRep)
    idx = fill(1, c.k)
    return (c.xs[idx], idx)
end

function Base.iterate(c::CombinationsRep, idx)
    n, k = length(c.xs), c.k
    i = k
    while i ≥ 1 && idx[i] == n
        i -= 1
    end
    i == 0 && return nothing
    idx[i] += 1
    for j in (i+1):k
        idx[j] = idx[i]
    end
    return (c.xs[idx], idx)
end

############################
# 4) Variations (bez opakování)
############################

struct Variations{T}
    xs::Vector{T}
    k::Int
end

Variations(xs, k) = Variations(_to_vec(xs), k)

function Base.iterate(v::Variations)
    n, k = length(v.xs), v.k
    k > n && return nothing
    idx = collect(1:k)
    return (v.xs[idx], idx)
end

function Base.iterate(v::Variations, idx)
    n, k = length(v.xs), v.k
    i = k
    while i ≥ 1 && idx[i] == n - (k - i)
        i -= 1
    end
    i == 0 && return nothing
    idx[i] += 1
    for j in (i+1):k
        idx[j] = idx[j-1] + 1
    end
    return (v.xs[idx], idx)
end

############################
# 5) VariationsRep (s opakováním)
############################

struct VariationsRep{T}
    xs::Vector{T}
    k::Int
end

VariationsRep(xs, k) = VariationsRep(_to_vec(xs), k)

function Base.iterate(v::VariationsRep)
    idx = fill(1, v.k)
    return (v.xs[idx], idx)
end

function Base.iterate(v::VariationsRep, idx)
    n, k = length(v.xs), v.k
    i = k
    while i ≥ 1 && idx[i] == n
        idx[i] = 1
        i -= 1
    end
    i == 0 && return nothing
    idx[i] += 1
    return (v.xs[idx], idx)
end

end # module