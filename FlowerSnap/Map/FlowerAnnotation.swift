//
//  FlowerAnnotation.swift
//  FlowerSnap
//
//  Created by 陆依鸣 on 2019/1/10.
//  Copyright © 2019 陆依鸣. All rights reserved.
//

import UIKit
import MapKit


class FlowerAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image_index: String?
    var predictIndex: [Int]?
    var predictProbs: [Double]?
    
    init(coordinate: CLLocationCoordinate2D, name: String, date: String, image_index: String, predictIndex: [Int], predictProbs: [Double]) {
        self.coordinate = coordinate
        self.title = name
        self.subtitle = date
        self.image_index = image_index
        self.predictIndex = predictIndex
        self.predictProbs = predictProbs
    }
}
