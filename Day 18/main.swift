//
//  Advent of Code 2018 - Day 18
//  Author: JeffreyCA
//

import Foundation

func adjacentAcres(_ land: [[Character]], _ type: Character, _ x: Int, _ y: Int) -> Int {
    var adjacent = 0
    
    if y - 1 >= 0 && land[y - 1][x] == type {
        adjacent += 1
    }
    
    if y - 1 >= 0 && x + 1 < land[y].count && land[y - 1][x + 1] == type {
        adjacent += 1
    }
    
    if x + 1 < land[y].count && land[y][x + 1] == type {
        adjacent += 1
    }
    
    if x + 1 < land[y].count && y + 1 < land.count && land[y + 1][x + 1] == type {
        adjacent += 1
    }
    
    if y + 1 < land.count && land[y + 1][x] == type {
        adjacent += 1
    }
    
    if y + 1 < land.count && x - 1 >= 0 && land[y + 1][x - 1] == type {
        adjacent += 1
    }
    
    if x - 1 >= 0 && land[y][x - 1] == type {
        adjacent += 1
    }
    
    if x - 1 >= 0 && y - 1 >= 0 && land[y - 1][x - 1] == type {
        adjacent += 1
    }
    
    return adjacent
}

func main() {
    let input = readInput()
    var land = [[Character]]()
    
    for line in input {
        land.append(Array(line))
    }
    
    for _ in 1 ... 10 {
        var original = land
        
        for y in 0 ..< land.count {
            for x in 0 ..< land[y].count {
                if original[y][x] == "." && adjacentAcres(original, "|", x, y) >= 3 {
                    land[y][x] = "|"
                } else if original[y][x] == "|" && 
                    adjacentAcres(original, "#", x, y) >= 3 {
                    land[y][x] = "#"
                } else if original[y][x] == "#" && 
                    (adjacentAcres(original, "#", x, y) == 0 || 
                    adjacentAcres(original, "|", x, y) == 0) {
                    land[y][x] = "."
                }
                
                
            }
        }
    }
    
    let woodedAcres = land.map({ $0.filter({ $0 == "|" }).count }).reduce(0, +)
    let lumberyards = land.map({ $0.filter({ $0 == "#" }).count }).reduce(0, +)
    
    print("Wooded acres: \(woodedAcres)")
    print("Lumberyards: \(lumberyards)")
    print("Total resource value: \(woodedAcres * lumberyards)")
}


main()
