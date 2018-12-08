//
//  Advent of Code 2018 - Day 8
//  Author: JeffreyCA
//

import Foundation

// Simple stream data structure that keeps track of the current index of the array
struct SimpleStream {
    var arr: [Int]
    var index: Int = 0
    
    init(_ arr: [String]) {
        // Convert all elements to Int for convenience
        self.arr = arr.map({ Int($0)! })
    }
    
    mutating func next() -> Int {
        if index >= arr.count {
            return -1
        }
        
        let val = arr[index]
        self.index += 1
        return val
    }
}

// Representation of a node in the tree
struct Node {
    var childCount: Int = 0
    var metadataCount: Int = 0
    var children: [Node] = [Node]()
    var metadata: [Int] = [Int]()
    
    mutating func addChild(child: Node) {
        self.children.append(child)
        self.childCount += 1
    }
    
    mutating func addMetadata(data: Int) {
        self.metadata.append(data)
        self.metadataCount += 1
    }
}

// Construct tree data structure from input stream
func buildTree(stream: inout SimpleStream) -> Node {
    let childCount = stream.next()
    let metadataCount = stream.next()
    
    var node = Node()
    
    for _ in 0 ..< childCount {
        node.addChild(child: buildTree(stream: &stream))
    }
    
    for _ in 1 ... metadataCount {
        node.addMetadata(data: stream.next())
    }
    
    return node
}

// Determine sum of node's metadata values and its children
func sumMetadata(of node: Node) -> Int {
    var sum = 0
    
    for value in node.metadata {
        sum += value
    }
    
    for child in node.children {
        sum += sumMetadata(of: child)
    }
    
    return sum
}

// Determine value of node as per requirements
func value(of node: Node) -> Int {
    if node.childCount == 0 {
        // Sum of metadata entries
        return node.metadata.reduce(0, +)
    }
    
    var sum = 0
    
    for index in node.metadata {
        if index >= 1 && index <= node.childCount {
            sum += value(of: node.children[index - 1])
        }
    }
    
    return sum
}

func main() {
    var stream = SimpleStream(readInput()[0].components(separatedBy: " "))
    let root = buildTree(stream: &stream)
    
    print("Sum of metadata entries: \(sumMetadata(of: root))")
    print("Value of root: \(value(of: root))")
}

main()
