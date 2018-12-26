//
//  Advent of Code 2018 - Day 23
//  Author: JeffreyCA
//

import Foundation

struct Nanobot: Equatable {
    var point: Point3
    var radius: Int
}

func main() {
    let input = readInput()
    
    var bots = [Nanobot]()
    
    for line in input {
        let m = matches(for: "-*\\d+", in: line)
        let x = Int(m[0])!, y = Int(m[1])!, z = Int(m[2])!, radius = Int(m[3])!
        let nanobot = Nanobot(point: Point3(x: x, y, z), radius: radius)
        bots.append(nanobot)
    }
    
    let strongestBot = bots.max(by: { $0.radius < $1.radius })!
    let inRange = bots.filter({ $0 != strongestBot && strongestBot.point.manhattanDistance($0.point) <= strongestBot.radius }).count
    
    print("Nanobots in range of strongest bot: \(inRange)")
}

main()
