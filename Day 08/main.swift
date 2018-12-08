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
}


func sumMetadata(stream: inout SimpleStream) -> Int {
    let childNodes = stream.next()
    let metaNodes = stream.next()
    var sum = 0
    
    if childNodes == nil || metaNodes == nil {
        return 0
    }
    
    for _ in 0 ..< Int(childNodes!)! {
        sum += sumMetadata(stream: &stream)
    }
    
    for _ in 1 ... Int(metaNodes!)! {
        let nextValue = stream.next()!
        sum += Int(nextValue)!
    }
    
    return sum
}

func main() {
    var lines = SimpleStream(arr: readInput()[0].components(separatedBy: " "), index: 0)
    print("Sum of metadata entries: \(sumMetadata(stream: &lines))")
}

main()
