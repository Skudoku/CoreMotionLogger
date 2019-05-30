//
//  RecordLog.swift
//  RoutePlotter
//
//  Created by Ties Baltissen on 30/05/2019.
//  Copyright © 2019 RazorBit. All rights reserved.
//

import Foundation

struct RecordLog: Codable {
    
    public let timestamp: String
    public var records: [Record]
    
    
    public mutating func addRecord(_ record: Record) {
        records.append(record)
    }
}
