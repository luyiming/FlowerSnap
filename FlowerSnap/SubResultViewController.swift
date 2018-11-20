//
//  SubResultViewController.swift
//  FlowerSnap
//
//  Created by 陆依鸣 on 2018/11/16.
//  Copyright © 2018 陆依鸣. All rights reserved.
//

import UIKit

class SubResultViewController: UIViewController {

    var labelName: String?
    var prob: Double?
    var thumbnailImage: UIImage?
    
    @IBOutlet weak var predictLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var probLabel: UILabel!
    
    var pageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if labelName == nil {
            // the unkown page
            predictLabel.text = "^_^"
            probLabel.text = nil
        } else {
            predictLabel.text = labelName
            probLabel.text =  String(format:"%f", prob!)
        }
        
        imageView.image = thumbnailImage

        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true

        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.white.cgColor
//        
//        imageView.layer.shadowColor = UIColor.black.cgColor
//        imageView.layer.shadowRadius = 5.0
//        imageView.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
//        imageView.layer.shadowOpacity = 1.0
    }
    
    @IBAction func startAgain(_ sender: UIButton) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
