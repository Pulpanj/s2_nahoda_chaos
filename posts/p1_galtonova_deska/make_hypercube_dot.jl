using Printf

#-------------------------------------------------------------------------------
# generuj graphviz soubor obsahujici  popis hyperkrychle 
#-------------------------------------------------------------------------------


function make_hypercube_dot(N::Int; filename="graph3.dot")
    # Generate all N-bit strings
    nodes = [bitstring(i)[(end-N+1):end] for i in 0:(2^N-1)]

    # Hamming distance between two bitstrings (as Strings)
    hamming(a::AbstractString, b::AbstractString) =
        count(t -> t[1] != t[2], zip(a, b))

    # r = (number of 1 bits)
    nr(x) = count(==('1'), x)

    # Color scale: blue → white → red
    function color_for(x)
        r = nr(x)
        t = r / (N)   # normalize to 0–1

        if t < 0.5
            u = t / 0.5
            R = round(Int, 255*u)
            G = round(Int, 255*u)
            B = 255
        else
            u = (t - 0.5) / 0.5
            R = 255
            G = round(Int, 255*(1-u))
            B = round(Int, 255*(1-u))
        end

        return @sprintf("#%02x%02x%02x", R, G, B)
    end

    open(filename, "w") do io
        write(io, "digraph G {\n")
        write(io, "  graph [layout=neato;nodesep=4.0];\n")
        write(io, "  node [fontsize=4 width=0.28 height=0.28 fixedsize=true shape=circle style=filled];\n\n")
        write(io, "  edge [fontsize=6 penwidth=0.4 arrowsize=0.4];\n\n")

        # Emit nodes with label + color
        for n in nodes
            r = nr(n)
            col = color_for(n)
            lbl = "$(n)\\nR=$(r)"
            write(io, "  \"$n\" [label=\"$lbl\", fillcolor=\"$col\"]; \n")
        end
        write(io, "\n")

        # Emit edges for Hamming distance 1
        for i in 1:length(nodes)
            for j in (i+1):length(nodes)
                if hamming(nodes[i], nodes[j]) == 1
                    write(io, "  \"$(nodes[i])\" -> \"$(nodes[j])\" [dir=both];\n")
                end
            end
        end

        write(io, "}\n")
    end

    # println("DOT file written to $filename")
end
