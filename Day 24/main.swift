//
//  Advent of Code 2018 - Day 24
//  Author: JeffreyCA
//

import Foundation

struct Group: Hashable {
    enum System {
        case immune
        case infection
    }
    
    enum DamageType {
        case bludgeoning
        case cold
        case fire
        case radiation
        case slashing
    }
    
    // Convert damage type string to enum value
    static func damageTypeFromString(_ str: String) -> DamageType {
        switch str {
        case "bludgeoning":
            return .bludgeoning
        case "cold":
            return .cold
        case "fire":
            return .fire
        case "radiation":
            return .radiation
        default:
            return .slashing
        }
    }
    
    var id: Int
    var units: Int
    var hp: Int
    var boost: Int
    
    var system: System
    var immunities: Set<DamageType>
    var weaknesses: Set<DamageType>
    var atkType: DamageType
    
    var atkDamage: Int
    var initiative: Int
    
    init(_ id: Int, _ units: Int, _ hp: Int, _ system: System, _ immunities: [String], _ weaknesses: [String], 
         _ atkType: String, _ atkDamage: Int, _ initiative: Int, _ boost: Int = 0) {
        self.id = id
        self.units = units
        self.hp = hp
        self.system = system
        self.immunities = Set<DamageType>(immunities.map({ Group.damageTypeFromString($0) }))
        self.weaknesses = Set<DamageType>(weaknesses.map({ Group.damageTypeFromString($0) }))
        self.atkType = Group.damageTypeFromString(atkType)
        self.atkDamage = atkDamage
        self.initiative = initiative
        self.boost = boost
    }
    
    // Calculate effective power of group
    func effectivePower() -> Int {
        return self.units * (self.atkDamage + self.boost)
    }
    
    // Determine the amount nof damage that would be dealt to the target
    func damageDealtTo(_ target: Group) -> Int {
        if target.immunities.contains(self.atkType) {
            return 0
        } else if target.weaknesses.contains(self.atkType) {
            return self.effectivePower() * 2
        } else {
            return self.effectivePower()
        }
    }
    
    // Deal damage to target
    func dealDamage(_ target: inout Group) {
        let damageDealt = damageDealtTo(target)
        let unitsEliminated = min(damageDealt / target.hp, target.units)
        target.units -= unitsEliminated
    }
    
    // Determine which target to attack, excluding targets in given exclusion set. Return nil if no target found.
    func chooseTarget(from groups: [Group], excluding exclusion: Set<Int>) -> Group? {
        var damageDealt = [Group: Int]()
        let allTargets = groups.filter({ !exclusion.contains($0.id) && $0.system != self.system && $0.units > 0 })
        
        // No target available
        if allTargets.count == 0 {
            return nil
        }

        for target in allTargets {
            damageDealt[target] = damageDealtTo(target)
        }
        
        // Do not select target if maximum damage that would be dealt is 0
        let maxDamageDealt = damageDealt.values.max()!
        if maxDamageDealt == 0 {
            return nil
        }
        
        // Trim down viable targets until there is one left
        var viableTargets = allTargets.filter({ damageDealt[$0] == maxDamageDealt })
        if viableTargets.count > 1 {
            // Choose targets based on largest effective power
            let maxEffectivePower = viableTargets.map({ $0.effectivePower() }).max()!
            viableTargets = viableTargets.filter({ $0.effectivePower() == maxEffectivePower })
            
            if viableTargets.count > 1 {
                // Choose target based on largest initiative
                let maxInitiative = viableTargets.map({ $0.initiative }).max()!
                viableTargets = viableTargets.filter({ $0.initiative == maxInitiative })
            }
        }

        return viableTargets[0]
    }
}

struct Simulation {
    // Keep original group list so simulations can be reset and re-run
    let originalGroups: [Group]
    var groups: [Group]
    
    init(_ groups: [Group]) {
        self.originalGroups = groups
        self.groups = groups
    }
    
    // Determine number of alive units for given system
    func aliveUnits(for system: Group.System) -> Int {
        return groups.filter({ $0.system == system && $0.units > 0 }).map({ $0.units }).reduce(0, +)
    }
    
    // Comparison function prioritizing greater effective power and greater initiative (in case of tie)
    func sortByEffectivePowerInitiative(_ g1: Group, _ g2: Group) -> Bool {
        return g1.effectivePower() > g2.effectivePower() || 
            (g1.effectivePower() == g2.effectivePower() && g1.initiative > g2.initiative)
    }
    
    // Run simulation until stalemate or one system (immune or infection) has been entirely eliminated.
    // Return a tuple of the winning system and amount of units it has left
    mutating func simulate(withImmuneBoost immuneBoost: Int = 0) -> (Group.System, Int) {
        // Reset simulation
        self.groups = self.originalGroups
        
        // Apply boost
        for index in 0 ..< self.groups.count {
            if self.groups[index].system == .immune {
                self.groups[index].boost = immuneBoost
            }
        }
        
        // Tracks stalemate condition where an entire round completes with no groups dealing damage
        var damageDealt = false
        
        while aliveUnits(for: .immune) != 0 && aliveUnits(for: .infection) != 0 {
            // Store each group's chosen target
            var targetMap = [Int: Int]()
            // Set of targeted group indices
            var targetedGroups = Set<Int>()
            // Ordered by effective power and initiative (in case of tie) to choose targets
            var sortedAlive = groups.filter({ $0.units > 0 }).sorted(by: sortByEffectivePowerInitiative)
            
            // Target selection
            for group in sortedAlive {
                let target = group.chooseTarget(from: groups, excluding: targetedGroups)
                
                if let target = target {
                    targetMap[group.id] = target.id
                    targetedGroups.insert(target.id)
                }
            }
            
            // Ordered by initiative (in case of tie) for attack phase
            sortedAlive = groups.filter({ $0.units > 0 }).sorted(by: { $0.initiative > $1.initiative })
            // Reset stalemate flag
            damageDealt = false
            
            for group in sortedAlive {
                if let targetIndex = targetMap[group.id] {
                    if groups[targetIndex].units > 0 {
                        groups[group.id].dealDamage(&groups[targetIndex])
                        damageDealt = true
                    }
                }
            }
            
            // Stalemate, exit with infection victory
            if !damageDealt {
                break
            }
        }
        
        let aliveImmune = aliveUnits(for: .immune)
        let aliveInfection = aliveUnits(for: .infection)
        
        // Infection system wins even if there are alive immune groups
        if aliveInfection == 0 {
            return (.immune, aliveImmune)
        } else {
            return (.infection, aliveInfection)
        }
    }
}

// Parse input into list of groups
func parseInput(_ input: [String]) -> [Group] {
    var groups = [Group]()
    var currentSystem = Group.System.immune
    var id = 0
    
    for line in input {
        // Current line describes system
        if line.contains("Immune") {
            currentSystem = .immune
            continue
        } else if line.contains("Infection") {
            currentSystem = .infection
            continue
        }
        
        // Current line describes group
        // Parse numbers
        let numbers = matches(for: "\\d+", in: line)
        assert(numbers.count == 4)
        
        let units = Int(numbers[0])!, hp = Int(numbers[1])!, atkDamage = Int(numbers[2])!, initiative = Int(numbers[3])!

        // Parse weaknesses, immunities
        let weakImmuneText = matches(for: "\\(.*\\)", in: line)
        var immunities = [String]()
        var weaknesses = [String]()
        
        if !weakImmuneText.isEmpty {
            let weakText = matches(for: "(?<=weak to ).*?[;)]", in: weakImmuneText[0])
            let immuneText = matches(for: "(?<=immune to ).*?[;)]", in: weakImmuneText[0])
            
            if !weakText.isEmpty {
                // Group has weaknesses
                weaknesses = weakText[0].trimmingCharacters(in: [ ";", ")" ]).components(separatedBy: ", ")
            }
            
            if !immuneText.isEmpty {
                // Group has immunities
                immunities = immuneText[0].trimmingCharacters(in: [ ";", ")" ]).components(separatedBy: ", ")
            }
        }
        
        // Parse attack damage type
        let atkType = matches(for: "\\w+ (?=damage)", in: line)[0].trimmingCharacters(in: [" "])
        let group = Group(id, units, hp, currentSystem, immunities, weaknesses, atkType, atkDamage, initiative)
        
        groups.append(group)
        id += 1        
    }
    
    return groups
}

func main() {
    let input = readInput()
    let groups = parseInput(input)
    
    // Part 1
    var simulation = Simulation(groups)
    var result = simulation.simulate()
    var winningSystem = result.0
    var winningUnits = result.1
    print("Winning army has \(winningUnits) units left")
    
    // Part 2
    var immuneBoost = 1
    while winningSystem == .infection {
        immuneBoost += 1
        result = simulation.simulate(withImmuneBoost: immuneBoost)
        winningSystem = result.0
        winningUnits = result.1
    }

    print("Immune system wins with \(winningUnits) units left (boost = \(immuneBoost))")
}

main()
