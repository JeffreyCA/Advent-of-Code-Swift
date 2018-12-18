//
//  Advent of Code 2018 - Day 16
//  Author: JeffreyCA
//

import Foundation

func regSet(_ r: (Int, Int, Int, Int), _ num: Int, _ val: Int) -> (Int, Int, Int, Int) {
    switch num {
    case 0:
        return (val, r.1, r.2, r.3)
    case 1:
        return (r.0, val, r.2, r.3)
    case 2:
        return (r.0, r.1, val, r.3)
    case 3:
        return (r.0, r.1, r.2, val) 
    default:
        return (r.0, r.1, r.2, r.3)
    }
}

func regVal(_ r: (Int, Int, Int, Int), _ num: Int) -> Int {
    switch num {
    case 0:
        return r.0
    case 1:
        return r.1
    case 2:
        return r.2
    default:
        return r.3
    }
}

func check(_ opcode: String, _ v: (Int, Int, Int, Int), 
           _ r: (Int, Int, Int, Int)) -> (Int, Int, Int, Int) {
    switch opcode {
    case "addr":
        return regSet(r, v.3, regVal(r, v.1) + regVal(r, v.2))
    case "addi":
        return regSet(r, v.3, regVal(r, v.1) + v.2)
    case "mulr":
        return regSet(r, v.3, regVal(r, v.1) * regVal(r, v.2))
    case "muli":
        return regSet(r, v.3, regVal(r, v.1) * v.2)
    case "banr":
        return regSet(r, v.3, regVal(r, v.1) & regVal(r, v.2))
    case "bani":
        return regSet(r, v.3, regVal(r, v.1) & v.2)
    case "borr":
        return regSet(r, v.3, regVal(r, v.1) | regVal(r, v.2))
    case "bori":
        return regSet(r, v.3, regVal(r, v.1) | v.2)
    case "setr":
        return regSet(r, v.3, regVal(r, v.1))
    case "seti":
        return regSet(r, v.3, v.1)
    case "gtir":
        return v.1 > regVal(r, v.2) ? regSet(r, v.3, 1) : regSet(r, v.3, 0)
    case "gtri":
        return regVal(r, v.1) > v.2 ? regSet(r, v.3, 1) : regSet(r, v.3, 0)
    case "gtrr":
        return regVal(r, v.1) > regVal(r, v.2) ? regSet(r, v.3, 1) : regSet(r, v.3, 0)
    case "eqir":
        return v.1 == regVal(r, v.2) ? regSet(r, v.3, 1) : regSet(r, v.3, 0)
    case "eqri":
        return regVal(r, v.1) == v.2 ? regSet(r, v.3, 1) : regSet(r, v.3, 0)
    case "eqrr":
        return regVal(r, v.1) == regVal(r, v.2) ? regSet(r, v.3, 1) : regSet(r, v.3, 0)
    default:
        return (0, 0, 0, 0)
    }
    
}

func buildTupleList(_ input: [String]) -> [((Int, Int, Int, Int), (Int, Int, Int, Int), (Int, Int, Int, Int))] {
    var stream = SimpleStream(input)
    var list = [((Int, Int, Int, Int), (Int, Int, Int, Int), (Int, Int, Int, Int))]()

    var line: String = stream.next()
    
    while line.contains("Before: ") {
        var arr = matches(for: "\\d+", in: line).map({ Int($0)! })
        let regBeforeTuple = (arr[0], arr[1], arr[2], arr[3])
        
        
        line = stream.next()
        arr = matches(for: "\\d+", in: line).map({ Int($0)! })
        let valueTuple = (arr[0], arr[1], arr[2], arr[3])
        
        line = stream.next()
        arr = matches(for: "\\d+", in: line).map({ Int($0)! })
        let regAfterTuple = (arr[0], arr[1], arr[2], arr[3])
        
        list.append((regBeforeTuple, valueTuple, regAfterTuple))
        line = stream.next()
    }
    
    return list
}

func main() {
    var input = readInput()
    let opcodes = ["addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori", "setr", "seti", "gtir", "gtri", "gtrr", "eqir", "eqri", "eqrr"]
    
    var sampleCount = 0
    var list = buildTupleList(input)
    var opcodeMapping = [String: Int]()
    opcodes.forEach({ opcodeMapping[$0] = 0 })
    
    for (regBefore, values, regAfter) in list {
        var behavedOpcodes = 0
        
        for opcode in opcodes {
            if check(opcode, values, regBefore) == regAfter {
                behavedOpcodes += 1
            }
            
            if behavedOpcodes >= 3 {
                sampleCount += 1
                break
            }
        }
    }
    
    print(sampleCount)
    print(opcodeMapping)
}

main()
