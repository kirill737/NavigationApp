//
//  PathNodeModel.swift
//  KNIR
//
//  Created by kirill on 15.05.2024.
//

import Foundation

class PathNode {
    var name: String
    var floor: Int
    var x: Int
    var y: Int
    var type: types
    var isDestinationPoint: Bool
    
    var distance: Int
    var prev: PathNode?
    var isVisited: Bool
    var neighbors: [(PathNode, Int)]
    
    enum types {
        case stairs
        case node
        case room
    }
    
    init(name: String, floor: Int, type: types, x: Int, y: Int) {
        self.name = name
        self.floor = floor
        self.x = x
        self.y = y
        self.type = type
        if self.type == types.room {
            isDestinationPoint = true
        } else {
            self.isDestinationPoint = false
        }
        
        self.distance = Int.max
        self.prev = nil
        self.isVisited = false
        self.neighbors = []
    }
    
//    func avgDistance() -> Int {
//        print(distance)
//        return Int(Double(distance) / 1.3)
//    }
    
    func resetNode() -> Void {
        self.distance = Int.max
        self.prev = nil
        self.isVisited = false
    }
    
    func addNeibs(_ neibs: [(PathNode, Int)]) -> Void {
        self.neighbors.append(contentsOf: neibs)
    }
    
    func addNeib(_ neib: PathNode, _ distance: Int) -> Void {
        self.neighbors.append((neib, distance))
    }
}
