//
//  Advent of Code 2018 - Day 12
//  Author: JeffreyCA
//

import Foundation

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

func main() {
    let lines = readInput()
    var initialState = matches(for: "(?<=initial state: ).*", in: lines[0])[0]
    
    var rules = [String : String]()
    
    for index in 1 ..< lines.count {
        let state = matches(for: "[.#]+", in: lines[index])
        rules[state[0]] = state[1]
    }
    
    var zeroIndex = 0
    var previousSum = 0
    var diff = 0
    
    for gen in 1 ... 50000000000 {
        initialState = "....." + initialState + "....."
        var newState = initialState
        let end = initialState.count - 5
        zeroIndex += 5
        
        for mid in 2 ... end {
            if let result = rules[initialState[mid - 2 ... mid + 2]] {
                newState = newState[..<mid] + result + newState[(mid + 1)...]
            }
        }
        
        initialState = newState
        
        var sum = 0
        for (index, _) in initialState.enumerated() {
            if initialState[index] == "#" {
                sum += (index - zeroIndex)
            }
        }
        
        if sum - previousSum == diff {
            print("Break at \(gen)")
            break
        }
        
        diff = sum - previousSum
        previousSum = sum
        print(sum)
    }
    
    var sum = 0
    
    for (index, _) in initialState.enumerated() {
        if initialState[index] == "#" {
            sum += (index - zeroIndex)
        }
    }
    
    print(sum)
}

main()
