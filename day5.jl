using DelimitedFiles

test_input = readdlm("inputs/day5_test.txt", '\n')
real_input = readdlm("inputs/day5.txt", '\n')

function seed_numbers(inp)
    parse.(Int, split(strip(first(inp)[7:end]), isspace))
end

function seed_ranges(inp)
    numbers = seed_numbers(inp)
    [x:(x+y-1) for (x, y) in zip(numbers[begin:2:end], numbers[begin+1:2:end])]
end

function setdiffr(r1, r2)
    # max(first(r1), first(r2)):min(last(r1), last(r2))
end

function map_matrices(inp)
    maps = Dict()
    map_keys = []
    current_map_type = ""
    for l in inp[2:end]
        if occursin("map", l)
            current_map_type = first(split(l, isspace))
            push!(map_keys, current_map_type)
        else
            maps[current_map_type] = push!(get(maps, current_map_type, []), parse.(Int, split(l)))
        end
    end
    maps, map_keys
end

function map_to_next(indices, map_matrix)
    new_indices = -ones(Int, length(indices))
    for row in map_matrix
        for (i, idx) in enumerate(indices)
            if row[2] <= idx < row[2] + row[3]
                new_indices[i] = idx + (row[1] - row[2])
            end
        end
    end
    unchanged = findall(new_indices .== -1)
    new_indices[unchanged] .= indices[unchanged]
    new_indices
end

function map_ranges_to_next(index_ranges, map_matrix)
    for row in map_matrix
        new_ranges = []
        for (i, idx_range) in enumerate(index_ranges)
            if length(intersect(idx_range, row[2]:(row[2]+row[3]))) == 0
                push!(new_ranges, idx_range)
            else
                @show idx_range, row
            end
        end
        index_ranges = copy(new_ranges)
    end
    index_ranges
end

function day5_1(inp)
    indices = seed_numbers(inp)
    maps, map_keys = map_matrices(inp)
    for k in map_keys
        indices = map_to_next(indices, maps[k])
    end
    minimum(indices)
end

day5_1(test_input)
day5_1(real_input)

function day5_2(inp)
    index_ranges = seed_ranges(inp)
    maps, map_keys = map_matrices(inp)
    for k in map_keys
        index_ranges = map_ranges_to_next(index_ranges, maps[k])
    end
    index_ranges
    # minimum(first.(index_ranges))
end

day5_2(test_input)