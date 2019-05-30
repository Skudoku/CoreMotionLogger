//
//  HistoryViewController.swift
//  RoutePlotter
//
//  Created by Ties Baltissen on 30/05/2019.
//  Copyright © 2019 RazorBit. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var historyTableView: UITableView!
    
    var selectedIndex = -1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyTableView.reloadData()
        historyTableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return RecordHistoryRepository.shared.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCellIdentifier", for: indexPath) as? HistoryTableViewCell else {
            fatalError("Cell type must be type of HistoryTableViewCell")
        }
        
        cell.setup(with: RecordHistoryRepository.shared.entries[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "showLog", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLog" {
            if let destination = segue.destination as? RecordLogDetailViewController {
                destination.log = RecordHistoryRepository.shared.entries[selectedIndex]
            }
        }
    }
    
}
