import Foundation

class Path {
    
    var arrayOfTimeIntervals: [Int]
    var vertexArr: [Vertex<String>] = []
    var graph = AdjacencyList<String>()
    
    init(arrayOfTimeIntervals: [Int]) {
        self.arrayOfTimeIntervals = arrayOfTimeIntervals
    }
    
    func createVertexes(dataArray: [GetData]) -> [String] {
        
        var stringCoordinatesForLayer: [String] = []
        var arrayOfNames: [String] = []
        
        for i in 0...dataArray.count - 1 {
            if dataArray[i].nameStation != "" {
                arrayOfTimeIntervals.append(dataArray[i].timeIntervalBetweenStations)
                stringCoordinatesForLayer.append(dataArray[i].coordinatesForDrawLayer)
                arrayOfNames.append(dataArray[i].nameStation)
            }
        }
        
        for i in 0...arrayOfNames.count - 1 {
            let vertex = graph.createVertex(data: arrayOfNames[i])
            vertexArr.append(vertex)
        }
        
        return stringCoordinatesForLayer
    }
    
    func createEdges() -> (AdjacencyList<String>, [Vertex<String>]) {
        
        var countOfElements = 0
        var o = 0
        
        while countOfElements < vertexArr.count - 1 {
            if vertexArr[countOfElements].data != "Проспект Ветеранов" && vertexArr[countOfElements].data != "Купчино" && vertexArr[countOfElements].data != "Рыбацкое" && vertexArr[countOfElements].data != "Улица Дыбенко" && vertexArr[countOfElements].data != "Шушары" {
                    graph.add(.undirected, from: vertexArr[countOfElements], to: vertexArr[countOfElements+1], weight: Double(arrayOfTimeIntervals[o]))
                        if vertexArr[countOfElements].data == "Площадь Восстания" {
                            graph.add(.undirected, from: vertexArr[countOfElements], to: vertexArr[countOfElements+36], weight: 1.9)
                        } else if vertexArr[countOfElements].data == "Владимирская" {
                            graph.add(.undirected, from: vertexArr[countOfElements], to: vertexArr[countOfElements+43], weight: 1.9)
                        } else if vertexArr[countOfElements].data == "Пушкинская" {
                            graph.add(.undirected, from: vertexArr[countOfElements], to: vertexArr[countOfElements+58], weight: 1.9)
                        } else if vertexArr[countOfElements].data == "Технологический институт (к)" {
                            graph.add(.undirected, from: vertexArr[countOfElements], to: vertexArr[countOfElements+18], weight: 1)
                        } else if vertexArr[countOfElements].data == "Невский проспект" {
                            graph.add(.undirected, from: vertexArr[countOfElements], to: vertexArr[countOfElements+15], weight: 1.9)
                        } else if vertexArr[countOfElements].data == "Сенная площадь" {
                            graph.add(.undirected, from: vertexArr[countOfElements], to: vertexArr[countOfElements+39], weight: 2.9)
                            graph.add(.undirected, from: vertexArr[countOfElements], to: vertexArr[countOfElements+23], weight: 2.9)
                        } else if vertexArr[countOfElements].data == "Спасская" {
                            graph.add(.undirected, from: vertexArr[countOfElements], to: vertexArr[countOfElements+16], weight: 2.9)
                        } else if vertexArr[countOfElements].data == "Площадь Александра Невского (з)" {
                            graph.add(.undirected, from: vertexArr[countOfElements], to: vertexArr[countOfElements+9], weight: 1.9)
                        }
                
                        o += 1
            }
            else if vertexArr[countOfElements].data == "Проспект Ветеранов" || vertexArr[countOfElements].data == "Улица Дыбенко" {
                graph.add(.undirected, from: vertexArr[countOfElements], to: vertexArr[countOfElements-1], weight: 2)
                o += 1
            } else if vertexArr[countOfElements].data == "Купчино" || vertexArr[countOfElements].data == "Шушары" {
                graph.add(.undirected, from: vertexArr[countOfElements], to: vertexArr[countOfElements-1], weight: 3)
                o += 1
            } else if vertexArr[countOfElements].data == "Рыбацкое" {
                graph.add(.undirected, from: vertexArr[countOfElements], to: vertexArr[countOfElements-1], weight: 4)
                o += 1
            }
            
            countOfElements += 1
        }
        
        return (graph, vertexArr)
    }
    
    func buildFirstPath(newDijkstra: Dijkstra<String>, firstElem: Int, lastElem: Int) -> [Edge<String>] {
        
        let pathsFromA = newDijkstra.shortestPath(from: vertexArr[firstElem])
        let path = newDijkstra.shortestPath(to: vertexArr[lastElem], paths: pathsFromA)
        
        return path
    }
    
    func buildSecondPath(newDijkstra: Dijkstra<String>, firstElem: Int, lastElem: Int) -> [Edge<String>] {
        
        let secondPath = newDijkstra.breadthFirstSearch(from: vertexArr[firstElem], to: vertexArr[lastElem]) ?? []
        return secondPath
    }
    
    func buildThirdPath(newDijkstra: Dijkstra<String>, firstElem: Int, lastElem: Int) -> [Edge<String>] {
        
        let pathsFromA = newDijkstra.longestPath(from: vertexArr[firstElem])
        let thirdPath = newDijkstra.shortestPath(to: vertexArr[lastElem], paths: pathsFromA)
        
        return thirdPath
    }
    
    func searchIdenticalPaths(firstPath: [Edge<String>], secondPath: [Edge<String>], thirdPath: [Edge<String>]) -> ([[Edge<String>]], [Edge<String>], [Edge<String>], [Edge<String>]) {
        
        var allPaths: [[Edge<String>]] = []
        var extraVariableForFirstPath: [Edge<String>] = []
        var extraVariableForSecondPath: [Edge<String>] = []
        var extraVariableForThirdPath: [Edge<String>] = []
        var k1 = 0
        var k2 = 0
        var k3 = 0
        
        for subPath in 0...firstPath.count - 1 {
            for subSecondPath in 0...secondPath.count - 1 {
                if (firstPath[subPath].source == secondPath[subSecondPath].source) && (subPath == subSecondPath) {
                    k1 += 1
                }
            }
        }
        
        for subPath in 0...firstPath.count - 1 {
            for subThirdPath in 0...thirdPath.count - 1 {
                if (firstPath[subPath].source == thirdPath[subThirdPath].source) && (subPath == subThirdPath) {
                    k2 += 1
                }
            }
        }
        
        for subSecondPath in 0...secondPath.count - 1 {
            for subThirdPath in 0...thirdPath.count - 1 {
                if (secondPath[subSecondPath].source == thirdPath[subThirdPath].source) && (subSecondPath == subThirdPath) {
                    k3 += 1
                }
            }
        }
        
        if k1 == firstPath.count && k1 == secondPath.count {
            allPaths.append(firstPath)
            extraVariableForFirstPath = firstPath
        } else if k1 != firstPath.count || k1 != secondPath.count{
            allPaths.append(firstPath)
            allPaths.append(secondPath)
            extraVariableForFirstPath = firstPath
            extraVariableForSecondPath = secondPath
        }
        
        if (k3 != secondPath.count || k3 != thirdPath.count) && (((k1 != firstPath.count && secondPath.count == firstPath.count) || (secondPath.count != firstPath.count)) && ((k2 != firstPath.count && firstPath.count == thirdPath.count) || (firstPath.count != thirdPath.count))) {
            if allPaths.count == 2 {
                allPaths.append(thirdPath)
                extraVariableForThirdPath = thirdPath
            }
        }
        
        if k2 != firstPath.count || k2 != thirdPath.count {
            if allPaths.count == 1 {
                allPaths.append(thirdPath)
                extraVariableForThirdPath = thirdPath
            }
        }
        
        return (allPaths, extraVariableForFirstPath, extraVariableForSecondPath, extraVariableForThirdPath)
    }
}
