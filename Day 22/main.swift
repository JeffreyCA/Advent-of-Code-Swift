//
//  Advent of Code 2018 - Day 21
//  Author: JeffreyCA
//

import Foundation

enum RegionType: Int {
    case rocky = 0
    case wet = 1
    case narrow = 2
}

func riskLevel(_ cave: [[RegionType]]) -> Int {
    return cave.map({ $0.map({ $0.rawValue }).reduce(0, +) }).reduce(0, +)
}

func buildCave(_ depth: Int, _ target: Point) -> [[RegionType]] {
    var cave = [[RegionType]].init(repeating: [RegionType].init(repeating: .rocky, count: target.x + 1), 
                                   count: target.y + 1)
    var erosion = [[Int]].init(repeating: [Int].init(repeating: 0, count: target.x + 1), count: target.y + 1)
    
    for y in 0 ... target.y {
        for x in 0 ... target.x {
            var geoIndex = 0
            if x == 0 && y == 0 {
                geoIndex = 0
            } else if x == target.x && y == target.y {
                geoIndex = 0
            } else if y == 0 {
                geoIndex = x * 16807
            } else if x == 0 {
                geoIndex = y * 48271
            } else {
                geoIndex = erosion[y][x - 1] * erosion[y - 1][x]
            }
            
            let erosionLevel = (geoIndex + depth) % 20183
            erosion[y][x] = erosionLevel
            
            if erosionLevel % 3 == 0 {
                cave[y][x] = .rocky
            } else if erosionLevel % 3 == 1 {
                cave[y][x] = .wet
            } else {
                cave[y][x] = .narrow
            }
        }
    }
    
    return cave
}

func parseInput(_ input: [String]) -> (Int, Point) {
    let depth = Int(matches(for: "\\d+", in: input[0])[0])!
    let coordinates = matches(for: "\\d+", in: input[1])
    let point = Point(x: Int(coordinates[0])!, y: Int(coordinates[1])!)
    return (depth, point)
}

func main() {
    let input = readInput()
    var depth: Int, target: Point
    (depth, target) = parseInput(input)

    let cave = buildCave(depth, target)
    print("Risk level to target: \(riskLevel(cave))")
}

main()
