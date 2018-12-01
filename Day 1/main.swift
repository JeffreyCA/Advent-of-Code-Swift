//
//  Advent of Code 2018 - Day 1
//  Author: JeffreyCA
//

import Foundation

let x = LineReader(path: "input.txt")

guard let reader = x else {
    throw NSError(domain: "FileNotFound", code: 404, userInfo: nil)
}


for line in reader {
    autoreleasepool {
        print(line.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
