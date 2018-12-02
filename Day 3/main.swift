//
//  Advent of Code 2018 - Day 3
//  Author: JeffreyCA
//

import Foundation

func main() {
    do {
        let contents = try String(contentsOfFile: "input.txt", encoding: String.Encoding.utf8)
        let words: [String] = contents.components(separatedBy: "\n").filter{$0 != ""}
        print(contents)
    } catch let error as NSError {
        print(error.localizedDescription)
    }
}

main()
