//
//  Advent of Code 2018 - Day 5
//  Author: JeffreyCA
//

import Foundation

// Determine length of polymer after reduction
func reactPolymerLength(_ polymer: String) -> Int {
    var stack = [Character]()
    for unit in polymer {
        if !stack.isEmpty && stack.last == oppositeCase(unit) {
            _ = stack.popLast()
        } else {
            stack.append(unit)
        }
    }
    return stack.count
}

func main() {
    let polymer = readInput().first!
    var minReactLength = reactPolymerLength(polymer)
    var minRemovedType: Character = " "
    print("Length after reaction: \(minReactLength)")
    
    // Part 2: Try removing every character from A-Z/a-z to get minimum reaction length
    for char in ALPHABET_LOWER {
        let result = polymer.replacingOccurrences(of: String(char), with: "", options: .caseInsensitive)
        let reactLength = reactPolymerLength(result)
        
        if reactLength < minReactLength {
            minReactLength = reactLength
            minRemovedType = char
        }
    }
    
    print("Shortest length after reaction: \(minReactLength), " +
        "removed type: \(oppositeCase(minRemovedType))/\(minRemovedType)")
}

main()
