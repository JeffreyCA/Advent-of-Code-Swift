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

func main() {
    let line = readInput()[0]
    var stack = [Character]()
    
    for c in line {
        if !stack.isEmpty && stack.last == oppositeCase(c) {
            stack.popLast()
        } else {
           stack.append(c)
        }
    }
    print("Shortest polymer length: \(stack.count)")
}

main()
