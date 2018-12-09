//
//  Advent of Code 2018
//  Author: JeffreyCA
//

import Foundation

extension String: Error {}

// https://stackoverflow.com/a/38215613/2789451
extension StringProtocol {
    
    var string: String { return String(self) }
    
    subscript(offset: Int) -> Element {
        return self[index(startIndex, offsetBy: offset)]
    }
    
    subscript(_ range: CountableRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    subscript(range: CountableClosedRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    
    subscript(range: PartialRangeThrough<Int>) -> SubSequence {
        return prefix(range.upperBound.advanced(by: 1))
    }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence {
        return prefix(range.upperBound)
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence {
        return suffix(Swift.max(0, count - range.lowerBound))
    }
}

extension Substring {
    var string: String { return String(self) }
}

extension Collection where Self: BidirectionalCollection  {
    public subscript(safe index: Int) -> Element? {
        guard let index = self.index(startIndex, offsetBy: index, limitedBy: self.index(before: endIndex)) else { return nil }
        return  self[index]
    }
}

extension Deque {
    // Aliases for enqueue and dequeue
    public mutating func enqueueBack(_ element: T) {
        self.enqueue(element)
    }
    
    public mutating func dequeueFront() -> T? {
        return self.dequeue()
    }
    
    // Rotate queue based on offset
    public mutating func rotate(_ offset: Int) {
        if self.count <= 1 || offset == 0 {
            return
        }
        
        if offset > 0 {
            for _ in 1 ... offset {
                self.enqueueFront(self.dequeueBack()!)
            }
        } else {
            for _ in offset ... -1 {
                self.enqueueBack(self.dequeueFront()!)
            }
        }
    }
}
