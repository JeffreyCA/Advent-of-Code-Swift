//
//  Advent of Code 2018 - Day 5
//  Author: JeffreyCA
//

import Foundation

func oppositeCase(_ char: Character) -> Character {
    let LOWER_A = 97, UPPER_LOWER_OFFSET = 32
    let val = Int(char.unicodeScalars.first!.value)
    return Character(Unicode.Scalar(val >= LOWER_A ? val - UPPER_LOWER_OFFSET: val + UPPER_LOWER_OFFSET)!)
}

func reactPolymerLength(_ str: String) -> Int {
    var stack = [Character]()
    for c in str {
        if !stack.isEmpty && stack.last == oppositeCase(c) {
            _ = stack.popLast()
        } else {
            stack.append(c)
        }
    }
    return stack.count
}

func main() {
    let line = readInput()[0]
    var minLength = reactPolymerLength(line)
    var minLengthRemovedChar: Character = " "
    
    print("Shortest polymer length: \(minLength)")
    
    for char in ALPHABET_LOWER {
        let upper = oppositeCase(char)
        let regexp: String = "\(char)|\(upper)"
        let result = line.replacingOccurrences(of: regexp, with: "",
                                               options: [.regularExpression, .caseInsensitive])
        let reactLength = reactPolymerLength(result)
        if reactLength < minLength {
            minLength = reactLength
            minLengthRemovedChar = char
        }
    }
    
    print("Min Length: \(minLength), char: \(minLengthRemovedChar)")
}

main()
