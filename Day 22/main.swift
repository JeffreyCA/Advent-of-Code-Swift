//
//  Advent of Code 2018 - Day 22
//  Author: JeffreyCA
//

import Foundation

// Structure representing a cave
struct Cave {
    enum RegionType: Int {
        case rocky = 0
        case wet = 1
        case narrow = 2
    }
    
    enum Weapon: CaseIterable, Equatable {
        case torch
        case climbing
        case neither
    }
    
    struct NodeTuple: Hashable {
        var point: Point
        var weapon: Weapon
        
        init(_ point: Point, _ weapon: Weapon) {
            self.point = point
            self.weapon = weapon
        }
    }
    
    let PADDING_MULTIPLE = 4
    let SWITCH_COST = 7
    let MOVE_COST = 1
    
    
    let depth: Int
    let target: Point
    
    var cave: [[RegionType]]
    var erosionLevels: [[Int]]
    
    init(_ depth: Int, _ target: Point) {
        // Need to build cave with width and height outside of target in case path passes through outside of
        // coordinates of the target
        self.depth = depth
        self.target = target
        self.cave = [[RegionType]].init(repeating: [RegionType]
            .init(repeating: .rocky, count: target.x * PADDING_MULTIPLE), count: target.y * PADDING_MULTIPLE)
        self.erosionLevels = [[Int]].init(repeating: [Int]
            .init(repeating: 0, count: target.x * PADDING_MULTIPLE), count: target.y * PADDING_MULTIPLE)
        
        for y in 0 ..< cave.count {
            for x in 0 ..< cave[y].count {
                var geoIndex = 0
                
                if x == 0 && y == 0 {
                    geoIndex = 0
                } else if x == target.x && y == target.y {
                    geoIndex = 0
                } else if y == 0 {
                    geoIndex = x * 16807
                } else if x == 0 {
                    geoIndex = y * 48271
                } else {
                    geoIndex = self.erosionLevels[y][x - 1] * self.erosionLevels[y - 1][x]
                }
                
                let erosionLevel = (geoIndex + depth) % 20183
                self.erosionLevels[y][x] = erosionLevel
                
                if erosionLevel % 3 == 0 {
                    self.cave[y][x] = .rocky
                } else if erosionLevel % 3 == 1 {
                    self.cave[y][x] = .wet
                } else {
                    self.cave[y][x] = .narrow
                }
            }
        }
    }
    
    func conflicts(_ region: RegionType, _ weapon: Weapon) -> Bool {
        switch region {
        case .rocky:
            return weapon == .neither
        case .wet:
            return weapon == .torch
        default:
            return weapon == .climbing
        }
    }
    
    func riskLevel() -> Int {
        return self.cave.prefix(through: self.target.y)
            .map({ $0.prefix(through: self.target.x).map({ $0.rawValue }).reduce(0, +) }).reduce(0, +)
    }
    
    // Modified Dijkstra's algorithm to calculate shortest amount of time needed to reach the target
    func shortestPathToTarget(with targetWeapon: Weapon) -> Int {
        let startPoint = Point(0, 0)
        var dist = [NodeTuple: Int]()
        var queue = PriorityQueue<(Int, Point, Weapon)>(sort: { $0.0 < $1.0 })
        queue.enqueue((0, startPoint, .torch))
        
        while !queue.isEmpty {
            let item = queue.dequeue()!
            let currentMinute = item.0, currentPoint = item.1, currentWeapon = item.2
            
            if let distance = dist[NodeTuple(currentPoint, currentWeapon)], distance <= currentMinute {
                continue
            }
            
            dist[NodeTuple(currentPoint, currentWeapon)] = currentMinute
            
            // Reached target
            if currentPoint == target && currentWeapon == targetWeapon {
                break
            }
            
            // Consider neighbouring vertices at same position but different weapon
            for weapon in Set(Weapon.allCases).subtracting([item.2]) {
                let regionType = cave[currentPoint.y][currentPoint.x]
                
                if !conflicts(regionType, weapon) {
                    queue.enqueue((currentMinute + SWITCH_COST, currentPoint, weapon))
                }
            }
            
            // Consider neighbourign vertices with same weapon but at adjacent position
            for neighbour in item.1.neighbours4() {
                if neighbour.x < 0 || neighbour.x >= PADDING_MULTIPLE * target.x {
                    continue
                }
                
                if neighbour.y < 0 || neighbour.y >= PADDING_MULTIPLE * target.y {
                    continue
                }
                
                if !conflicts(cave[neighbour.y][neighbour.x], currentWeapon) {
                    queue.enqueue((currentMinute + MOVE_COST, neighbour, currentWeapon))
                }
            }
        }
        
        return dist[NodeTuple(target, targetWeapon)]!
    }
}

func parseInput(_ input: [String]) -> (Int, Point) {
    let depth = Int(matches(for: "\\d+", in: input[0])[0])!
    let coordinates = matches(for: "\\d+", in: input[1])
    let point = Point(Int(coordinates[0])!, Int(coordinates[1])!)
    return (depth, point)
}

func main() {
    let input = readInput()
    var depth: Int, target: Point
    (depth, target) = parseInput(input)

    let cave = Cave(depth, target)
    
    print("Risk level to target: \(cave.riskLevel())")
    print("Shortest path to target: \(cave.shortestPathToTarget(with: Cave.Weapon.torch))")
}

main()
