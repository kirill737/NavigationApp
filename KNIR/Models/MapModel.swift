//
//  MapModel.swift
//  KNIR
//
//  Created by kirill on 17.05.2024.
//

import Foundation

class Map {
    var wholeGraph: Graph
    var floorsAmount: Int
    var startPoint: String? = nil
    var endPoint: String? = nil
    var currentFloor: Int
    
    var isWithPath: Bool = false
    var path: [PathNode] = []
    var leveledPath: [Int : [PathNode]]  = [:]
    var availablePoints: [String] = []
    
    init(_ floorsAmount: Int) {
        currentFloor = 1
        self.floorsAmount = floorsAmount
        wholeGraph = Graph()
        for i in 1...floorsAmount {
            leveledPath[i] = []
        }
    }
    func resetMap() {
        for (_, pathNode) in wholeGraph.nodeMap {
            pathNode.resetNode()
        }
        isWithPath = false
        path.removeAll()
        for i in 1...floorsAmount  {
            leveledPath[i]?.removeAll()
        }
    }
    public func findPath(_ startName: String, _ endName: String)
    {
        print("\t\tStart finding a path from \(startName) to \(endName)")
        resetMap()
        guard let start = wholeGraph.nodeMap[startName], let end = wholeGraph.nodeMap[endName] else {
            fatalError("Departure node does not exist")
        }
        
        start.distance = 0
        start.prev = nil
        
        var pq = [(Int, PathNode)]()
        pq.append((start.distance, start))
        
        while !pq.isEmpty {
            pq.sort { $0.0 < $1.0 }
            let current = pq.removeFirst().1
            if current === end {
                break
            }
            
            if !current.isVisited {
                current.isVisited = true
                for neib: (PathNode, Int) in current.neighbors {
                    let neighbor: PathNode = neib.0
                    let weight: Int = neib.1
                    if !neighbor.isVisited {
                        let newTime: Int = current.distance + weight
                        if newTime < neighbor.distance {
                            neighbor.distance = newTime
                            neighbor.prev = current
                            pq.append((neighbor.distance, neighbor))
                        }
                    }
                }
            }
        }
        
        var current: PathNode? = end
        while let curr = current {
            path.insert(curr, at: 0)
            leveledPath[curr.floor]?.insert(curr, at: 0)
            current = curr.prev
        }
        isWithPath = true
        
    }
    
    public func initializeGraph() {
        // Floor 3
        wholeGraph.addNode("Б_F3N1", 3, PathNode.types.node, 455, 170)
        wholeGraph.addNode("Б-301", 3, PathNode.types.room, 375, 170)
        
        wholeGraph.addNode("Б_F3N2", 3, PathNode.types.node, 455, 530)
        wholeGraph.addNode("Б_F3S1", 3, PathNode.types.stairs, 375, 530) // stairs
        wholeGraph.addNode("Б-302", 3, PathNode.types.room, 535, 530)
        
        wholeGraph.addNode("Б_F3N3", 3, PathNode.types.node, 455, 750)
        wholeGraph.addNode("Б-303", 3, PathNode.types.room, 375, 750)
        
        wholeGraph.addNode("Б_F3N4", 3, PathNode.types.node, 455, 930)
        wholeGraph.addNode("Б_F3S2", 3, PathNode.types.stairs, 535, 930) // stairs
        
        wholeGraph.addNode("Б_F3N5", 3, PathNode.types.node, 455, 1045)
        wholeGraph.addNode("Б-304", 3, PathNode.types.room, 375, 1045)
        
        // Connections
        wholeGraph.connectManyNodes("Б_F3N1", ["Б-301", "Б_F3N2"])
        wholeGraph.connectManyNodes("Б_F3N2", ["Б-302", "Б_F3S1", "Б_F3N3"])
        wholeGraph.connectManyNodes("Б_F3N3", ["Б-303", "Б_F3N3", "Б_F3N4"])
        wholeGraph.connectManyNodes("Б_F3N4", ["Б_F3S2", "Б_F3N5"])
        wholeGraph.connectManyNodes("Б_F3N5", ["Б-304", "Б_F3N4"])
        
        // Floor 4
        wholeGraph.addNode("Б_F4N1", 4, PathNode.types.node, 455, 170)
        wholeGraph.addNode("Б-401", 4, PathNode.types.room, 375, 170)
        
        wholeGraph.addNode("Б_F4N2", 4, PathNode.types.node, 455, 530)
        wholeGraph.addNode("Б-402", 4, PathNode.types.room, 375, 530)
        wholeGraph.addNode("Б_F4S1", 4, PathNode.types.stairs, 535, 530) // stairs
        
        wholeGraph.addNode("Б_F4N3", 4, PathNode.types.node, 455, 810)
        wholeGraph.addNode("Б-403", 4, PathNode.types.room, 375, 810)
        
        wholeGraph.addNode("Б_F4N4", 4, PathNode.types.node, 455, 930)
        wholeGraph.addNode("Б_F4S2", 4, PathNode.types.stairs, 535, 930) // stairs
        
        
        // Connections
        wholeGraph.connectManyNodes("Б_F4N1", ["Б-401", "Б_F4N2"])
        wholeGraph.connectManyNodes("Б_F4N2", ["Б-402", "Б_F4S1", "Б_F4N3"])
        wholeGraph.connectManyNodes("Б_F4N3", ["Б-403", "Б_F4N4"])
        wholeGraph.connectManyNodes("Б_F4N4", ["Б_F4S2"])
        
        
        wholeGraph.connectNodes("Б_F3S1", "Б_F4S1")
        wholeGraph.connectNodes("Б_F4S1", "Б_F3S1")
        
//        wholeGraph.connectNodes("Б_F3S1", "Б_F4S1", false)
//        wholeGraph.connectNodes("Б_F4S1", "Б_F3S1", false)
        
//        // Floor 5
//        wholeGraph.addNode("Б-5_S1", 5, PathNode.types.stairs) // stairs
//        wholeGraph.addNode("Б-502", 5, PathNode.types.room)
//        wholeGraph.addNode("Б-503", 5, PathNode.types.room)
//        wholeGraph.addNode("Б-5_S2", 5, PathNode.types.stairs) // stairs
//        
//        wholeGraph.addNode("Б-6_S1", 6, PathNode.types.stairs) // stairs
//        wholeGraph.addNode("Б-7_S1", 7, PathNode.types.stairs) // stairs
//        wholeGraph.addNode("Б-8_S1", 8, PathNode.types.stairs) // stairs
//        wholeGraph.addNode("Б-9_S1", 9, PathNode.types.stairs) // stairs
//        wholeGraph.addNode("Б-10_S1", 10, PathNode.types.stairs) // stairs
        
        
//        wholeGraph.connectManyNodes("Б-301", [("Б-302", 10), ("Б_F3S2", 70)])
//        wholeGraph.connectManyNodes("Б-302", [("Б_F3S2", 30)])
//        wholeGraph.connectManyNodes("Б_F3S2", [("Б-303", 10)])
//        wholeGraph.connectManyNodes("Б-303", [("Б_F3S2", 10)])
//        
//        wholeGraph.connectManyNodes("Б_F4S1", [("Б-401", 50), ("Б_F4S2", 80)])
//        wholeGraph.connectManyNodes("Б-401", [("Б_F4S2", 40)])
//        wholeGraph.connectManyNodes("Б_F4S2", [("Б-404", 20)])
//        wholeGraph.connectNodes("Б_F3S2", "Б_F4S2", 50, false)
//        wholeGraph.connectNodes("Б_F4S2", "Б_F3S2", 30, false)
//        
//        wholeGraph.connectManyNodes("Б-5_S1", [("Б-502", 20), ("Б-503", 20)])
//        wholeGraph.connectManyNodes("Б-502", [("Б-503", 30)])
//        wholeGraph.connectManyNodes("Б-5_S2", [("Б-503", 40)])
//        wholeGraph.connectNodes("Б_F4S2", "Б-5_S2", 50, false)
//        wholeGraph.connectNodes("Б-5_S2", "Б_F4S2", 30, false)
//        wholeGraph.connectNodes("Б_F4S1", "Б-5_S1", 50, false)
//        wholeGraph.connectNodes("Б-5_S1", "Б_F4S1", 30, false)
//        
//        wholeGraph.connectNodes("Б-5_S1", "Б-6_S1", 50, false)
//        wholeGraph.connectNodes("Б-6_S1", "Б-5_S1", 30, false)
//        
//        wholeGraph.connectNodes("Б-6_S1", "Б-7_S1", 50, false)
//        wholeGraph.connectNodes("Б-7_S1", "Б-6_S1", 30, false)
//        
//        wholeGraph.connectNodes("Б-7_S1", "Б-8_S1", 50, false)
//        wholeGraph.connectNodes("Б-8_S1", "Б-7_S1", 30, false)
//        
//        wholeGraph.connectNodes("Б-8_S1", "Б-9_S1", 50, false)
//        wholeGraph.connectNodes("Б-9_S1", "Б-8_S1", 30, false)
//        
//        wholeGraph.connectNodes("Б-9_S1", "Б-10_S1", 50, false)
//        wholeGraph.connectNodes("Б-10_S1", "Б-9_S1", 30, false)
        
        
        
//        wholeGraph.connectManyNodes("Б-404", [("Б_F4S2", 2)])
        for (name, _) in wholeGraph.nodeMap {
            if wholeGraph.nodeMap[name]?.type == PathNode.types.room {
                self.availablePoints.append(name)
            }
            
        }
//        print(self.availablePoints)

    }
    
    
}
