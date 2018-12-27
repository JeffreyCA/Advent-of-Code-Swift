//
//  Advent of Code 2018 - Day 17
//  Author: JeffreyCA
//  References: https://github.com/jmmal/advent-of-code-2018/blob/master/Day%2017/day17.swift
//

import Foundation

struct Reservoir {
    enum State {
        case clay
        case flowing
        case resting
    }
    
    enum Direction {
        case down
        case left
        case right
    }
    
    var grid: [Point: State]
    var minX: Int
    var minY: Int
    var maxX: Int
    var maxY: Int
    
    init(_ input: [String]) {
        grid = [Point: State]()
        minX = Int.max
        minY = Int.max
        maxX = 0
        maxY = 0
        self.constructGrid(input)
    }
    
    // Construct grid from input
    mutating func constructGrid(_ input: [String]) {
        for line in input {
            let numbers = matches(for: "\\d+", in: line).map({ Int($0)! })
            let constant = numbers[0]
            let range = numbers[1] ... numbers[2]
            
            if line[0] == "x" {
                for y in range {
                    let point = Point(constant, y)
                    grid[point] = .clay
                    
                    minX = min(minX, constant)
                    minY = min(minY, y)
                    maxX = max(maxX, constant)
                    maxY = max(maxY, y)
                }
            } else {
                for x in range {
                    let point = Point(x, constant)
                    grid[point] = .clay
                    
                    minX = min(minX, x)
                    minY = min(minY, constant)
                    maxX = max(maxX, x)
                    maxY = max(maxY, constant)
                }
            }
        }        
    }

    // Recursively fills grid with water starting from given point in given direction
    // 
    // From: https://github.com/jmmal/advent-of-code-2018/blob/master/Day%2017/day17.swift
    mutating func fill(_ point: Point, _ direction: Direction = .down) -> Bool {
        grid[point] = .flowing
        let pointBelow = Point(point.x, point.y + 1)
        
        if grid[pointBelow] != .clay && grid[pointBelow] != .resting {
            if grid[pointBelow] != .flowing && pointBelow.y <= maxY {
                _ = fill(pointBelow)
            }
            
            if grid[pointBelow] != .resting {
                return false
            }
        }
        
        var pointLeft = Point(point.x - 1, point.y)
        var pointRight = Point(point.x + 1, point.y)
        
        let filledLeft = grid[pointLeft] == .clay || (grid[pointLeft] != .flowing && fill(pointLeft, .left))
        let filledRight = grid[pointRight] == .clay || (grid[pointRight] != .flowing && fill(pointRight, .right))
        
        if direction == .down && filledLeft && filledRight {
            grid[point] = .resting
            
            // Calm waters to the left
            while grid[pointLeft] == .flowing {
                grid[pointLeft] = .resting
                pointLeft = Point(pointLeft.x - 1, pointLeft.y)
            }
            
            // Calm waters to the right
            while grid[pointRight] == .flowing {
                grid[pointRight] = .resting
                pointRight = Point(pointRight.x + 1, pointRight.y)
            }
        }
        
        return (direction == .left && (filledLeft || grid[pointLeft] == .clay)) ||
            (direction == .right && (filledRight || grid[pointRight] == .clay))
    }
    
    mutating func fillFromSpring() {
        let spring = Point(500, 0)
        _ = fill(spring)        
    }
    
    // Part 1
    func wateredTiles() -> Int {
        return grid.filter{ $0.key.y >= minY && $0.key.y <= maxY && 
            ($0.value == .resting || $0.value == .flowing) }.count
    }
    
    // Part 2
    func wateredTilesAtRest() -> Int {
        return grid.filter{ $0.key.y >= minY && $0.key.y <= maxY && $0.value == .resting }.count
    }
}


func main() {
    let input = readInput()
    var reservoir = Reservoir(input)
    reservoir.fillFromSpring()
    
    print("Water reaches \(reservoir.wateredTiles()) tiles within range of y values")
    print("\(reservoir.wateredTilesAtRest()) tiles are left after water spring stops")
}

main()
