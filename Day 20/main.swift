//
//  Advent of Code 2018 - Day 20
//  Author: JeffreyCA
//

import Foundation

func go(from point: Point, towards dir: Character) -> Point {
    var newPoint = point
    switch dir {
    case "N":
        newPoint.y += 1
    case "E":
        newPoint.x += 1
    case "S":
        newPoint.y -= 1
    case "W":
        newPoint.x -= 1
    default:
        print("Error: \(dir)")
    }
    return newPoint
}

func main() {
    let regex = readInput()[0]
    
    var dict = [Point: Int]()
    var stack = [Point]()
    var point = Point(0, 0)
    dict[point] = 0
    
    for char in regex {
        switch char {
        case "^", "$":
            continue
        case "(":
            stack.append(point)
        case ")":
            point = stack.removeLast()
        case "|":
            point = stack.last!
        default:
            let nextPoint = go(from: point, towards: char)
            dict[nextPoint] = min(dict[point]! + 1, dict[nextPoint] ?? Int.max)
            point = nextPoint
        }
    }
    
    print("Largest number of doors to pass through: \(dict.values.max()!)")
    print("Shortest paths passing through at least 1000 doors: \(dict.values.filter({ $0 >= 1000 }).count)")
}

main()
