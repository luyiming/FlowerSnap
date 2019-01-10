//
//  History.swift
//  FlowerSnap
//
//  Created by 陆依鸣 on 2018/11/26.
//  Copyright © 2018 陆依鸣. All rights reserved.
//

import UIKit
import os.log


class History {
    
    // MARK: static methods
    
    static func loadSampleHistorys() -> [HistoryItem] {
        
        let photo1 = UIImage(named: "testImage")!
        let photo2 = UIImage(named: "testImage")!
        let photo3 = UIImage(named: "testImage")!
        
        guard let history1 = HistoryItem(sourceImage: photo1, predictIndex: [1,2,3], predictProbs: [0.3,0.2,0.1]) else {
            fatalError("Unable to instantiate history1")
        }
        
        guard let history2 = HistoryItem(sourceImage: photo2, predictIndex: [4,5], predictProbs: [0.3,0.2]) else {
            fatalError("Unable to instantiate history2")
        }
        
        guard let history3 = HistoryItem(sourceImage: photo3, predictIndex: [6], predictProbs: [0.9]) else {
            fatalError("Unable to instantiate history3")
        }
        
        return [history1, history2, history3]
    }
    
    static func saveHistorys(historys: [HistoryItem]) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: historys, requiringSecureCoding: false)
            try data.write(to: HistoryItem.ArchiveURL)
            os_log("History successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save history...", log: OSLog.default, type: .error)
        }
    }
    
    static func loadHistorys() -> [HistoryItem]?  {
        guard let codedData = try? Data(contentsOf: HistoryItem.ArchiveURL) else { return nil }

        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [HistoryItem]
        
//        return NSKeyedUnarchiver.unarchiveObject(withFile: HistoryItem.ArchiveURL.path) as? [HistoryItem]
    }
}
