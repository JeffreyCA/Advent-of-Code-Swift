//
//  Advent of Code 2018 - Day 4
//  Author: JeffreyCA
//

import Foundation

// Parse line to get the minute (0 - 59)
func getMinute(_ line: String) -> Int {
    let minute = Int(matches(for: "(?<=:)(\\d+)", in: line)[0])!
    return minute
}

// Parse line to get the guard ID
func getGuard(_ line: String) -> Int {
    let guardId = Int(matches(for: "(?<=#)(\\d+)", in: line)[0])!
    return guardId
}

func main() {
    let lines = readInput()
    let sorted = lines.sorted()
    
    // Dict of guard data, maps guard ID to tuple of sleep time and frequency array
    // of number of times asleep at each minute (0 - 59)
    var dict = Dictionary<Int, (Int, [Int])>()
    
    // Current guard ID being processed
    var curGuardId = 0
    // Minute at which current guard begins to sleep
    var beginSleep = 0
    // Max number of times a guard is asleep during a minute
    var mostFreqCount = 0
    // Specific minute during which a guard is asleep the most number of times
    var mostFreqMinute = 0
    // Guard ID of guard who is asleep the most number of times during a minute
    var mostFreqGuardId = 0
    
    for line in sorted {
        let minute = getMinute(line)
        
        if line.contains("begins shift") {
            // Process new or existing guard
            curGuardId = getGuard(line)
            // Add entry to dict if non-existant
            if dict[curGuardId] == nil {
                dict[curGuardId] = (0, [Int](repeating: 0, count: 60))
            }
        } else if line.contains("falls asleep") {
            // Update time at which current guard begins sleeping
            beginSleep = minute
        } else if line.contains("wakes up") {
            // Calculate time asleep for current guard
            dict[curGuardId]?.0 += minute - beginSleep + 1
            
            for i in beginSleep ... minute {
                // Update frequency array for current guard
                dict[curGuardId]?.1[i] += 1
                
                if (dict[curGuardId]?.1[i])! > mostFreqCount {
                    // Track the most frequent minute spent asleep by a guard
                    // across all guards (Part 2)
                    mostFreqMinute = i
                    mostFreqCount = (dict[curGuardId]?.1[i])!
                    mostFreqGuardId = curGuardId
                }
            }
        }
    }
    
    // Part 1 calculations
    let maxKeyValue = dict.max { a, b in a.value.0 < b.value.0 }!
    let mostSleepGuardId = maxKeyValue.key
    let mostSleepMinute = maxKeyValue.value.1.enumerated().max(by: {$0.element < $1.element})!.offset
    
    print("Guard with most sleep: \(mostSleepGuardId), Minute with most sleep: \(mostSleepMinute)")
    print("Strategy 1: \(mostSleepGuardId * mostSleepMinute)")
    // Part 2 calculation
    print("Most frequent minute spent asleep: \(mostFreqMinute), Guard: \(mostFreqGuardId)")
    print("Strategy 2: \(mostFreqMinute * mostFreqGuardId)")
}

main()
