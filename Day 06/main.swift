//
//  Advent of Code 2018 - Day 6
//  Author: JeffreyCA
//

import Foundation

func manhattanDist(_ x1: Int, _ y1: Int, _ x2: Int, _ y2: Int) -> Int {
    return abs(x1 - x2) + abs(y1 - y2)
}

func main() {
    let line = readInput()
    let coordinates : [Point] = line.map { (str) -> Point in
        let split = str.components(separatedBy: ", ")
        return Point(x: Int(split[0])!, y: Int(split[1])!)
    }
    
    var maxX = Int.min, maxY = Int.min
    var minX = Int.max, minY = Int.max
    var map = Dictionary<Point, (Bool, Int)>()
    
    for point in coordinates {
        let x = point.x, y = point.y
        map[point] = (false, 0)
        
        if x > maxX {
            maxX = x
        }
        if y > maxY {
            maxY = y
        }
        if x < minX {
            minX = x
        }
        if y < minY {
            minY = y
        }
    }
    
    for x in minX ... maxX {
        for y in minY ... maxY {
            var tie = false
            var minDist = Int.max
            var minPoint = Point(x: 0, y: 0)
            
            for point in coordinates {
                let dist = manhattanDist(x, y, point.x, point.y)
                
                if dist < minDist {
                    minDist = dist
                    minPoint = point
                    tie = false
                } else if dist == minDist {
                    tie = true
                }
            }
            
            if !tie && (x == minX || x == maxX || y == minY || y == maxY) {
                map[minPoint]?.0 = true
            } else if !tie {
                map[minPoint]?.1 += 1
            }
        }
    }
    
    var max = 0
    
    for point in coordinates {
        if !map[point]!.0 && map[point]!.1 > max {
            max = map[point]!.1
        }
    }
    
    print("Max: \(max)")
}

main()
