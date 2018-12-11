//
//  Advent of Code 2018 - Day 10
//  Author: JeffreyCA
//

import Foundation

// Parse input into array of Points
func parsePoints(_ input: [String]) -> [Point] {
    return input.map { (line) -> Point in
        let values = matches(for: "-?\\d+", in: line)
        let x = Int(values[0])!
        let y = Int(values[1])!
        let xVel = Int(values[2])!
        let yVel = Int(values[3])!
        
        return Point(x: x, y: y, xVelocity: xVel, yVelocity: yVel)
    }
}

func main() {
    let input = readInput()
    var points = parsePoints(input)
    // Keep track of boundary formed by points at any moment
    var xLeft: Int = 0, xRight: Int = 0
    var yBottom: Int = 0, yTop: Int = 0
    // The height of the boundary when word is readable is 10
    var height = Int.max
    var time = 0
    
    while height > 10 {
        for index in points.enumerated() {
            points[index.offset].advance()
        }
        
        // Recalculate boundary
        xLeft = points.min { $0.x < $1.x }!.x
        xRight = points.max { $0.x < $1.x }!.x
        yTop = points.min { $0.y < $1.y }!.y
        yBottom = points.max { $0.y < $1.y }!.y
        
        height = yBottom - yTop
        time += 1
    }
    
    // Output plot within boundary
    for y in yTop ... yBottom {
        for x in xLeft ... xRight {
            print(points.contains { $0.x == x && $0.y == y } ? "*" : " ", terminator: "")
        }
        print()
    }
    
    print("Time: \(time)")
}

main()
