//
//  ResultViewController.swift
//  FlowerSnap
//
//  Created by 陆依鸣 on 2018/11/16.
//  Copyright © 2018 陆依鸣. All rights reserved.
//

import UIKit
import CoreLocation

class ResultViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageControl = UIPageControl()
    
    var predictIndex =  [Int]()
    var predictProbs = [Double]()
    var sourceImage = index2image[0]
    
    var isSharing = false
    
    @IBOutlet weak var sourceImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceImageView.image = sourceImage
        
        // print(children)
        guard let pageViewController = children.first as? UIPageViewController else  {
            fatalError("Check storyboard for missing UIPageViewController")
        }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers([createSubResultViewController(index: 0)], direction: .forward, animated: true, completion: nil)
        
        configurePageControl()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(ResultViewController.shareResultAction))
        
        locationManager.delegate = self
    }
    
    @objc func shareResultAction() {
        isSharing = true
        getCurrentLocationAndShare()
        print("share!")
    }
    
    func createSubResultViewController(index: Int) -> SubResultViewController {
        guard let subResultView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubResultViewController") as? SubResultViewController else {
            fatalError("Check storyboard for missing SubResultViewController")
        }
        
        if index == self.predictIndex.count {
            // the last view is unknown result
            subResultView.labelName = nil
            subResultView.prob = nil
            subResultView.thumbnailImage = UIImage(named: "unknown")
            subResultView.predictIndex = nil
        } else {
            let t = self.predictIndex[index]
            subResultView.labelName = index2chn[t]! + "(" + index2name[t]! + ")"
            subResultView.prob = self.predictProbs[index]
            subResultView.thumbnailImage = index2image[self.predictIndex[index]]
            subResultView.predictIndex = t
        }
        
        subResultView.pageIndex = index
        
        return subResultView
    }
    
    // MARK: custom page indicator
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0] as! SubResultViewController
        self.pageControl.currentPage = pageContentViewController.pageIndex
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        self.pageControl.numberOfPages = self.predictIndex.count + 1
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.cyan
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    // MARK: Page View Controller Data Source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let subResultViewController = viewController as? SubResultViewController else {
            fatalError("viewController is not SubResultViewController")
        }
        
        let index = subResultViewController.pageIndex
        
        if index == 0 {
            return nil;
        }
        
        return createSubResultViewController(index: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let subResultViewController = viewController as? SubResultViewController else {
            fatalError("viewController is not SubResultViewController")
        }
        
        let index = subResultViewController.pageIndex
        
        if index == self.predictIndex.count {
            return nil;
        }
        
        return createSubResultViewController(index: index + 1)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.predictIndex.count + 1
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
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

extension ResultViewController: CLLocationManagerDelegate {
    
    func getCurrentLocationAndShare() {
        if ( CLLocationManager.authorizationStatus() == .notDetermined) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            
            let alertController = UIAlertController(title: "Locating Denied", message: "You did not grant the locating permission for this app.", preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            return
        }
    }
    
    func sendData(latitude: Double, longitude: Double) {
        
        guard let image = sourceImage else { return }
        
        guard let base64data = image.pngData()?.base64EncodedString() else { return }
        
        var flowerName = "Unknown"
        if predictIndex.count != 0 {
            flowerName = index2chn[predictIndex[0]]! + "(" + index2name[predictIndex[0]]! + ")"
        }
        
        // prepare json data
        let json: [String: Any] = [
            "name": flowerName,
            "latitude": latitude,
            "longitude": longitude,
            "sourceImage": base64data,
            "predictIndex": predictIndex,
            "predictProbs": predictProbs
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        var request = URLRequest(url: URL(string: "http://127.0.0.1:5000/share")!)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        // HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print("upload success")
            
            let alertController = UIAlertController(title: "上传成功", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil))

            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
            
            
//            print(data)
//            print(String.init(data: data, encoding: String.Encoding.utf8) ?? "")

            //create json object from data
            //            guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            //                completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
            //                return
            //            }
            //            print(json)
        }
        
        task.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if isSharing == false {
            return
        }
        
        if let coordinate = locations.first?.coordinate {
            print(coordinate)
            isSharing = false
            
            let alertController = UIAlertController(title: "分享", message: "是否分享图片？", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "确定", style: .default) { (_: UIAlertAction) in
                print("确定")
                
                self.sendData(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_: UIAlertAction) in
                print("取消")
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            locationManager.stopUpdatingLocation()
        } else {
            print("no location")
        }
        
    }
    
}
