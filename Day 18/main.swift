//
//  Advent of Code 2018 - Day 18
//  Author: JeffreyCA
//

import Foundation

// Determine number of adjacent acres that are of the given type in a piece of land
func adjacentAcres(_ land: [[Character]], _ type: Character, _ x: Int, _ y: Int) -> Int {
    var adjacent = 0
    
    for curY in (y - 1) ... (y + 1) {
        for curX in (x - 1) ... (x + 1) {
            if (curX != x || curY != y) && curX >= 0 && curX < land[y].count && curY >= 0 && curY < land.count &&
                land[curY][curX] == type {
                adjacent += 1
            }
        }
    }
    
    return adjacent
}

// Simulate evolution of land makign use of cache
func simulate(land: [[Character]], for time: Int) -> [[Character]] {
    var land = land
    var cache = [[[Character]]: Int]()
    
    for currentMinute in 1 ... time {
        var original = land
        
        for y in 0 ..< land.count {
            for x in 0 ..< land[y].count {
                // Handle 3 cases as described in problem
                if original[y][x] == "." && adjacentAcres(original, "|", x, y) >= 3 {
                    land[y][x] = "|"
                } else if original[y][x] == "|" && adjacentAcres(original, "#", x, y) >= 3 {
                    land[y][x] = "#"
                } else if original[y][x] == "#" && (adjacentAcres(original, "#", x, y) == 0 || 
                        adjacentAcres(original, "|", x, y) == 0) {
                    land[y][x] = "."
                }
            }
        }
        
        if let cachedMinute = cache[land] {
            // Previously encountered same land layout, so return the corresponding result
            let diff = currentMinute - cachedMinute
            let offset = (time - cachedMinute) % diff
            let cachedLand = cache.filter({ $0.value == cachedMinute + offset}).first!.key
            land = cachedLand
            break
        } else {
            // Otherwise add current layout to cache
            cache[land] = currentMinute
        } 
    }
    
    return land
}

func main() {
    let input = readInput()
    // 2D Character grid representing acres of land
    var land = [[Character]]()
    
    for line in input {
        land.append(Array(line))
    }
    
    // Part 1
    let afterTen = simulate(land: land, for: 10)
    var woodedAcres = afterTen.map({ $0.filter({ $0 == "|" }).count }).reduce(0, +)
    var lumberyards = afterTen.map({ $0.filter({ $0 == "#" }).count }).reduce(0, +)
    print("Total resource value after 10 minutes: \(woodedAcres * lumberyards)")
    
    // Part 2
    let afterBillion = simulate(land: land, for: 1000000000)
    woodedAcres = afterBillion.map({ $0.filter({ $0 == "|" }).count }).reduce(0, +)
    lumberyards = afterBillion.map({ $0.filter({ $0 == "#" }).count }).reduce(0, +)
    print("Total resource value after 1 billion minutes: \(woodedAcres * lumberyards)")
}


main()
