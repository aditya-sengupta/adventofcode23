using DelimitedFiles
using Base: product

test_input = split.(readdlm("inputs/day2_test.txt", ':')[:,2], (x -> x == ',' || x == ';'))
real_input = split.(readdlm("inputs/day2.txt", ':')[:,2], (x -> x == ',' || x == ';'))

lookup = Dict("red" => 12, "green" => 13, "blue" => 14)

function day2_1(inp)
    total = 0
    len = length(inp)
    for (i, row) in enumerate(inp)
        for el in row
            number, color = split(strip(el))
            number = parse(Int, number)
            if number > lookup[color]
                total += i
                break
            end
        end
    end
    len * (len + 1) ÷ 2 - total
end

day2_1(test_input)
day2_1(real_input)

function day2_2(inp)
    total = 0
    for row in inp
        min_cubes = Dict("red" => 0, "green" => 0, "blue" => 0)
        for el in row
            number, color = split(strip(el))
            number = parse(Int, number)
            min_cubes[color] = max(min_cubes[color], number)
        end
        total += prod(values(min_cubes))
    end
    total
end

day2_2(test_input)
day2_2(real_input)