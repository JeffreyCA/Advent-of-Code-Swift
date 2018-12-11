//
//  Advent of Code 2018 - Day 11
//  Author: JeffreyCA
//

import Foundation

func hundredsDigit(_ val: Int) -> Int {
    if abs(val) < 100 {
        return 0
    }
    
    return (val / 100) % 10
}

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

func maxPowerSquare(_ grid: [[Int]], _ squareSize: Int) -> (Int, (Int, Int)) {
    let lastSquareTopLeft = grid.count - squareSize
    
    var topLeft = (1, 1)
    var maxPower = Int.min
    var maxPowerCell = (0, 0)
    
    while true {
        // print(topLeft)
        let topLeftX = topLeft.0 - 1, topLeftY = topLeft.1 - 1
        var totalPower = 0
        
        for y in topLeftY ..< topLeftY + squareSize {
            for x in topLeftX ..< topLeftX + squareSize {
                totalPower += grid[y][x]
            }
        }
        
        if totalPower > maxPower {
            maxPower = totalPower
            maxPowerCell = topLeft
        }
        
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
    
    var maxPower = Int.min
    var maxPowerCell = (0, 0)
    
    for squareSize in 1 ... 300 {
        let result = maxPowerSquare(grid, squareSize)
        if result.0 > maxPower {
            maxPower = result.0
            maxPowerCell = result.1
        }
    }
    
    print(maxPowerCell)
    
}

main()
