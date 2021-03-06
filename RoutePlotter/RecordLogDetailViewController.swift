//
//  RecordLogDetailViewController.swift
//  RoutePlotter
//
//  Created by Ties Baltissen on 30/05/2019.
//  Copyright © 2019 RazorBit. All rights reserved.
//

import UIKit

class RecordLogDetailViewController: UIViewController {
    
    @IBOutlet weak var logTextView: UITextView!
    
    var log: RecordLog?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let log = log {
            self.title = log.timestamp
        }
        prettyPrintLog()
    }
    
    func prettyPrintLog() {
        guard let log = log else { return }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try encoder.encode(log)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                self.logTextView.text = jsonString
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func copyToClipboardTapped(_ sender: Any) {
        UIPasteboard.general.string = self.logTextView.text
    }
    
    @IBAction func goToOnlineConverterTapped(_ sender: Any) {
        if let url = URL(string:"http://convertcsv.com/json-to-csv.htm") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
    }
    
    
}
