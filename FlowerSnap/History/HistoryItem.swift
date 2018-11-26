//
//  HistoryItem.swift
//  FlowerSnap
//
//  Created by 陆依鸣 on 2018/11/26.
//  Copyright © 2018 陆依鸣. All rights reserved.
//

import UIKit
import os.log


class HistoryItem: NSObject, NSCoding {
    
    // MARK: Properties
    var sourceImage: UIImage
    var title: String
    var predictIndex: [Int]
    var predictProbs: [Double]
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("historys")
    
    // MARK: Types
    struct PropertyKey {
        static let sourceImage = "sourceImage"
        static let title = "title"
        static let predictIndex = "predictIndex"
        static let predictProbs = "predictProbs"
    }
    
    // MARK: Initialization
    init?(sourceImage: UIImage, predictIndex: [Int], predictProbs: [Double]) {
        
        guard predictIndex.count == predictProbs.count else {
            return nil
        }
       
        // Initialize stored properties.
        self.sourceImage = sourceImage
        self.predictIndex = predictIndex
        self.predictProbs = predictProbs
        
        if predictIndex.count == 0 {
            self.title = "Unknown"
        } else {
            self.title = index2chn[predictIndex[0]]! + "(" + index2name[predictIndex[0]]! + ")"
        }
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.sourceImage, forKey: PropertyKey.sourceImage)
        aCoder.encode(self.predictIndex, forKey: PropertyKey.predictIndex)
        aCoder.encode(self.predictProbs, forKey: PropertyKey.predictProbs)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let sourceImage = aDecoder.decodeObject(forKey: PropertyKey.sourceImage) as! UIImage
        let predictIndex = aDecoder.decodeObject(forKey: PropertyKey.predictIndex) as! [Int]
        let predictProbs = aDecoder.decodeObject(forKey: PropertyKey.predictProbs) as! [Double]
        
        // Must call designated initializer.
        self.init(sourceImage: sourceImage, predictIndex: predictIndex, predictProbs: predictProbs)
    }
}
