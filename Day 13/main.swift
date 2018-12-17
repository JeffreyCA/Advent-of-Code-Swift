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
    var direction: Direction
    var nextTurn: Turn = .left
    var crashed: Bool = false
    
    init(_ x: Int, _ y: Int, _ symbol: Character) {
        self.x = x
        self.y = y
        
        self.direction = {
            switch symbol {
            case "^":
                return .up
            case ">":
                return .right
            case "v":
                return .down
            default:
                return .left
            }
        }()
    }
    
    // Set next turn direction accordingly
    mutating func doTurn() {
        self.nextTurn = {
            switch self.nextTurn {
            case .left:
                return .straight
            case .straight:
                return .right
            default:
                return .left
            }
        }()
    }
    
    // Return direction to the left
    func left() -> Direction {
        switch self.direction {
        case .up:
            return .left
        case .right:
            return .up
        case .down:
            return .right
        default:
            return .down
        }
    }
    
    // Return the direction to the right
    func right() -> Direction {
        switch self.direction {
        case .up:
            return .right
        case .right:
            return .down
        case .down:
            return .left
        default:
            return .up
        }
    }

    // Change x/y position according to direction of travel
    private mutating func updatePosition() {
        switch self.direction {
        case .up:
            self.y -= 1
        case .right:
            self.x += 1   
        case .down:
            self.y += 1
        default:
            self.x -= 1
        }
    }
    
    // Update cart's direction according to current track piece
    private mutating func updateNextDirection(_ track: Character) {
        // Adjust direction based on tracks
        if track == "/" {
            if self.direction == .up || self.direction == .down {
                self.direction = right()
            } else {
                self.direction = left()
            }
        } else if track == "\\" {
            if self.direction == .up || self.direction == .down {
                self.direction = left()
            } else {
                self.direction = right()
            }
        } else if track == "+" {
            if self.nextTurn == .left {
                self.direction = left()
            } else if self.nextTurn == .right {
                self.direction = right()
            }
            
            self.doTurn()
        }
    }
    
    // Advance cart one step, returns point of crash if encountered, otherwise nil
    mutating func move(map: [String], set: inout Set<Point>) -> Point? {
        // Remove old position from set
        set.remove(Point(x: self.x, y: self.y))
        
        // Update cart position to next position
        self.updatePosition()
        // Update direction based on current track
        self.updateNextDirection(map[self.y][self.x])
        
        let current = Point(x: self.x, y: self.y)
        if set.contains(current) {
            // Crash occured!
            return current
        }
        
        // No crash!
        set.insert(current)
        return nil
    }
    
    // String representation of current position
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
