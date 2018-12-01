//
//  Advent of Code 2018 - Day 1
//  Author: JeffreyCA
//

import Foundation

func freqChangeToInt(line: String) -> Int {
    if line[0] == "+" {
        return Int(line[1...])!
    } else if line[0] == "-" {
        return -Int(line[1...])!
    }
    return 0
}

func main() {
    let lineReader = LineReader(path: "input.txt")
    
    guard let reader = lineReader else {
        print("File not found")
        return
    }
    
    var frequency = 0
    
    for line in reader {
        autoreleasepool {
            let line = line.trimmingCharacters(in: .whitespacesAndNewlines)
            frequency += freqChangeToInt(line: line)
        }
    }
    
    print(frequency)
}

main()
