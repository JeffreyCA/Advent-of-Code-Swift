//
//  Advent of Code 2018
//  Author: JeffreyCA
//

import Foundation

let ALPHABET_LOWER = "abcdefghijklmnopqrstuvwxyz"

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
