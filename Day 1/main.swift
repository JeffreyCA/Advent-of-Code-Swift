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
    
    // Array storing frequency changes
    var freqChange = [Int]()
    // Set storing encountered frequencies
    var set = Set<Int>()
    // Current frequency
    var frequency = 0
    var foundDupe = false
    
    for line in reader {
        autoreleasepool {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            let change = freqChangeToInt(line: trimmed)
            
            frequency += change
            freqChange.append(change)
            
            if set.contains(frequency) {
                print("Duplicate frequency: " + String(frequency))
                foundDupe = true
            }
            set.insert(frequency)
        }
    }
    
    print("Final frequency: " + String(frequency))
    
    if foundDupe {
        return
    }
    
    var index = 0
    
    while true {
        // Loop back to beginning of frequency change list
        if index == freqChange.count {
            index = 0
        }
        
        frequency += freqChange[index]
        
        if set.contains(frequency) {
            print("Duplicate frequency: " + String(frequency))
            break
        }
        
        // Store encountered frequencies in set
        set.insert(frequency)
        index += 1
    }
}

main()
