//
//  Advent of Code 2018 - Day 1
//  Author: JeffreyCA
//

import Foundation

func main() {
    let lines = readInput()
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
            print("Duplicate frequency: \(frequency)")
            foundDupe = true
        }
        set.insert(frequency)
    }
    
    print("Final frequency: \(frequency)")
    
    if foundDupe {
        return
    }
    
    var index = 0
    
    while true {
        // Loop back to beginning of frequency change list
        frequency += freqChange[index]
        
        if set.contains(frequency) {
            print("Duplicate frequency: \(frequency)")
            break
        }
        
        // Store encountered frequencies in set
        set.insert(frequency)
        index += 1
        index %= freqChange.count
    }
}

main()
