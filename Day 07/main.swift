//
//  Advent of Code 2018 - Day 7
//  Author: JeffreyCA
//

import Foundation

// Graph struct using adjacency list representation
struct Graph {
    var adjacency = [String: [String]]()
    var incoming = [String: [String]]()
    var vertexCount = 0
    
    mutating func addEdge(origin: String, dest: String) {
        if adjacency[origin] == nil {
            adjacency[origin] = [String]()
            incoming[origin] = [String]()
            vertexCount += 1
        }
        
        if adjacency[dest] == nil {
            adjacency[dest] = [String]()
            incoming[dest] = [String]()
            vertexCount += 1
        }

        adjacency[origin]?.append(dest)
        incoming[dest]?.append(origin)
    }
    
    func isEdge(origin: String, dest: String) -> Bool {
        return adjacency[origin]!.contains(dest)
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

// Represents a worker
struct Worker {
    var task: String = ""
    var timeLeft: Int = 0
}

// Determine length of task
func taskLength(letter: String) -> Int {
    return 60 + Int(letter.unicodeScalars.first!.value - "A".unicodeScalars.first!.value) + 1
}

// Produce list of tasks that can be started given list of completed tasks and worker log
func compatibleTasks(_ completed: [String], _ graph: Graph, _ workers: [Worker]) -> [String] {
    let currentTasks = workers.map { (worker) -> String in worker.task }.filter({ !$0.isEmpty })
    let availableTasks = graph.adjacency.keys.filter{!currentTasks.contains($0) && !completed.contains($0)}
    var compatibleTasks = [String]()
    
    for key in availableTasks {
        var foundCompatibleTask = true
        
        // Make sure all prerequisites are completed
        for incoming in graph.incoming[key]! {
            if !completed.contains(incoming) {
                foundCompatibleTask = false
                break
            }
        }
        
        if foundCompatibleTask {
            compatibleTasks.append(key)
        }
    }
    
    // Order in which tasks are added not necessarily in order (depends on hashing?)
    return compatibleTasks.sorted()
}

func main() {
    let lines = readInput()
    var graph = parseGraph(input: lines)
    print("Order of steps: \(graph.topologicalSort().joined())")
    
    let WORKER_COUNT = 5
    var workers = [Worker].init(repeating: Worker(), count: WORKER_COUNT)
    var completedTasks = [String]()
    var time = 0

    // Simulate work
    while completedTasks.count < graph.vertexCount {
        for (index, _) in workers.enumerated() {
            if !workers[index].task.isEmpty {
                workers[index].timeLeft -= 1
                
                // Task completed, free up worker
                if workers[index].timeLeft == 0 {
                    completedTasks.append(workers[index].task)
                    workers[index].task = ""
                }
            }
        }
        
        let availableTasks = compatibleTasks(completedTasks, graph, workers)
        
        for task in availableTasks {
            for (index, _) in workers.enumerated() {
                // Set worker to work on task
                if workers[index].task.isEmpty {
                    workers[index].task = task
                    workers[index].timeLeft = taskLength(letter: task)
                    break
                }
            }
        }
        
        time += 1
    }
    
    print("Time to complete all steps: \(time - 1)")
}

main()
