//
//  Advent of Code 2018
//  Author: andrewwoz
//
//  https://github.com/andrewwoz/LineReader
//

import Foundation

public class LineReader {
    public let path: String
    
    fileprivate let file: UnsafeMutablePointer<FILE>!
    
    init?(path: String) {
        self.path = path
        file = fopen(path, "r")
        guard file != nil else { return nil }
    }
    
    public var nextLine: String? {
        var line:UnsafeMutablePointer<CChar>? = nil
        var linecap:Int = 0
        defer { free(line) }
        return getline(&line, &linecap, file) > 0 ? String(cString: line!) : nil
    }
    
    deinit {
        fclose(file)
    }
}

extension LineReader: Sequence {
    public func  makeIterator() -> AnyIterator<String> {
        return AnyIterator<String> {
            return self.nextLine
        }
    }
}