//
//  GraphModel.swift
//  KNIR
//
//  Created by kirill on 15.05.2024.
//

import Foundation

class Graph {
    var path: [PathNode] = []
    var nodeMap: [String: PathNode] = [:]
    public func calcDst(_ a: String, _ b: String) -> Double {
        let x1: Double = Double(nodeMap[a]!.x)
        let y1: Double = Double(nodeMap[a]!.y)
        let z1: Double = Double(nodeMap[a]!.floor)
        
        let x2: Double = Double(nodeMap[b]!.x)
        let y2: Double = Double(nodeMap[b]!.y)
        let z2: Double = Double(nodeMap[b]!.floor)
        
        let xDiv: Double = abs(x1 - x2) / 40
        let yDiv: Double = abs(y1 - y2) / 40
        let zDiv: Double = abs(z1 - z2) * 3 // 3m hieght
        let dst: Double = pow(pow(xDiv, 3.0) + pow(yDiv, 3.0) + pow(zDiv, 3.0), 1.0/3.0)
        print(dst)
        return dst
    }
    
    public func addNode(_ name: String, _ floor: Int, _ type: PathNode.types, _ x: Int, _ y: Int) {
        self.nodeMap[name] = PathNode(name: name, floor: floor, type: type, x: x, y: y)
    }
    public func connectNodes(_ src: String, _ dst: String, _ isBothSides: Bool = true) {
        let distance: Int = Int(calcDst(src, dst))
        self.nodeMap[src]!.addNeib(self.nodeMap[dst]!, distance)
        if isBothSides { self.nodeMap[dst]!.addNeib(self.nodeMap[src]!, distance) }
    }
    public func connectManyNodes(_ src: String, _ dsts: [String]) {
        for dst in dsts {
            self.connectNodes(src, dst)
        }
    }
}

