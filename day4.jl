using DelimitedFiles

test_input = readdlm("inputs/day4_test.txt",'|')
real_input = readdlm("inputs/day4.txt",'|')

parse_line(r) = map(x -> parse.(Int, x), filter.(!isempty, split.(r, isspace)))
winning_and_hand(inp) = parse_line(getindex.(split.(string.(inp[:,1]), ':'), 2)), parse_line(inp[:,2])
day4_1(inp) = mapreduce(x -> x > 0 ? 2^(x-1) : 0, +, length.(intersect.(winning_and_hand(inp)...)))

day4_1(test_input)
day4_1(real_input)

function day4_2(inp)
    scores = length.(intersect.(winning_and_hand(inp)...))
    card_inalities = ones(Int, size(inp, 1))
    for (i, s) in enumerate(scores)
        card_inalities[(i+1):(i+s)] .+= card_inalities[i]
    end
    sum(card_inalities)
end

day4_2(test_input)
day4_2(real_input)