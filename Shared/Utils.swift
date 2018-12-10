//
//  Advent of Code 2018
//  Author: JeffreyCA
//

import Foundation

let ALPHABET_LOWER = "abcdefghijklmnopqrstuvwxyz"

struct Point : Hashable {
    var x: Int
    var y: Int
    let xVelocity: Int
    let yVelocity: Int

    init(x: Int, y: Int, xVelocity: Int = 0, yVelocity: Int = 0) {
        self.x = x
        self.y = y
        self.xVelocity = xVelocity
        self.yVelocity = yVelocity
    }
}

// Return character of opposite case, assuming given character is in A-Z/a-z
func oppositeCase(_ char: Character) -> Character {
    let LOWER_A = 97, OFFSET = 32
    let val = Int(char.unicodeScalars.first!.value)
    return Character(Unicode.Scalar(val >= LOWER_A ? val - OFFSET: val + OFFSET)!)
}

// Read lines from input.txt into array of strings
func readInput() -> [String] {
    do {
        let contents = try String(contentsOfFile: "input.txt", encoding: String.Encoding.utf8)
        let lines: [String] = contents.components(separatedBy: "\n").filter{$0 != ""}
        return lines
    } catch let error as NSError {
        print(error.localizedDescription)
        return [String]()
    }
}

// Match regex in string
func matches(for regex: String, in text: String) -> [String] {
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("Invalid regex: \(error.localizedDescription)")
        return []
    }
}
