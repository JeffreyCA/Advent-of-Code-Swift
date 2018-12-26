//
//  Advent of Code 2018
//  Author: JeffreyCA
//

import Foundation

let ALPHABET_LOWER = "abcdefghijklmnopqrstuvwxyz"

// Union-Find data structure
// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Union-Find/UnionFind.playground/Sources
public struct UnionFind<T: Hashable> {
    private var index = [T: Int]()
    private var parent = [Int]()
    private var size = [Int]()
    private var setSize = 0
    
    public mutating func addSetWith(_ element: T) {
        index[element] = parent.count
        parent.append(parent.count)
        size.append(1)
        setSize += 1
    }
    
    private mutating func setByIndex(_ index: Int) -> Int {
        if parent[index] == index {
            return index
        } else {
            parent[index] = setByIndex(parent[index])
            return parent[index]
        }
    }
    
    public mutating func setOf(_ element: T) -> Int? {
        if let indexOfElement = index[element] {
            return setByIndex(indexOfElement)
        } else {
            return nil
        }
    }
    
    public mutating func unionSetsContaining(_ firstElement: T, and secondElement: T) {
        if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
            if firstSet != secondSet {
                parent[firstSet] = secondSet
                size[secondSet] += size[firstSet]
                setSize -= 1
            }
        }
    }
    
    public mutating func inSameSet(_ firstElement: T, and secondElement: T) -> Bool {
        if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
            return firstSet == secondSet
        } else {
            return false
        }
    }
    
    public func count() -> Int {
        return setSize
    }
}

struct Point3: Hashable {
    var x: Int
    var y: Int
    var z: Int
    
    init(x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func manhattanDistance(_ p: Point3) -> Int {
        let diffX = abs(p.x - self.x)
        let diffY = abs(p.y - self.y)
        let diffZ = abs(p.z - self.z)
        
        return diffX + diffY + diffZ
    }
}

struct Point4: Hashable {
    var w: Int
    var x: Int
    var y: Int
    var z: Int
    
    init(_ w: Int, _ x: Int, _ y: Int, _ z: Int) {
        self.w = w
        self.x = x
        self.y = y
        self.z = z
    }
    
    func manhattanDistance(_ p: Point4) -> Int {
        let diffW = abs(p.w - self.w)
        let diffX = abs(p.x - self.x)
        let diffY = abs(p.y - self.y)
        let diffZ = abs(p.z - self.z)
        
        return diffW + diffX + diffY + diffZ
    }
}

struct Point : Hashable, CustomStringConvertible {
    var x: Int
    var y: Int
    let xVelocity: Int
    let yVelocity: Int

    init(_ x: Int, _ y: Int, xVelocity: Int = 0, yVelocity: Int = 0) {
        self.x = x
        self.y = y
        self.xVelocity = xVelocity
        self.yVelocity = yVelocity
    }
    
    var description: String {
        return "\(x, y)"
    }
}

// Return character of opposite case, assuming given character is in A-Z/a-z
func oppositeCase(_ char: Character) -> Character {
    let LOWER_A = 97, OFFSET = 32
    let val = Int(char.unicodeScalars.first!.value)
    return Character(Unicode.Scalar(val >= LOWER_A ? val - OFFSET: val + OFFSET)!)
}

// Read lines from input.txt into array of strings
func readInput() -> [String] {
    do {
        let contents = try String(contentsOfFile: "input.txt", encoding: String.Encoding.utf8)
        let lines: [String] = contents.components(separatedBy: "\n").filter{$0 != ""}
        return lines
    } catch let error as NSError {
        print(error.localizedDescription)
        return [String]()
    }
}

// Match regex in string
func matches(for regex: String, in text: String) -> [String] {
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("Invalid regex: \(error.localizedDescription)")
        return []
    }
}

// Simple stream data structure that keeps track of the current index of the array
struct SimpleStream {
    var arr: [String]
    var index: Int = 0
    
    init(_ arr: [String]) {
        self.arr = arr
    }
    
    mutating func next() -> String {
        if index >= arr.count {
            return ""
        }
        
        let val = arr[index]
        self.index += 1
        return val
    }
}
