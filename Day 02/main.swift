//
//  Advent of Code 2018 - Day 2
//  Author: JeffreyCA
//

import Foundation

// Determine whether the two words differ by exactly one character.
//
// If so, return true and the index of the different characters.
// Otherwise, return false.
func differsByOne(_ word1: String, _ word2: String) -> (Bool, Int) {
    var diffCount: Int = 0
    var diffIndex: Int = -1
    var differByOne: Bool = false
    
    if word1 != word2 && word1.count == word2.count {
        for index in 0 ..< word1.count {
            if word1[index] != word2[index] {
                diffCount += 1
                diffIndex = index
                differByOne = true
            }
            
            if diffCount > 1 {
                differByOne = false
                break
            }
        }
    }
    return (differByOne, diffIndex)
}

// Generate character frequencies for each letter in the word
func calcFreqMap(_ word: String) -> [Character: Int] {
    var characterCount = [Character: Int]()
    
    for char in word {
        if characterCount[char] != nil {
            characterCount[char]! += 1
        } else {
            characterCount[char] = 1
        }
    }
    
    return characterCount
}

func main() {
    let words = readInput()
    var twoCount = 0
    var threeCount = 0
    
    for word in words {
        var foundTwo = false
        var foundThree = false
        
        let freqMap = calcFreqMap(word)
        
        for count in freqMap.values {
            if (count == 2) {
                foundTwo = true
            }
            if (count == 3) {
                foundThree = true
            }
        }
        
        if (foundTwo) {
            twoCount += 1
        }
        if (foundThree) {
            threeCount += 1
        }
    }
    
    print("Two count: \(twoCount)")
    print("Three count: \(threeCount)")
    print("Checksum: \(twoCount * threeCount)")
    
    outerLoop: for word in words {
        for word2 in words {
            if word != word2 {
                let result = differsByOne(word, word2)
                
                if result.0 {
                    let commonLetters = word[0...(result.1 - 1)] + word[(result.1 + 1)...]
                    print("Common letters: \(commonLetters)")
                    break outerLoop
                }
            }
        }
    }
}

main()
