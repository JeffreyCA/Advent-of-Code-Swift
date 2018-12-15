//
//  Advent of Code 2018 - Day 11
//  Author: JeffreyCA
//

import Foundation

// Determine hundreds digit of a integer
func hundredsDigit(_ val: Int) -> Int {
    if abs(val) < 100 {
        return 0
    }
    
    return (val / 100) % 10
}

// Construct grid of cell power levels using a summed-area table
func constructGrid(_ serial: Int, _ dimension: Int) -> [[Int]] {
    var grid = [[Int]].init(repeating: [Int].init(repeating: 0, count: dimension + 1), count: dimension + 1)
    
    for y in 1 ... dimension {
        for x in 1 ... dimension {
            let rackId = x + 10
            let powerLevel = hundredsDigit((rackId * y + serial) * rackId) - 5
            grid[y][x] = powerLevel + grid[y - 1][x] + grid[y][x - 1] - grid[y - 1][x - 1]
        }
    }
    
    return grid
}

// Determine the top-left coordinates and power level of square with the highest power level
func maxPowerSquare(_ grid: [[Int]], _ squareSize: Int) -> (Int, (Int, Int)) {
    var maxPower = Int.min
    var maxPowerTopLeft = (0, 0)
    
    for y in squareSize ..< grid.count {
        for x in squareSize ..< grid.count {
            let total = grid[y][x] - grid[y - squareSize][x] - grid[y][x - squareSize] + grid[y-squareSize][x - squareSize]
            
            if total > maxPower {
                maxPower = total
                maxPowerTopLeft = (x - squareSize + 1, y - squareSize + 1)
            }
        }
    }
    
    return (maxPower, maxPowerTopLeft)
}

func main() {
    let serial = Int(readInput()[0])!
    let GRID_DIMENSION = 300
    let grid = constructGrid(serial, GRID_DIMENSION)
    
    // What is the X,Y coordinate of the top-left fuel cell of the 3x3 square with the largest total power?
    let max3Square = maxPowerSquare(grid, 3)
    print("Coordinate of top-left fuel cell of 3x3 square: \(max3Square.1)")
    
    // Part 2
    var maxPower = Int.min
    var maxPowerTopLeft = (0, 0)
    var maxPowerSize = 1
    
    for squareSize in 1 ... GRID_DIMENSION {
        let result = maxPowerSquare(grid, squareSize)
        
        if result.0 > maxPower {
            maxPower = result.0
            maxPowerTopLeft = result.1
            maxPowerSize = squareSize
        }
    }
    
    print("Square with the largest total power: \(maxPowerTopLeft.0, maxPowerTopLeft.1, maxPowerSize)")
}

main()
