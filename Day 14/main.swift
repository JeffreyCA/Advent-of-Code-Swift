//
//  Advent of Code 2018 - Day 14
//  Author: JeffreyCA
//

import Foundation

func main() {
    let recipeCount = readInput()[0] 
    let recipeDigits = recipeCount.count
    
    // Initial scoreboard
    var scoreboard = [3, 7]
    // Store the sum of the scores of the two workers
    var scoreSum = 0
    // Indices of where the two workers are
    var workerIndex1 = 0
    var workerIndex2 = 1
    // Index of score sequence string that matches current scores
    var matchIndex = 0
    
    // Keep adding new scores until we fully match the given score sequence
    while matchIndex < recipeDigits {
        scoreSum = scoreboard[workerIndex1] + scoreboard[workerIndex2]
        
        if scoreSum >= 10 {
            // Split sum into two scores for each worker
            let score1 = scoreSum / 10, score2 = scoreSum % 10
            
            // Try to match the two new scores to given score sequence
            if matchIndex == recipeDigits - 1 && String(score1) == String(recipeCount[matchIndex]) {
                // Match the last score in sequence
                matchIndex += 1
            } else if String(score1) == String(recipeCount[matchIndex]) &&
                    String(score2) == String(recipeCount[matchIndex + 1]) {
                // Match both scores
                matchIndex += 2
            } else {
                // No match found, go back to matching from beginning of sequence
                matchIndex = 0
            }
            
            scoreboard.append(score1)
            scoreboard.append(score2)
        } else {            
            if matchIndex == recipeDigits && String(scoreSum) == String(recipeCount[matchIndex]) {
                // Match the last score in sequence
                matchIndex += 1
            } else if String(scoreSum) == String(recipeCount[matchIndex]) {
                // Match found, advance match index
                matchIndex += 1
            } else {
                // No match found
                matchIndex = 0
            }
            
            scoreboard.append(scoreSum)
        }
        
        // Set next worker index
        workerIndex1 = (workerIndex1 + 1 + scoreboard[workerIndex1]) % scoreboard.count
        workerIndex2 = (workerIndex2 + 1 + scoreboard[workerIndex2]) % scoreboard.count
    }

    let nextTenRecipes = scoreboard.prefix(Int(recipeCount)! + 10).suffix(10).map({ String($0) }).joined()
    print("Next ten recipes after \(recipeCount) recipes: \(nextTenRecipes)")
    print("Number of recipes to left of sequence \(recipeCount): \(scoreboard.count - recipeDigits - 1)")
}

main()
