//
//  Advent of Code 2018 - Day 12
//  Author: JeffreyCA
//

import Foundation

// Parse input into initial state and dictionary of rules
func parseInput(_ lines: [String]) -> (String, [String: String]) {
    let initialState = matches(for: "(?<=initial state: ).*", in: lines[0])[0]
    var rules = [String: String]()
    
    for index in 1 ..< lines.count {
        let state = matches(for: "[.#]+", in: lines[index])
        rules[state[0]] = state[1]
    }
    
    return (initialState, rules)
}

// Run simulate with given rules and initial state for given amount of generations
func simulate(with rules: [String: String], startingWith initialState: String, for generations: Int) -> Int {
    var zeroIndex = 0
    var previousSum = 0
    var diff = 0
    var currentState = initialState
    var sum = 0
    
    for gen in 1 ... generations {
        currentState = "....." + currentState + "....."
        zeroIndex += 5
        
        let start = 2, end = currentState.count - 5
        var nextState = currentState
        
        // Build next generation state by matching each substring of 5 with a rule
        for mid in start ... end {
            if let result = rules[currentState[mid - 2 ... mid + 2]] {
                // Replace character at 'mid' with rule definition
                nextState = nextState[..<mid] + result + nextState[(mid + 1)...]
            }
        }
        
        // Calculate sum of indices the next state
        sum = 0
        for index in 0 ..< nextState.count {
            if nextState[index] == "#" {
                sum += (index - zeroIndex)
            }
        }
        
        // Encounter consecutive sums with the same difference
        // Manually calculate the overall sum
        if sum - previousSum == diff {
            return (generations - gen) * diff + sum
        }
        
        currentState = nextState
        diff = sum - previousSum
        previousSum = sum
    }
    
    return sum
}

func main() {
    let lines = readInput()
    let (initialState, rules) = parseInput(lines)
    
    print("Sum after 20 generations: \(simulate(with: rules, startingWith: initialState, for: 20))")
    print("Sum after 50000000000 generations: \(simulate(with: rules, startingWith: initialState, for: 50000000000))")
}

main()
