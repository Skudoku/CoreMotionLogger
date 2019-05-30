//
//  RecordHistoryRepository.swift
//  RoutePlotter
//
//  Created by Ties Baltissen on 30/05/2019.
//  Copyright © 2019 RazorBit. All rights reserved.
//

import Foundation

class RecordHistoryRepository {
    
    static let shared = RecordHistoryRepository()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public init() {
        do {
            let data = try Data(contentsOf: fileURL)
            guard let entries = try? decoder.decode([RecordLog].self, from: data) else { return }
            self.entries = entries
        } catch {
            print("error===", error)
        }
    }
    
    public var entries = [RecordLog]() {
        didSet {
            guard let data = try? encoder.encode(entries) else { return }
            do {
                try data.write(to: fileURL)
            } catch {
                print("===error", error)
            }
        }
    }
    
    private let fileURL: URL = {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
            else { fatalError("no directory") }
        let file = "history.txt"
        let url =  dir.appendingPathComponent(file)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try Data().write(to: url)
            } catch {
                print("error", error)
            }
        }
        return url
    }()
    
    public func addLog(_ log: RecordLog) {
        entries.insert(log, at: 0)
    }
    
    public func clear() {
        entries.removeAll()
    }
    
}

