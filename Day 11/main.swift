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

// Construct grid of cell power levels
func constructGrid(_ serial: Int, _ dimension: Int) -> [[Int]] {
    var grid = [[Int]].init(repeating: [Int].init(repeating: 0, count: dimension), count: dimension)
    
    grid = grid.enumerated().map {
        let y = $0.offset + 1
        return $0.element.enumerated().map({
            let x = $0.offset + 1
            let rackId = x + 10
            let powerLevel = hundredsDigit((rackId * y + serial) * rackId) - 5
            return powerLevel
        })
    }
    
    return grid
}

// Determine the top-left coordinates and power level of square with the highest power level
// Runs pretty slow...
func maxPowerSquare(_ grid: [[Int]], _ squareSize: Int) -> (Int, (Int, Int)) {
    let lastSquareTopLeft = grid.count - squareSize
    
    var topLeft = (1, 1)
    var maxPower = Int.min
    var maxPowerCell = (0, 0)
    
    // Keep semi-running sum of total power
    var totalPower = 0
    
    while true {
        let topLeftX = topLeft.0 - 1, topLeftY = topLeft.1 - 1
        
        if topLeftX == 0 {
            // Calculate sum of entire square if starting at first X position
            totalPower = 0
            
            for y in topLeftY ..< topLeftY + squareSize {
                for x in topLeftX ..< topLeftX + squareSize {
                    totalPower += grid[y][x]
                }
            }
        } else {
            // Otherwise just add values in new X column and subtract values from previous X column
            for y in topLeftY ..< topLeftY + squareSize {
                totalPower = totalPower - grid[y][topLeftX - 1] + grid[y][topLeftX + squareSize - 1]
            }
        }
        
        if totalPower > maxPower {
            maxPower = totalPower
            maxPowerCell = topLeft
        }
        
        // Determine next square to search
        if topLeft.0 >= lastSquareTopLeft && topLeft.1 >= lastSquareTopLeft {
            break
        } else if topLeft.0 == lastSquareTopLeft {
            topLeft.0 = 1
            topLeft.1 += 1
        } else {
            topLeft.0 += 1
        }
    }
    
    return (maxPower, maxPowerCell)
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
    
    // What is the X,Y,size identifier of the square with the largest total power?
    print("Size \(maxPowerSize): \(maxPowerTopLeft)")
}

main()
