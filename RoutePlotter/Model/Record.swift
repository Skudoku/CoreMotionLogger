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
    public let distance: Float?
    public let currentPace: Float?
    public let currentCadence: Float?
    public let averageActivePace: Float?
    public let acceleration: Acceleration
    public let userAcceleration: Acceleration
    public let attitudeQuaternion: Quaternion
    public let heading: Float
}

struct Quaternion: Codable {
    public let x: Float
    public let y: Float
    public let z: Float
    public let w: Float
}

struct Acceleration: Codable {
    public let x: Float
    public let y: Float
    public let z: Float
}
