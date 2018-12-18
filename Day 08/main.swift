//
//  Advent of Code 2018 - Day 8
//  Author: JeffreyCA
//

import Foundation

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
    let childCount = Int(stream.next())!
    let metadataCount = Int(stream.next())!
    
    var node = Node()
    
    for _ in 0 ..< childCount {
        node.addChild(child: buildTree(stream: &stream))
    }
    
    for _ in 1 ... metadataCount {
        node.addMetadata(data: Int(stream.next())!)
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
