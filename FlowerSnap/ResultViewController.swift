//
//  ResultViewController.swift
//  FlowerSnap
//
//  Created by 陆依鸣 on 2018/11/16.
//  Copyright © 2018 陆依鸣. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageControl = UIPageControl()
    
    var predictIndex: [Int] = [0, 3]
    var predictProbs: [Double] = [0.813, 0.187]
    var sourceImage: UIImage? = index2image[0]
    
    @IBOutlet weak var sourceImageView: UIImageView!
    
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
        } else {
            subResultView.labelName = index2label[self.predictIndex[index]]
            subResultView.prob = self.predictProbs[index]
            subResultView.thumbnailImage = index2image[self.predictIndex[index]]
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
