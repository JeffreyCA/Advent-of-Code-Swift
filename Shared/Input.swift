//
//  Advent of Code 2018
//  Author: JeffreyCA
//

import Foundation

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
