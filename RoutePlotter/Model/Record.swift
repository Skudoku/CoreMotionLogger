//
//  Record.swift
//  RoutePlotter
//
//  Created by Ties Baltissen on 28/05/2019.
//  Copyright © 2019 RazorBit. All rights reserved.
//

import Foundation

struct Record: Codable {
    
    public let timestamp: String
    public let numberOfSteps: Int?
    public let distance: Int?
    public let currentPace: Int?
    public let currentCadence: Int?
    public let averageActivePace: Int?
    public let acceleration: Acceleration
    public let userAcceleration: Acceleration
    public let attitudeQuaternion: Quaternion
    public let heading: Float
}

struct Quaternion: Codable {
    public let x: Int
    public let y: Int
    public let z: Int
    public let w: Int
}

struct Acceleration: Codable {
    public let x: Int
    public let y: Int
    public let z: Int
}
