#!/usr/bin/env ruby

require 'set'

@p1cards = [4,25,3,11,2,29,41,23,30,21,50,8,1,24,27,10,42,43,38,15,18,13,32,37,34]
@p2cards = [12,6,36,35,40,47,31,9,46,49,19,16,5,26,39,48,7,44,45,20,17,14,33,28,22]

# play one game
def play_simple(p1cards, p2cards)
    winner = nil
    while p1cards.length > 0 && p2cards.length > 0 do
        c1 = p1cards.shift
        c2 = p2cards.shift
        if c1 > c2
            p1cards.push(c1)
            p1cards.push(c2)
            winner = 1
        elsif c2 > c1
            p2cards.push(c2)
            p2cards.push(c1)
            winner = 2
        end
    end
    {w: winner, p1: p1cards, p2: p2cards}
end

@total_games = 0

# play games using recursion
def play_recursive(p1cards, p2cards, rootgame = false)
    @total_games += 1
    winner = nil
    history = Set.new
    while p1cards.length > 0 && p2cards.length > 0 do
        c1 = p1cards.shift
        c2 = p2cards.shift
        if c1 > p1cards.length or c2 > p2cards.length
            # not enough cards for someone; standard game rules
            if c1 > c2
                p1cards.push(c1)
                p1cards.push(c2)
                winner = 1
            elsif c2 > c1
                p2cards.push(c2)
                p2cards.push(c1)
                winner = 2
            end
        else
            # new sub-game must be played
            subresult = play_recursive(
                p1cards.slice(0,c1),
                p2cards.slice(0,c2)
            )
            if subresult[:w] == 1
                p1cards.push(c1)
                p1cards.push(c2)
                winner = 1
            else
                p2cards.push(c2)
                p2cards.push(c1)
                winner = 2
            end
        end

        # check state against history
        state = [p1cards, p2cards]
        if history.include? state
            # infinite recursion point, player 1 wins (sub-)game immediately
            return {w: 1, p1: p1cards}
        end
        history.add(state)
    end
    return rootgame ? {w: winner, p1: p1cards, p2: p2cards} : {w: winner}
end

# converts result object into numeric score
def get_score(result)
    winning_cards = result[:w] == 1 ? result[:p1] : result[:p2]
    winning_cards.reverse!
    winner_sum = winning_cards.map.with_index{ |c,i| c * (i+1) }.reduce(&:+)
end

# part 1 - 33421
p "p1: #{get_score(play_simple(@p1cards.dup, @p2cards.dup))}"

# part 2 - 33651
p "p2: #{get_score(play_recursive(@p1cards.dup, @p2cards.dup, true))}"
p "#{@total_games} games played!"
