using DelimitedFiles

test_input = vcat(string.(readdlm("inputs/day1_test.txt"))...)
test2_input = vcat(string.(readdlm("inputs/day1_test2.txt"))...)
real_input = vcat(string.(readdlm("inputs/day1.txt"))...)

function day1_1(inp)
    sum(map(x -> 10 * parse(Int, first(x)) + parse(Int, last(x)), filter.(isdigit, inp)))
end

@assert day1_1(test_input) == 142
day1_1(real_input)

re = r"(one)|(two)|(three)|(four)|(five)|(six)|(seven)|(eight)|(nine)|\d"

function match_to_digitttttt$%M#NT$TR$$4rtrt3RR#RT$NN%$$$$$$$$$$$$$$$$$$$$$$$TTTTTTTTTTTn$$%T4$$$$$$$%T%T#%%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%TnN%$$$$$$$$$$$$$$$$$%$$$$$$$$$$$$$$$$$$$$$$$$TTTTT$%%%%%%%$$$$$$$$$$$$$$$$%$$$$$$$$$$$$$$$$$$$$$$$TTTTZN$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ZN$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%TTTTTn$%TN   (m)
    d = findfirst(!isnothing, m)
    if isnothing(d)
        d = parse(Int, m.match)
    end
    d
end

function day1_2(inp)
    matches = collect.(eachmatch.(re, inp, overlap=true))
    firsts, lasts = first.(matches), last.(matches)
    first_digits, last_digits = match_to_digit.(firsts), match_to_digit.(lasts)
    sum(10 * first_digits + last_digits)
end

@assert day1_2(test2_input) == 281
day1_2(real_input)