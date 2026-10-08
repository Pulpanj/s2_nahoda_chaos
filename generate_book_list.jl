# generate html table from book list dictionary
function generate_book_list(book_list)
    function html_escape(s::AbstractString)
        # Order matters: escape & first to avoid double-escaping
        s = replace(s, "&" => "&amp;")
        s = replace(s, "<" => "&lt;")
        s = replace(s, ">" => "&gt;")
        s = replace(s, "\"" => "&quot;")
        s = replace(s, "'" => "&#39;")
        s = replace(s, "\u00A0" => "&nbsp;")   # optional: non-breaking space
        return s
    end

    function write_book(io, book)
        if haskey(book, "label")
            println(io, "<tr> <th colspan=3 style='width:100%;color: black;background-color: #cecece;font-size:1.5em;' >")
            # println(io, "<tr> <th colspan=3 style='width:100%;' >")
            println(io, "$(book["label"])")
            println(io, "</th></tr>")
            # println(io, "<tr style='background-color: white;'>")
            println(io, "<tr>")
            println(io, "<td colspan=3 style='height:0px;padding: 0px;'></td>")
            println(io, "</tr>")
            # println(io, "<tr style='background-color: white;'>")
            # println(io, "<td colspan=3 style='height:0px;padding: 0px;'></td>")
            # println(io, "</tr>")

        else
            # print image
            if haskey(book, "cover")
                cover_url = book["cover"]
                delete!(book, "cover")
            else
                cover_url = "/images/pdf_icon.png"
            end

            if haskey(book, "Book URL")
                book_url = book["Book URL"]
                delete!(book, "Book URL")
            elseif haskey(book, "URL")
                book_url = book["URL"]
            elseif haskey(book, "PDF")
                    book_url = book["PDF"]
            else
                    book_url = ""
            end

            n_fields = length(keys(book))

            for (i, key) in enumerate(keys(book))
                println(io, "<tr style='background-color: white;'>")
                safe_html_str = html_escape(book[key])
                if i == 1
                    if book_url != ""
                        println(io, "<td rowspan='$n_fields' style='width:10%' width='1in'>")
                        println(io, "<a href='$book_url'>")
                        println(io, "<img src='$cover_url' width='1in' style='border:3px solid orange;width:1in;'>")
                        println(io, "</a>\n</td>")
                    else
                        println(io, "<td rowspan='$n_fields' style='width:10%' width='1in'>\n<img src='$cover_url' width='1in'></td>")
                    end
                end
                if key in ["PDF", "URL"]
                    println(io, "<td style='width:15%;font-weight:bold;text-align:right;'>$(key):</td>")
                    println(io, "<td style='width:75%'><a href='$(book[key])'>\n$(book[key])\n</a> </td>")
                elseif key in ["Název", "Title"]
                    println(io, "<td style='width:15%;font-weight:bold;text-align:right;'>$(key):</td>")
                    println(io, "<td style='width:75%;font-weight:bold;'>$(safe_html_str)</td>")
                elseif key in ["Link"]
                    println(io, "<td style='width:15%;font-weight:bold;text-align:right;'>$(key):</td>")
                    println(io, "<td style='width:75%'>$(book[key])</td>")
                else
                    println(io, "<td style='width:15%;font-weight:bold;text-align:right;'>$(key):</td>")
                    println(io, "<td style='width:75%'>$(safe_html_str)</td>")
                end
                println(io, "</tr>")
            end
            if n_fields % 2 == 0
                println(io, "<tr>")
                println(io, "<td colspan=3 style='height:0px;padding: 0px;'></td>")
                println(io, "</tr>")
            end
            println(io, "<tr>")
            println(io, "<th colspan=3 style='height:10px;padding: 0px;'></th>")
            println(io, "</tr>")
        end
    end

    io = IOBuffer()
    # open(filename, "w") do io
    println(io, "```{=html}")
    println(io, "<table class='bordered'>")
    # data-quarto-disable-processing='true' class='bordered literature_table'

    println(io, "<tbody  style='border:1px solid black !important;'>")
    println(io, "<tr style='background-color: white;'>")
    println(io, "<td colspan=3 style='height:0px;padding: 0px;'></td>")
    println(io, "</tr>")

    for t in book_list
        write_book(io, t)
    end

    println(io, "</tbody></table>")
    println(io, "```")
    println(String(take!(io)))
    # end
end
