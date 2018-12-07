//
//  Advent of Code 2018 - Day 6
//  Author: JeffreyCA
//

import Foundation

// Compute the Manhattan distance between (x1, y1) and (x2, y2)
func manhattanDistance(_ x1: Int, _ y1: Int, _ x2: Int, _ y2: Int) -> Int {
    return abs(x1 - x2) + abs(y1 - y2)
}

// Determine boundary points (minimum & maximum x and y values) from the list of coordinates
func computeBoundary(_ coordinates: [Point]) -> (Int, Int, Int, Int) {
    // Keep track of tight boundary around points
    // Note: Any point on the boundary will have infinite area
    var maxX = Int.min, maxY = Int.min
    var minX = Int.max, minY = Int.max
    
    for point in coordinates {
        let x = point.x, y = point.y
        
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
    
    return (minX, maxX, minY, maxY)
}

// Determine whether (x, y) lies on the boundary
func isOnBoundary(_ x: Int, _ y: Int, _ minX: Int, _ maxX: Int, _ minY: Int, _ maxY: Int) -> Bool{
    return (x == minX || x == maxX || y == minY || y == maxY)
}

func main() {
    let lines = readInput()
    let coordinates : [Point] = lines.map { (str) -> Point in
        let split = str.components(separatedBy: ", ")
        return Point(x: Int(split[0])!, y: Int(split[1])!)
    }
    
    // Dictionary of coordinates to tuples which store whether its area of influence is infinite, and the exact area
    // it influences (if finite)
    //
    // For part 1 we want to return the maximum finite area of influence of a coordinate (Bool should be false)
    var dict = Dictionary<Point, (Bool, Int)>()
    
    // Initialize dictionary
    for point in coordinates {
        dict[point] = (false, 0)
    }
    
    // Determine boundary
    let minX, maxX, minY, maxY : Int
    (minX, maxX, minY, maxY) = computeBoundary(coordinates)

    // Maximum total distance allowed for Part 2
    let MAX_TOTAL_DIST = 10000 - 1
    // Keep track of size of safe region as defined in Part 2
    var safeRegionSize = 0
    
    for x in minX ... maxX {
        for y in minY ... maxY {
            // Keep track of coordinate with minimum distance to (x, y)
            var minDist = Int.max
            var minPoint: Point? = nil
            // Sum of total distance from (x, y) to all coordinates (Part 2)
            var totalDist = 0
            
            for point in coordinates {
                let manhattanDist = manhattanDistance(x, y, point.x, point.y)
                
                if manhattanDist < minDist {
                    minDist = manhattanDist
                    minPoint = point
                } else if manhattanDist == minDist {
                    // Tie occured, so no minimum point
                    minPoint = nil
                }
                
                totalDist += manhattanDist
            }
            
            if let minPoint = minPoint {
                if isOnBoundary(x, y, minX, maxX, minY, maxY) {
                    // Since (x, y) is a boundary point which is closest to minPoint (no tie), this would
                    // result an infinite area, so we do not consider this point for the Part 1 answer
                    dict[minPoint]!.0 = true
                } else {
                    // (x, y) is not a boundary point, so increase the area of influence for minPoint
                    dict[minPoint]!.1 += 1
                }
            }
            
            if totalDist <= MAX_TOTAL_DIST {
                // Increment safe region size for Part 2
                safeRegionSize += 1
            }
        }
    }
    
    let largestFiniteAreaPoint = coordinates.max { (p1, p2) -> Bool in
        // p2 is "larger" than p1 if p2's area is finite and either p1's area is infinite or
        // p1's area is finite and p2's area is larger
        return !dict[p2]!.0 && (dict[p1]!.0 || dict[p2]!.1 > dict[p1]!.1)}!
    
    let largestFiniteArea = dict[largestFiniteAreaPoint]!.1
    
    print("Largest finite area: \(largestFiniteArea)")
    print("Safe region size: \(safeRegionSize)")
}

main()
