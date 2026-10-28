using LinearAlgebra
using Printf
using DataFrames
using DataFrames, MarkdownTables, PrettyTables

function hypercube_transition_dataframes(N::Int)
    num_nodes = 2^N
    nodes = [bitstring(i)[(end-N+1):end] for i in 0:(num_nodes-1)]

    # Hamming distance between two bitstring representations
    hamming(a::AbstractString, b::AbstractString) = count(t -> t[1] != t[2], zip(a, b))

    # ----------------------------------------------------
    # 1. Full Transition Matrix (2^N x 2^N)
    # ----------------------------------------------------
    P_full = zeros(Float64, num_nodes, num_nodes)
    for i in 1:num_nodes
        for j in 1:num_nodes
            if hamming(nodes[i], nodes[j]) == 1
                P_full[i, j] = 1.0 / N
            end
        end
    end

    col_names_full = [Symbol(n) for n in nodes]
    df_full = DataFrame(P_full, col_names_full)
    insertcols!(df_full, 1, :Node => nodes)

    # ----------------------------------------------------
    # 2. Condensed/Reduced Transition Matrix ((N+1) x (N+1))
    # ----------------------------------------------------
    P_reduced = zeros(Float64, N+1, N+1)
    r_values = [k for k in 0:N]

    for k in 0:N
        row_idx = k + 1  # 1-based indexing for Julia

        # Transition to higher R (k + 1 ones)
        if k < N
            P_reduced[row_idx, k+2] = (N - k) / N
        end

        # Transition to lower R (k - 1 ones)
        if k > 0
            P_reduced[row_idx, k] = k / N
        end
    end

    # Use "R=value" format for column symbols to ensure valid DataFrame identifiers
    col_names_reduced = [Symbol("R=$r") for r in r_values]
    df_reduced = DataFrame(P_reduced, col_names_reduced)
    insertcols!(df_reduced, 1, :R => r_values)

    return df_full, df_reduced
end