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
    # we'll say these ranges are a:b and c:d
    a, b, c, d = first(r1), last(r1), first(r2), last(r2)
    if (a > d) || (b < c)
        # no overlap; r1 is fine as it is
        return [r1]
    elseif (a >= c) && (b <= d)
        # r1 is completely contained in r2; everything gets removed
        return []
    elseif (a < c) && (b > d)
        # r2 is completely contained in r1; the middle bit gets removed
        return [a:(c-1), (d+1):b]
    elseif (a < c) && (b <= d)
        # overlap on the left end
        return [a:(c-1)]
    elseif (a >= c) && (d < b)
        # overlap on the right end
        return [(d+1):b]
    else
        throw("should be unreachable")
    end
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
    new_ranges = UnitRange{Int64}[]
    unchanged_ranges = UnitRange{Int64}[]
    changed_ranges = UnitRange{Int64}[]
    for row in map_matrix
        for idx_range in index_ranges
            test_range = row[2]:(row[2]+row[3]-1)
            unchanged = setdiffr(idx_range, test_range)
            changed = intersect(idx_range, test_range)
            push!(unchanged_ranges, unchanged...)
            push!(changed_ranges, changed)
            push!(new_ranges, changed .+ (row[1] - row[2]))
        end
    end
    changed_ranges = filter(x -> length(x) > 0, changed_ranges)
    unchanged_ranges = setdiff(unchanged_ranges, changed_ranges)
    for cr in changed_ranges
        unchanged_ranges_diff = []
        for ur in unchanged_ranges
            push!(unchanged_ranges_diff, setdiffr(ur, cr)...)
        end
        unchanged_ranges = filter(x -> length(x) > 0, unchanged_ranges_diff)
    end
    filter(x -> length(x) > 0, union(new_ranges, unchanged_ranges))
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

function day5_2_slow(indices, maps, map_keys)
    for k in map_keys
        indices = map_to_next(indices, maps[k])
    end
    minimum(indices)
end

day5_2_slow(union(seed_ranges(test_input)...), map_matrices(test_input)...)

function day5_2(inp)
    index_ranges = seed_ranges(inp)
    maps, map_keys = map_matrices(inp)
    for k in map_keys
        index_ranges = map_ranges_to_next(index_ranges, maps[k])
    end
    minimum(first.(index_ranges))
end

day5_2(test_input)
day5_2(real_input)