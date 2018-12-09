//
//  Advent of Code 2018 - Day 9
//  Author: JeffreyCA
//

import Foundation

func main() {
    let input = readInput().first!.components(separatedBy: " ")
    let playerCount = Int(input[0])!
    let lastMarble = Int(input[6])!
    
    // Double-ended queue representing the game
    var deque = Deque<Int>()
    deque.enqueueBack(0)
    
    // Player score counts
    var scores = [Int].init(repeating: 0, count: playerCount)

    for marble in 1 ... lastMarble - 1 {
        let currentPlayer = marble % playerCount
        
        if marble % 23 == 0 {
            // Add current marble to player score
            scores[currentPlayer] += marble
            // Remove the marble 7 positions counter-clockwise from the current marble and add to player score
            deque.rotate(7)
            scores[currentPlayer] += deque.dequeueBack()!
            // Rotate queue backwards by one so that the marble clockwise to removed marble is the current marble
            deque.rotate(-1)
        } else {
            // This series of operations ensures the current marble is always at the (right) end of the queue
            // E.g. [1, 0, 2] becomes [0, 2, 1]
            deque.rotate(-1)
            // E.g. [0, 2, 1] becomes [0, 2, 1, 3], 3 is current marble
            deque.enqueueBack(marble)
        }
    }
    
    print(scores.max()!)
}

main()
