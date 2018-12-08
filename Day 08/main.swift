//
//  Advent of Code 2018 - Day 8
//  Author: JeffreyCA
//

import Foundation

struct SimpleStream {
    var arr: [String]
    var index: Int = 0
    
    mutating func next() -> String? {
        if index >= arr.count {
            return nil
        }
        
        let val = arr[index]
        self.index += 1
        return val
    }
    
    mutating func reset() {
        self.index = 0
    }
}

struct Node {
    var childCount: Int = 0
    var metaCount: Int = 0
    
    var children: [Node?] = [Node?]()
    var metadata: [Int] = [Int]()
    
    init(childCount: Int, metaCount: Int) {
        self.childCount = childCount
        self.metaCount = metaCount
    }
}

func buildTree(stream: inout SimpleStream) -> Node? {
    let childNodes = stream.next()
    let metaNodes = stream.next()
    
    if childNodes == nil || metaNodes == nil {
        return nil
    }
    
    let childCount = Int(childNodes!)!
    let metaCount = Int(metaNodes!)!
    
    var node = Node(childCount: childCount, metaCount: metaCount)
    
    for _ in 0 ..< childCount {
        node.children.append(buildTree(stream: &stream))
    }
    
    for _ in 1 ... metaCount {
        let nextValue = Int(stream.next()!)!
        node.metadata.append(nextValue)
    }
    
    return node
}

func sumMetadata(of node: Node?) -> Int {
    guard let node = node else {
        return 0
    }
    
    var sum = 0
    
    for value in node.metadata {
        sum += value
    }
    
    for child in node.children {
        sum += sumMetadata(of: child)
    }
    
    return sum
}

func value(of node: Node?) -> Int {
    guard let node = node else {
        return 0
    }
    
    if node.childCount == 0 {
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
    var stream = SimpleStream(arr: readInput()[0].components(separatedBy: " "), index: 0)
    let root = buildTree(stream: &stream)
    
    print("Sum of metadata entries: \(sumMetadata(of: root))")
    print("Value of root: \(value(of: root))")
}

main()
