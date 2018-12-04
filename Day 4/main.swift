//
//  Advent of Code 2018 - Day 4
//  Author: JeffreyCA
//

import Foundation

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

func getMinute(_ line: String) -> Int {
    let match = Int(matches(for: "(?<=:)(\\d+)", in: line)[0])!
    return match
}

func getGuard(_ line: String) -> Int {
    let match = Int(matches(for: "(?<=#)(\\d+)", in: line)[0])!
    let guardId = Int(line.components(separatedBy: " ")[3][1...])!
    assert(match == guardId)
    return match
}

func main() {
    let lines = readInput()
    let sorted = lines.sorted()
    var dict = Dictionary<Int, (Int, [Int])>()
    
    var guardId = 0
    var beginSleep = 0
    
    for line in sorted {
        let minute = getMinute(line)
        
        if line.contains("begins shift") {
            guardId = getGuard(line)
            
            if dict[guardId] == nil {
                dict[guardId] = (0, [Int](repeating: 0, count: 60))
            }
        } else if line.contains("falls asleep") {
            beginSleep = minute
        } else if line.contains("wakes up") {
            dict[guardId]?.0 += minute - beginSleep + 1
            for i in beginSleep ... minute {
                dict[guardId]?.1[i] += 1
            }
        }
    }
    
    let maxKeyValue = dict.max { a, b in a.value.0 < b.value.0 }!
    let maxGuardId = maxKeyValue.key
    let maxMinute = maxKeyValue.value.1.enumerated().max(by: {$0.element < $1.element})!.offset
    print("Guard: \(maxGuardId), minute: \(maxMinute)")
    print("Answer: \(maxGuardId * maxMinute)")
    
    
}

main()
