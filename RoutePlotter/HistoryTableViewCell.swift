//
//  HistoryTableViewCell.swift
//  RoutePlotter
//
//  Created by Ties Baltissen on 30/05/2019.
//  Copyright © 2019 RazorBit. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var historyStampLabel: UILabel!
    
    var record: RecordLog!
    
    func setup(with history: RecordLog) {
        record = history
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        historyStampLabel.text = "\(dateFormatter.string(from:record.timestamp)) entries: \(record.records.count)"
    }
    
}
