//
//  Advent of Code 2018 - Day 3
//  Author: JeffreyCA
//

import Foundation

func parseRects(_ lines: [String]) -> [CGRect] {
    let regex = try! NSRegularExpression(pattern: "#([0-9]+) @ ([0-9]+),([0-9]+): ([0-9]+)x([0-9]+)", options: .caseInsensitive)
    
    var rects = [CGRect]()
    
    for line in lines {
        var matches = [Int]()
        
        let match = regex.matches(in: line, range: NSMakeRange(0, line.count)).first!
        let lastRangeIndex = match.numberOfRanges - 1
        
        for i in 1 ... lastRangeIndex {
            let range = match.range(at: i)
            let matchedString = line[range.lowerBound ... range.upperBound - 1]
            matches.append(Int(matchedString)!)
        }
        
        let rect = CGRect(x: matches[1], y: matches[2], width: matches[3], height: matches[4])
        
        rects.append(rect)
    }
    
    return rects
}

func main() {
    let lines = readInput()
    let rects = parseRects(lines)

    var areaGrid = [[Int]](repeatElement([Int](repeatElement(0, count: 1000)), count: 1000))
    var overlapGrid = [[Int]](repeatElement([Int](repeatElement(0, count: 1000)), count: 1000))
    var overlapClaims = [Int](repeatElement(0, count: rects.count + 1))
    var claim = 1
    
    for rect in rects {
        let minX = Int(rect.minX)
        let maxX = Int(rect.minX + rect.width) - 1
        let minY = Int(rect.minY)
        let maxY = Int(rect.minY + rect.height) - 1
        
        for i in minX ... maxX {
            for j in minY ... maxY {
                if overlapGrid[i][j] > 0 {
                    overlapClaims[overlapGrid[i][j]] += 1
                    overlapClaims[claim] += 1
                }
                
                overlapGrid[i][j] = claim
                areaGrid[i][j] += 1
            }
        }
        claim += 1
    }
    
    var sum = 0
    for row in areaGrid {
        let overlappingPoints = row.filter({$0 > 1}).count
        sum += overlappingPoints
    }
    
    let nonOverlapClaim = overlapClaims.indices.filter({ $0 > 0 && overlapClaims[$0] == 0 })[0]
    
    print("Overlapping area: \(sum)")
    print("Non-overlapping claim: \(nonOverlapClaim)")
}

main()
