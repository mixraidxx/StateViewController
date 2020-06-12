//
//  tableviewStates.swift
//  StateViewController
//
//  Created by Santiago Desarrollo on 12/06/20.
//  Copyright © 2020 Santiago Desarrollo. All rights reserved.
//

enum tableState: CaseIterable {
    case noConnection
    case error
    case empty
    case loading
    case initial
    
    static func random<G: RandomNumberGenerator>(using generator: inout G) -> tableState {
        return tableState.allCases.randomElement(using: &generator)!
    }
    
    static func random() -> tableState {
        var g = SystemRandomNumberGenerator()
        return tableState.random(using: &g)
    }
}
