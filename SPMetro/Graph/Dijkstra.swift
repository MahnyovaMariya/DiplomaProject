import Foundation

public enum Visit<T: Hashable> {
    case start
    case edge(Edge<T>)
}

public class Dijkstra<T: Hashable> {
    public typealias Graph = AdjacencyList<T>
    let graph: Graph
    
    public init(graph: Graph) { self.graph = graph }
    
    private func route(to destination: Vertex<T>,
                       with paths: [Vertex<T> : Visit<T>]) -> [Edge<T>] {
        var vertex = destination
        var path: [Edge<T>] = []
        while let visit = paths[vertex], case .edge(let edge) = visit {
            path = [edge] + path
            vertex = edge.source
        }
    return path
    }
    
    private func distance(to destination: Vertex<T>,
                          with paths: [Vertex<T> : Visit<T>]) -> Double {
        let path = route(to: destination, with: paths)
        let distances = path.compactMap{ $0.weight }
        return distances.reduce(0.0, +)
    }
    
    
    public func shortestPath(from start: Vertex<T>) -> [Vertex<T> : Visit<T>] {
        var paths: [Vertex<T>: Visit<T>] = [start: .start]
        var priorityQueue = PriorityQueue<Vertex<T>>.init(sort: {
                self.distance(to: $0, with: paths) < self.distance(to: $1, with: paths)
        })
        priorityQueue.enqueue(start)
        while let vertex = priorityQueue.dequeue() {
            for edge in graph.edges(from: vertex) {
                guard let weight = edge.weight else {
                    continue
                }
                if (paths[edge.destination] == nil) || (distance(to: vertex, with: paths) + weight < distance(to: edge.destination, with: paths)) {
                    paths[edge.destination] = .edge(edge)
                    priorityQueue.enqueue(edge.destination)
                }
            }
        }
        return paths
    }
    
    public func longestPath(from start: Vertex<T>) -> [Vertex<T> : Visit<T>] {
        var paths: [Vertex<T>: Visit<T>] = [start: .start]
        var priorityQueue = PriorityQueue<Vertex<T>>.init(sort: {
                self.distance(to: $0, with: paths) > self.distance(to: $1, with: paths)
        })
        priorityQueue.enqueue(start)
        while let vertex = priorityQueue.dequeue() {
            for edge in graph.edges(from: vertex) {
                guard edge.weight != nil else { continue }
                if (paths[edge.destination] == nil) {
                    paths[edge.destination] = .edge(edge)
                    priorityQueue.enqueue(edge.destination)
                }
            }
        }
      return paths
    }
    
    public func shortestPath(to destination: Vertex<T>,
                             paths: [Vertex<T>:Visit<T>]) -> [Edge<T>] {
        return route(to: destination, with: paths)
    }

    public func breadthFirstSearch(from source: Vertex<T>, to destination: Vertex<T>) -> [Edge<T>]? {
        var queue = QueueStack<Vertex<T>>()
        queue.enqueue(source)
        var visits: [Vertex<T> : Visit<T>] = [source : .start]
        while let visitedVertex = queue.dequeue() {
            if visitedVertex == destination {
                var vertex = destination
                var route: [Edge<T>] = []
                while let visit = visits[vertex], case .edge(let edge) = visit {
                    route = [edge] + route
                    vertex = edge.source
                }
                return route
            }
            let neighbourEdges = graph.edges(from: visitedVertex) ?? []
            for edge in neighbourEdges {
                if visits[edge.destination] == nil {
                    queue.enqueue(edge.destination)
                    visits[edge.destination] = .edge(edge)
                }
            }
        }
        return nil
    }
}
