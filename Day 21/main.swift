//
//  Advent of Code 2018 - Day 21
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
    var set = Set<Int>()
    var part1 = false
    var prev = 0
    
    while regVal(register, ipReg) < instructions.count {
        let instr = instructions[regVal(register, ipReg)]
        
        // Execute instruction
        register = execute(instr, register)
        
        if regVal(register, ipReg) == 28 {
            let r3 = regVal(register, 3)
            
            if !part1 {
                part1 = true
                print("Part 1: \(r3)")
            }
            
            if set.contains(regVal(register, 3)) {
                print("Part 2: \(prev)")
                break
            }
            
            prev = r3
            set.insert(r3)
        }
        
        // Increment instruction pointer
        register = regSet(register, ipReg, regVal(register, ipReg) + 1)
    }
    
    return register
}

func main() {
    let input = readInput()
    var ipReg: Int, instructions: [(String, Int, Int, Int)]
    (ipReg, instructions) = parseInstructions(input)
    
    // Instruction number that determines whether to continue running or halt
    let BREAK_INSTR = 28
    var register = (0, 0, 0, 0, 0, 0)
    var part1Reached = false
    var prevR3Set = Set<Int>()
    var prevR3 = 0
    
    while regVal(register, ipReg) < instructions.count {
        let instr = instructions[regVal(register, ipReg)]
        // Execute instruction
        register = execute(instr, register)
        
        if regVal(register, ipReg) == BREAK_INSTR {
            let r3 = regVal(register, 3)
            
            if !part1Reached {
                part1Reached = true
                print("Part 1: \(r3)")
            }
            
            if prevR3Set.contains(regVal(register, 3)) {
                print("Part 2: \(prevR3)")
                break
            }
            
            prevR3 = r3
            prevR3Set.insert(r3)
        }
        
        // Increment instruction pointer
        register = regSet(register, ipReg, regVal(register, ipReg) + 1)
    }    
}

main()

/*

 ip: 5
 
 0 seti 123 0 3
   r3 = 123
 1 bani 3 456 3
   r3 = r3 & 456 = 123 & 456 = 72
 2 eqri 3 72 3
   r3 = r3 == 72 ? 1 : 0 = 1
 3 addr 3 5 5
   r5 = r3 + r5 = 4
 4 seti 0 0 5
   // r5 = 0
 5 seti 0 0 3
   r3 = 0
 6 bori 3 65536 2
   r2 = r3 | 65536 = 65536
 7 seti 14070682 0 3
   r3 = 14070682
 8 bani 2 255 1
   r1 = r2 & 255 = 65536 & 255 = 0
 9 addr 3 1 3
   r3 = r3 + r1 = 14070682
 10 bani 3 16777215 3
   r3 = r3 + 16777215 = 30847897
 11 muli 3 65899 3
   r3 = r3 * 65899 = 2032845564403
 12 bani 3 16777215 3
   r3 = r3 & 16777215 = 633331
 13 gtir 256 2 1
   r1 = 256 > r2 ? 1 : 0 = 0
 14 addr 1 5 5
   pc = r1 + pc = 14
 15 addi 5 1 5
   pc = pc + 1 = 16
 16 seti 27 8 5
   pc = 27 (goto 28)
 17 seti 0 3 1
   r1 = 0
 18 addi 1 1 4
   r4 = r1 + 1 = 1
 19 muli 4 256 4
   r4 = r4 * 256 = 256
 20 gtrr 4 2 4
   r4 = r4 > r2 ? 1 : 0 = 0
 21 addr 4 5 5
   pc = r4 + pc = 21
 22 addi 5 1 5
   pc = pc + 1 (go to 24)
 23 seti 25 8 5
   r5 = 25 (go to 26)
 24 addi 1 1 1
   r1 = r1 + 1 = 1
 25 seti 17 9 5
   pc = 17 (go to 18)
 26 setr 1 4 2
   r2 = r1 = 1
 27 seti 7 5 5
   pc = 7 (go to 8)
 28 eqrr 3 0 1
   r1 = r3 == r0 ? 1 : 0
 30 addr 1 5 5
   pc = pc + r1 (exit if r1 is 1 (r3 == r0))
 31 seti 5 4 5
   pc = 5 (go back to line 6)
 
 */
