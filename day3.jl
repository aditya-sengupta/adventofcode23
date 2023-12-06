using DelimitedFiles

test_input = permutedims(hcat(split.(readdlm("inputs/day3_test.txt"), "")...), (2, 1)) .|> only
real_input = permutedims(hcat(split.(readdlm("inputs/day3.txt"), "")...), (2, 1)) .|> only

or = (x, y) -> (x || y)

function is_adjacent(coord::CartesianIndex{2}, i1, i2)
    return abs(coord[1] - i1) < 2 && abs(coord[2] - i2) < 2
end

function any_adjacent(coords::Vector{CartesianIndex{2}}, i1, i2)
    return any(is_adjacent.(coords, i1, i2))
end

function get_index_ranges(row)
    number_indices = findall(isdigit, row)
    split_points = findall(diff(number_indices) .> 1)
    s = 1
    number_index_ranges = []
    for p in split_points
        push!(number_index_ranges, number_indices[s:p])
        s = p + 1
    end
    push!(number_index_ranges, number_indices[s:end])
    number_index_ranges
end

function day3_1(inp)
    special_characters = findall(x -> x != '.' && !isdigit(x), inp)
    total = 0
    for (i, row) in enumerate(eachrow(inp))
        for r in get_index_ranges(row)
            if length(r) > 0
                closest = mapreduce(j -> any_adjacent(special_characters, i, j), or, r)
                total += closest * parse(Int, string(row[r]...))
            end
        end
    end
    total
end

day3_1(test_input)
day3_1(real_input)

function day3_2(inp)
    d = Dict()
    gears = findall(x -> x == '*', inp)
    for (i, row) in enumerate(eachrow(inp))
        for r in get_index_ranges(row)
            if length(r) > 0
                adjacency = mapreduce(j -> is_adjacent.(gears, i, j), +, r)
                gear_index = findfirst(adjacency .> 0)
                number = parse(Int, string(row[r]...))
                d[gear_index] = push!(get(d, gear_index, []), number)
            end
        end
    end
    mapreduce(prod, +, filter(x -> length(x) == 2, collect(values(d))))
end

day3_2(test_input)
day3_2(real_input)