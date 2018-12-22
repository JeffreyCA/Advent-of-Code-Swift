//
//  Advent of Code 2018 - Day 16
//  Author: JeffreyCA
//

import Foundation

// Helper function to set register 'num' to 'val'
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

// Helper function to get value of register 'num'
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

// Execute instruction 'i' on register states 'r' and opcode name 'opcode'
func execute(_ opcode: String, _ i: (Int, Int, Int, Int), 
           _ r: (Int, Int, Int, Int)) -> (Int, Int, Int, Int) {
    switch opcode {
    case "addr":
        return regSet(r, i.3, regVal(r, i.1) + regVal(r, i.2))
    case "addi":
        return regSet(r, i.3, regVal(r, i.1) + i.2)
    case "mulr":
        return regSet(r, i.3, regVal(r, i.1) * regVal(r, i.2))
    case "muli":
        return regSet(r, i.3, regVal(r, i.1) * i.2)
    case "banr":
        return regSet(r, i.3, regVal(r, i.1) & regVal(r, i.2))
    case "bani":
        return regSet(r, i.3, regVal(r, i.1) & i.2)
    case "borr":
        return regSet(r, i.3, regVal(r, i.1) | regVal(r, i.2))
    case "bori":
        return regSet(r, i.3, regVal(r, i.1) | i.2)
    case "setr":
        return regSet(r, i.3, regVal(r, i.1))
    case "seti":
        return regSet(r, i.3, i.1)
    case "gtir":
        return i.1 > regVal(r, i.2) ? regSet(r, i.3, 1) : regSet(r, i.3, 0)
    case "gtri":
        return regVal(r, i.1) > i.2 ? regSet(r, i.3, 1) : regSet(r, i.3, 0)
    case "gtrr":
        return regVal(r, i.1) > regVal(r, i.2) ? regSet(r, i.3, 1) : regSet(r, i.3, 0)
    case "eqir":
        return i.1 == regVal(r, i.2) ? regSet(r, i.3, 1) : regSet(r, i.3, 0)
    case "eqri":
        return regVal(r, i.1) == i.2 ? regSet(r, i.3, 1) : regSet(r, i.3, 0)
    case "eqrr":
        return regVal(r, i.1) == regVal(r, i.2) ? regSet(r, i.3, 1) : regSet(r, i.3, 0)
    default:
        return (0, 0, 0, 0)
    }
}

// Build list of tuples containing the before register state, instruction, and after register state
func buildTupleList(_ input: [String]) -> [((Int, Int, Int, Int), (Int, Int, Int, Int), (Int, Int, Int, Int))] {
    var stream = SimpleStream(input)
    var list = [((Int, Int, Int, Int), (Int, Int, Int, Int), (Int, Int, Int, Int))]()
    var line: String = stream.next()
    
    while line.contains("Before: ") {
        // Parse tuple representing register states prior to instruction execution
        var arr = matches(for: "\\d+", in: line).map({ Int($0)! })
        let regBeforeTuple = (arr[0], arr[1], arr[2], arr[3])
        
        // Parse tuple representing instruction (opcode + arguments)
        line = stream.next()
        arr = matches(for: "\\d+", in: line).map({ Int($0)! })
        let instrTuple = (arr[0], arr[1], arr[2], arr[3])
        
        // Parse tuple representing register states after instruction execution
        line = stream.next()
        arr = matches(for: "\\d+", in: line).map({ Int($0)! })
        let regAfterTuple = (arr[0], arr[1], arr[2], arr[3])
        
        // Add tuple of all three to list
        list.append((regBeforeTuple, instrTuple, regAfterTuple))
        line = stream.next()
    }
    
    return list
}

// Build list of instructions for test program to execute
func buildInstrList(_ input: [String]) -> [(Int, Int, Int, Int)] {
    var stream = SimpleStream(input)
    var list = [(Int, Int, Int, Int)]()
    
    // Skip part 1 input
    var line: String = stream.next()
    while line.contains("Before: ") {
        // Skip before, instruction, after lines
        for _ in 1 ... 3 {
            line = stream.next()
        }
    }
    
    // Parse instructions into 4-tuples
    while line != "" {
        let split = line.components(separatedBy: " ").map({ Int($0)! })
        list.append((split[0], split[1], split[2], split[3]))        
        line = stream.next()
    }
    
    return list
}

// Determine the number of sample instructions that behave like 'min' or more opcodes
func determineSimilarBehaved(_ sampleList: [((Int, Int, Int, Int), (Int, Int, Int, Int), (Int, Int, Int, Int))], 
                             _ opcodes: [String], _ min: Int) -> Int {
    var similarCount = 0

    for (regBefore, values, regAfter) in sampleList {
        var behavedOpcodes = 0
        
        for opcode in opcodes {
            if execute(opcode, values, regBefore) == regAfter {
                behavedOpcodes += 1
            }
        }
        
        if behavedOpcodes >= min {
            similarCount += 1
        }
    }
    
    return similarCount
}

// Determine one-one mapping of opcodes
func determineMapping(_ sampleList: [((Int, Int, Int, Int), (Int, Int, Int, Int), (Int, Int, Int, Int))], 
                      _ opcodes: [String]) -> [String] {
    let instructionCount = opcodes.count
    // Initialize opcode mapping so that every opcode number is associated with every possible name, then
    // eliminate elements until each opcode is associated with one particular name through set intersection
    var opcodeMapping = [Set<String>].init(repeating: Set<String>.init(opcodes), count: instructionCount)
    
    // Interate through sample instructions with opcodes 0 to 15
    for i in 0 ..< instructionCount {
        let filtered = sampleList.filter({ $0.1.0 == i })
        
        for (regBefore, values, regAfter) in filtered {
            var behavedOpcodeSet = Set<String>()
            
            for opcode in opcodes {
                if execute(opcode, values, regBefore) == regAfter {
                    // Add the possible meanings of the current opcode to a set
                    behavedOpcodeSet.insert(opcode)
                }
            }
            
            // Take the set intersection of current mapping values with list of meanings that satisfy the opcode
            opcodeMapping[i] = opcodeMapping[i].intersection(behavedOpcodeSet)
        }
    }
    
    // Now, there may still be some opcode numbers associated with multiple names, so we consider the opcode
    // that is already fully associated (only one name) and eliminate that from all the other mappings.
    // 
    // We repeat this until we get a one-one mapping for each opcode.
    var changed: Bool
    repeat {
        changed = false
        
        for key in 0 ..< opcodeMapping.count {
            // Consider the opcode with only one associated name
            if opcodeMapping[key].count == 1 {
                let mapping = opcodeMapping[key].first!
                for key2 in 0 ..< opcodeMapping.count {
                    // Remove that associated name from all other mappings
                    if key != key2 && opcodeMapping[key2].remove(mapping) != nil {
                        // Must do another pass if something was removed to ensure every mapping is one-one
                        changed = true
                    }
                }
                
            }
        }
    } while changed
    
    // Convert array of sets to array of Int since we have acheived a one-one mapping
    let singleMapping = opcodeMapping.map( { $0.first! })
    return singleMapping
}

// Run list of instructions on registers initially set to (0, 0, 0, 0) and return resulting register values
func runProgram(_ instrList: [(Int, Int, Int, Int)], _ instrMap: [String]) -> (Int, Int, Int, Int) {
    var currentState = (0, 0, 0, 0)
    for instr in instrList {
        // Overwrite register values with result of instruction execution
        currentState = execute(instrMap[instr.0], instr, currentState)
    }
    return currentState
}

func main() {
    let input = readInput()
    let opcodes = ["addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori", "setr", "seti", "gtir", "gtri",
                   "gtrr", "eqir", "eqri", "eqrr"]
    let sampleList = buildTupleList(input)
    
    // Part 1
    let similarCount = determineSimilarBehaved(sampleList, opcodes, 3)
    print("Samples behaving like three or more opcodes: \(similarCount)")    
    
    // Part 2
    let singleMapping = determineMapping(sampleList, opcodes)
    let testProgram = buildInstrList(input)
    let result = runProgram(testProgram, singleMapping)
    
    // Output contents of register 0
    print("Register 0: \(result.0)")
}

main()
