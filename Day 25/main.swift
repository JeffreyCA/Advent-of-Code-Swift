//
//  Advent of Code 2018 - Day 25
//  Author: JeffreyCA
//

import Foundation

func main() {
    let input = readInput()
    var points = Set<Point4>()
    var unionFind = UnionFind<Point4>()
    
    for line in input {
        let m = matches(for: "-*\\d+", in: line).map({ Int($0)! })
        let point = Point4(m[0], m[1], m[2], m[3])
        points.insert(point)
        // Add disjoint set for every point
        unionFind.addSetWith(point)
    }
    
    for vertex in points {
        for vertex2 in points {
            // Combine points into same set if manhattan distance is less than or equal to 3
            if vertex != vertex2 && vertex.manhattanDistance(vertex2) <= 3 {
                unionFind.unionSetsContaining(vertex, and: vertex2)
            }
        }
    }
    
    print("Constellations: \(unionFind.count())")
}

main()
