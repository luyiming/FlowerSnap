//
//  ViewController.swift
//  FlowerSnap
//
//  Created by 陆依鸣 on 2018/11/12.
//  Copyright © 2018 陆依鸣. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    let cnn = DenseNet()
    let classifier = LR()
    
    var pickedImage: UIImage?
    var predictIndex: [Int]?
    var predictProbs: [Double]?
    var resultViewController: ResultViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        imagePicker.delegate = self
        
        
//
//        let mainBundle = Bundle.main
//        let path = mainBundle.path(forResource: "labels", ofType: "json")
//        print(path ?? "NotFound")
//        let jsonData = try! String(contentsOfFile: path!)
//        print(jsonData)
//
//        let json = try? JSONSerialization.jsonObject(with: jsonData.data(using: String.Encoding.utf8)!, options: [])
//
//        if let dictionary = json as? [String: Any] {
//            if let number = dictionary["go"] as? [Int] {
//                print(number)
//            }
//
//            for (key, value) in dictionary {
//                print(key, value)
//            }
//        }
    }
    
    // MARK: - Button Actions
    @IBAction func takePhotoButtonTapped(_ sender: UIButton?) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera not available")
        } else {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func presentResult() {
        if let img = self.pickedImage {
            let (index, probs) = predict(for: img)
            self.predictProbs = probs
            self.predictIndex = index
            
            self.performSegue(withIdentifier: "ShowResultSegue", sender: self)
        }

        //        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
        //            fatalError("Check storyboard for missing ResultViewController")
        //        }
        //
        //        self.resultViewController = viewController
        //        self.resultViewController!.sourceImage = self.sourceImage!
        //
        //        present(self.resultViewController!, animated: true, completion: nil)
    }
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton?) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.pickedImage = img
        }

        dismiss(animated: true, completion: presentResult)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResultSegue" {
            if let resultViewController = segue.destination as? ResultViewController {
                resultViewController.sourceImage = self.pickedImage
                resultViewController.predictIndex = self.predictIndex ?? [Int]()
                resultViewController.predictProbs = self.predictProbs ?? [Double]()
                
                let history = HistoryItem(sourceImage: self.pickedImage!, predictIndex: self.predictIndex ?? [Int](), predictProbs: self.predictProbs ?? [Double]())!
                
                if let savedHistory = History.loadHistorys() {
                    History.saveHistorys(historys: [history] + savedHistory)
                } else {
                    History.saveHistorys(historys: [history])
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func predict(for image: UIImage) -> ([Int], [Double]) {
        let resizedImage = image.resizedImage(to: CGSize(width: 224, height: 224))
        
        guard let feature = try? cnn.prediction(input1: resizedImage.pixelBuffer()!) else {
            fatalError("Unexpected runtime error.")
        }
        
        guard let probs = try? classifier.prediction(input: feature.output1) else {
            fatalError("Unexpected runtime error.")
        }
        
        let sortedResults = probs.classProbability.sorted {
            (pair1, pair2) in pair1.value > pair2.value
        }
        
        for (index, prob) in sortedResults {
            print("\(index2name[Int(index)] ?? "unknown label") \(prob)")
        }

        print(index2name[Int(probs.classLabel)] ?? "unkown label")
        
        let filteredResults = sortedResults.filter { (index, prob) in prob > 0.1 }
        
        let predictIndex = filteredResults.map{ (index, prob) in Int(index) }
        let predictProbs = filteredResults.map{ (index, prob) in prob }
        
        return (predictIndex, predictProbs)
    }
}

extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(to newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func cropToSquare() -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        var imageHeight = self.size.height
        var imageWidth = self.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let x = ((CGFloat(cgImage.width) - size.width) / 2).rounded()
        let y = ((CGFloat(cgImage.height) - size.height) / 2).rounded()
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let croppedCgImage = cgImage.cropping(to: cropRect) {
            return UIImage(cgImage: croppedCgImage, scale: 0, orientation: self.imageOrientation)
        }
        
        return nil
    }
    
    func pixelBuffer() -> CVPixelBuffer? {
        let width = self.size.width
        let height = self.size.height
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs,
                                         &pixelBuffer)
        
        guard let resultPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(resultPixelBuffer)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(resultPixelBuffer),
                                      space: rgbColorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
                                        return nil
        }
        
        context.translateBy(x: 0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return resultPixelBuffer
    }
}

