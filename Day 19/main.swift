//
//  Advent of Code 2018 - Day 19
//  Author: JeffreyCA
//

import Foundation

// Helper function to set register 'num' to 'val'
func regSet(_ r: (Int, Int, Int, Int, Int, Int), _ num: Int, _ val: Int) -> (Int, Int, Int, Int, Int, Int) {
    switch num {
    case 0:
        return (val, r.1, r.2, r.3, r.4, r.5)
    case 1:
        return (r.0, val, r.2, r.3, r.4, r.5)
    case 2:
        return (r.0, r.1, val, r.3, r.4, r.5)
    case 3:
        return (r.0, r.1, r.2, val, r.4, r.5) 
    case 4:
        return (r.0, r.1, r.2, r.3, val, r.5) 
    case 5:
        return (r.0, r.1, r.2, r.3, r.4, val) 
    default:
        return (r.0, r.1, r.2, r.3, r.4, r.5)
    }
}

// Helper function to get value of register 'num'
func regVal(_ r: (Int, Int, Int, Int, Int, Int), _ num: Int) -> Int {
    switch num {
    case 0:
        return r.0
    case 1:
        return r.1
    case 2:
        return r.2
    case 3:
        return r.3
    case 4:
        return r.4
    default:
        return r.5
    }
}

// Execute instruction 'i' on register states 'r'
func execute(_ i: (String, Int, Int, Int), 
             _ r: (Int, Int, Int, Int, Int, Int)) -> (Int, Int, Int, Int, Int, Int) {
    switch i.0 {
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
        return (0, 0, 0, 0, 0, 0)
    }
}

func parseInstructions(_ input: [String]) -> (Int, [(String, Int, Int, Int)]) {
    let ipReg = Int(matches(for: "\\d+", in: input[0])[0])!
    var instructions = [(String, Int, Int, Int)]()
    
    for index in 1 ..< input.count {
        let split = input[index].components(separatedBy: " ")
        instructions.append((split[0], Int(split[1])!, Int(split[2])!, Int(split[3])!))
    }
    
    return (ipReg, instructions)
}

func runProgram(_ ipReg: Int, _ reg: (Int, Int, Int, Int, Int, Int), 
                _ instructions: [(String, Int, Int, Int)]) -> (Int, Int, Int, Int, Int, Int) {
    var register = reg
    while regVal(register, ipReg) < instructions.count {
        let instr = instructions[regVal(register, ipReg)]
        // Execute instruction
        register = execute(instr, register)
        // Increment instruction pointer
        register = regSet(register, ipReg, regVal(register, ipReg) + 1)
    }
    
    return register
}

func main() {
    let input = readInput()
    var ipReg: Int, instructions: [(String, Int, Int, Int)]
    (ipReg, instructions) = parseInstructions(input)
    
    let zeroStart = runProgram(ipReg, (0, 0, 0, 0, 0, 0), instructions)
    print("Value of register 0 (r0 = 0): \(zeroStart.0)")
    
    let part2Target = 10551386
    var divisorSum = 0
    for i in 1 ... part2Target {
        if part2Target % i == 0 {
            divisorSum += i
        }
    }
    print("Value of register 0 (r0 = 1): \(divisorSum)")
}

main()
