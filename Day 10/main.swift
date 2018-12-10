//
//  Advent of Code 2018 - Day 10
//  Author: JeffreyCA
//

import Foundation

func main() {
    let input = readInput()
    let expressions = input.map { (line) -> String in
        let values = matches(for: "-?\\d+", in: line)
        let x = values[0]
        let y = values[1]
        // Prepend '+' if positive value
        let t_x = values[2][0] == "-" ? values[2] : "+\(values[2])"
        let t_y = values[3][0] == "-" ? values[3] : "+\(values[3])"
        return "(\(x) \(t_x)t, \(y) \(t_y)t)"
    }
    
    expressions.forEach({ print($0) })
}

main()
