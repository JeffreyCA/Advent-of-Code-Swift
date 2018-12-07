//
//  Advent of Code 2018 - Day 7
//  Author: JeffreyCA
//

import Foundation

// Graph struct using adjacency list representation
struct Graph {
    var adjacency = [String: [String]]()
    
    mutating func addEdge(origin: String, dest: String) {
        if adjacency[origin] == nil {
            adjacency[origin] = [String]()
        }
        
        if adjacency[dest] == nil {
            adjacency[dest] = [String]()
        }

        adjacency[origin]?.append(dest)
    }
    
    // Kahn’s algorithm
    mutating func topologicalSort() -> [String] {
        // Stores topological sort result
        var sortResult = [String]()
        // Queue of vertices with no incoming edges
        var queue = [String]()
        // Count of number of incoming edges for each vertex
        var inDegree = [String : Int]()
        
        // Initialize in-degree counts
        for vertex in adjacency.keys {
            inDegree[vertex] = 0
        }

        for vertex in adjacency.keys {
            for neighbour in adjacency[vertex]! {
                inDegree[neighbour]! += 1
            }
        }
        
        // Initialize queue
        for vertex in adjacency.keys {
            if inDegree[vertex] == 0 {
                queue.append(vertex)
            }
        }
        
        while !queue.isEmpty {
            // Remove vertex that comes first in alphabetical order
            let min = queue.min()!
            if let index = queue.index(of: min) {
                queue.remove(at: index)
            }
            
            for neighbour in adjacency[min]! {
                inDegree[neighbour]! -= 1
                
                if inDegree[neighbour] == 0 {
                    queue.append(neighbour)
                }
            }
            
            sortResult.append(min)
        }

        return sortResult
    }
}

// Convert input into Graph representation
func parseGraph(input: [String]) -> Graph {
    var graph = Graph()
    var sortedEdges = [[String]]()
    
    for line in input {
        let edge = matches(for: "(?<=[Ss]tep )[A-Z]", in: line)
        sortedEdges.append(edge)
    }
    
    for edge in sortedEdges {
        graph.addEdge(origin: edge[0], dest: edge[1])
    }
    
    return graph
}

func main() {
    let lines = readInput()
    var graph = parseGraph(input: lines)
    print("Order of steps: \(graph.topologicalSort().joined())")
}

main()
