using Plots

# Compute Pascal triangle values
function pascal_triangle(N)
    tri = Vector{Vector{Int}}(undef, N+1)
    tri[1] = [1]
    for r in 1:N
        prev = tri[r]
        row = [1; [prev[i] + prev[i+1] for i in 1:(length(prev)-1)]; 1]
        tri[r+1] = row
    end
    return tri
end

# Coordinates for triangular layout
function pascal_coords(N)
    coords = Dict{Tuple{Int,Int},Tuple{Float64,Float64}}()
    for r in 0:N
        for c in 0:r
            x = c - r/2          # center each row
            y = -r               # row spacing downward
            coords[(r, c)] = (2*x, 2*y)
        end
    end
    coords
end

# Plot Pascal triangle using circles + labels + arrows (quiver)
function plot_pascal(N=7)
    tri = pascal_triangle(N)
    coords = pascal_coords(N)

    # Collect node positions and labels
    xs, ys, labels = Float64[], Float64[], String[]
    for r in 0:N
        for c in 0:r
            x, y = coords[(r, c)]
            push!(xs, x)
            push!(ys, y)
            push!(labels, string(tri[r+1][c+1]))
        end
    end

    mcolor = vcat(fill(:lightblue, div(N*(N+1), 2)), fill(:lightgreen, N+1))

    # Base scatter plot (circles)
    plt = scatter(
        xs, ys,
        markersize=18,
        markercolor=mcolor,#[:lightblue, :red],
        markerstrokecolor=:black,
        markerstrokewidth=1.5,
        aspect_ratio=:equal,
        legend=false,
        # axisoff=true,
        xlims=(-N-3, N+1),
        xticks=((-N):2:N, 0:1:N),
        xlabel="Číslo přihrádky K",
        ylims=(-2*N-1, 3),
        yticks=(2:-2:(-2*N), string.(["Trychtýř"; collect(0:(N-1)); "Přihrádky"])),
        ylabel="Vrstva kolíčků M (kolikátý odraz kuličky)",
        title="Počty možných drah (N = $N)",
        size=(900, 600)
    )

    scatter!(plt, [0], [2], markersize=18,
        markercolor=:red,
        markerstrokecolor=:black,
        markerstrokewidth=1.5,)

    quiver!(plt, [0], [1.5], quiver=([0], [-1]),
        linecolor=:red, line=3,
        arrow=true)

    # Labels inside circles
    for (x, y, lbl) in zip(xs, ys, labels)
        annotate!(plt, x, y, text(lbl, 8, :black, halign=:center)) #, valign=:middle))
    end

    # Arrows using quiver!
    for r in 0:(N-1)
        for c in 0:r
            x1, y1 = coords[(r, c)]
            x1=x1 .- 0.5
            y1=y1 .- 0.5

            # left child
            x2, y2 = coords[(r+1, c)]
            x2=x2 .+ 0.2
            y2=y2 .+ 0.7
            quiver!(plt, [x1], [y1], quiver=([x2-x1], [y2-y1]),
                linecolor=:black,
                arrow=true)

            # right child
            x1, y1 = coords[(r, c)]
            x1=x1 .+ 0.5
            y1=y1 .- 0.5
            x3, y3 = coords[(r+1, c+1)]
            x3=x3 .- 0.2
            y3=y3 .+ 0.7
            quiver!(plt, [x1], [y1], quiver=([x3-x1], [y3-y1]),
                linecolor=:black,
                arrow=true)
        end
    end

    plt
end