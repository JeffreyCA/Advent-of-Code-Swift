//
//  Advent of Code 2018 - Day 1
//  Author: JeffreyCA
//

import Foundation

func main() {
    do {
        let contents = try String(contentsOfFile: "input.txt", encoding: String.Encoding.utf8)
        let lines: [String] = contents.components(separatedBy: "\n").filter{$0 != ""}
        
        // Array storing frequency changes
        var freqChange = [Int]()
        // Set storing encountered frequencies
        var set = Set<Int>()
        // Current frequency
        var frequency = 0
        var foundDupe = false
        
        for line in lines {
            let change = Int(line)!
            frequency += change
            freqChange.append(change)
            
            if set.contains(frequency) {
                print("Duplicate frequency: " + String(frequency))
                foundDupe = true
            }
            set.insert(frequency)
        }
        
        print("Final frequency: " + String(frequency))
        
        if foundDupe {
            return
        }
        
        var index = 0
        
        while true {
            // Loop back to beginning of frequency change list
            frequency += freqChange[index]
            
            if set.contains(frequency) {
                print("Duplicate frequency: " + String(frequency))
                break
            }
            
            // Store encountered frequencies in set
            set.insert(frequency)
            index += 1
            index %= freqChange.count
        }
    } catch let error as NSError {
        print(error.localizedDescription)
    }
}

main()
