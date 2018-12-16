//
//  Advent of Code 2018 - Day 13
//  Author: JeffreyCA
//

import Foundation

struct Cart {
    enum Direction {
        case up
        case right
        case down
        case left
    }
    
    enum Turn {
        case left
        case straight
        case right
    }
    
    var x: Int
    var y: Int
    
    var symbol: Character
    var nextTurn: Turn = .left
    var crashed: Bool = false
    
    init(_ x: Int, _ y: Int, _ symbol: Character) {
        self.x = x
        self.y = y
        self.symbol = symbol
    }
    
    // Set next turn direction accordingly
    mutating func doTurn() {
        switch self.nextTurn {
        case .left:
            self.nextTurn = .straight
        case .straight:
            self.nextTurn = .right
        default:
            self.nextTurn = .left
        }
    }
    
    // Return direction to the left
    func left() -> Character {
        switch self.symbol {
        case "^":
            return "<"
        case ">":
            return "^"
        case "v":
            return ">"
        default:
            return "v"
        }
    }
    
    // Return the direction to the right
    func right() -> Character {
        switch self.symbol {
        case "^":
            return ">"
        case ">":
            return "v"
        case "v":
            return "<"
        default:
            return "^"
        }
    }

    // Advance cart one step, returns point of crash if encountered, otherwise nil
    mutating func move(map: [String], set: inout Set<Point>) -> Point? {
        var current = Point(x: self.x, y: self.y)
        // Remove old position from set
        set.remove(current)
        
        // Change x/y position according to direction of travel
        if self.symbol == "^" {
            current.y -= 1
        } else if self.symbol == "v" {
            current.y += 1
        } else if self.symbol == "<" {
            current.x -= 1
        } else if self.symbol == ">" {
            current.x += 1
        }
        
        // Adjust direction based on tracks
        if map[current.y][current.x] == "/" {
            if self.symbol == "^" || self.symbol == "v" {
                self.symbol = right()
            } else {
                self.symbol = left()
            }
        } else if map[current.y][current.x] == "\\" {
            if self.symbol == "^" || self.symbol == "v" {
                self.symbol = left()
            } else {
                self.symbol = right()
            }
        } else if map[current.y][current.x] == "+" {
            if self.nextTurn == .left {
                self.symbol = left()
            } else if self.nextTurn == .right {
                self.symbol = right()
            }
            
            self.doTurn()
        }
        
        self.x = current.x
        self.y = current.y
        
        if set.contains(current) {
            // Crash occured!
            return current
        }
        
        // No crash
        set.insert(current)
        return nil
    }
    
    func position() -> String {
        return "\(self.x, self.y)"
    }
}

func main() {
    let DIMENSION = 150
    var map = readInput()
    // List of non-crashed carts, ordered from top to bottom and left to right
    var carts = [Cart]()
    // Set of positions of non-crashed carts
    var pointSet = Set<Point>()
    
    for y in 0 ..< map.count {
        let row = map[y]
        
        for x in 0 ..< row.count {
            if row[x] == "^" || row[x] == "v" || row[x] == "<" || row[x] == ">" {
                carts.append(Cart(x, y, row[x]))
                pointSet.insert(Point(x: x, y: y))
            }
        }
        
        map[y] = map[y].replacingOccurrences(of: "^", with: "|")
            .replacingOccurrences(of: "v", with: "|")
            .replacingOccurrences(of: "<", with: "-")
            .replacingOccurrences(of: ">", with: "-")
    }
    
    var firstCrash = false
    
    // Advance carts until only one left
    while carts.count > 1 {
        // Maintain list of all crash points in current iteration (may be more than one)
        var crashes = [Point]()
        
        for index in 0 ..< carts.count {
            if carts[index].crashed {
                continue
            }
            
            // Advance each car that is not crashed
            let result = carts[index].move(map: map, set: &pointSet)
            
            if let crashPoint = result {
                // Output first crash location
                if !firstCrash {
                    print("First crash location: \(crashPoint)")
                    firstCrash = true
                }
                
                // Change crashed flag for all carts at current crash point
                carts = carts.map({ (cart) -> Cart in
                    var mutable = cart
                    if cart.x == crashPoint.x && cart.y == crashPoint.y {
                        mutable.crashed = true
                    }
                    return mutable
                })
                
                crashes.append(crashPoint)
                // Remove point from set so that other cars may pass through
                pointSet.remove(crashPoint)
            }
        }

        // Remove crashed carts and re-order carts from top to bottom, left to right
        carts = carts.filter({ !$0.crashed }).sorted { ($1.y * DIMENSION) + $1.x > ($0.y * DIMENSION) + $0.x }
    }
    
    print("Last remaining cart: \(carts[0].position())")
}

main()
