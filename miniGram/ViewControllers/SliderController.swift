//
//  SliderController.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 10/6/23.
//

import UIKit

class SliderController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var pageController: UIPageViewController?
    var pages: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        let page1 = Page(title: "Slide 01", description: "Let’s see what the method does. We first create the UIPageViewController object and specify the navigation style, as well as, the navigation orientation.", image: UIImage(named: "content1")!, index: 0)
        let page2 = Page(title: "Slide 02", description: "UIPageViewControllerNavigationOrientationHorizontal as orientation. Please note that the transition using dots is only available if we use an horizontal orientation and a scroll style.", image: UIImage(named: "content2")!, index: 1)
        let page3 = Page(title: "Slide 03", description: "Next we specify the data source, in this case it is the class itself.", image: UIImage(named: "content3")!, index: 2)
        
        
        let contentController01 = self.storyboard?.instantiateViewController(withIdentifier: MinigramApp.pageContentController) as! PageContentController
        contentController01.page = page1
        
        let contentController02 = self.storyboard?.instantiateViewController(withIdentifier: MinigramApp.pageContentController) as! PageContentController
        contentController02.page = page2
        
        let contentController03 = self.storyboard?.instantiateViewController(withIdentifier: MinigramApp.pageContentController) as! PageContentController
        contentController03.page = page3
        
        self.pages = [contentController01, contentController02, contentController03]
        self.pageController?.setViewControllers([contentController01], direction: .forward, animated: true)
        
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
    
        let pageControlAppearence = UIPageControl.appearance()
        pageControlAppearence.currentPageIndicatorTintColor = UIColor(named: "appAccent")!
        pageControlAppearence.pageIndicatorTintColor = UIColor(named: "appAccent")!.withAlphaComponent(0.3)
    
        
        if let pc = self.pageController {
            self.addChild(pc)
            self.containerView.addSubview(pc.view)
            pc.view.frame = self.containerView.bounds
            pc.didMove(toParent: self)
        }
        
        self.skipButton.addControlEvent(.touchUpInside) {
            if let loginNavigationController = self.storyboard?.instantiateViewController(withIdentifier: MinigramApp.loginNavigationController) as? UINavigationController {
               // self.present(loginNavigationController, animated: true)
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let sceneDelegate = windowScene.delegate as? SceneDelegate {
                        sceneDelegate.window?.rootViewController = loginNavigationController
                    }
                }
            }
        }
    }

}

extension SliderController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
      
        if let controller = viewController as? PageContentController, let index = controller.page?.index {
            if index == 0 {
                return nil
            }
            return self.pages[index - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let controller = viewController as? PageContentController, let index = controller.page?.index {
            if index == self.pages.count - 1 {
                return nil
            }
            return self.pages[index + 1]
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

struct Page {
    let title: String
    let description: String
    let image: UIImage
    let index: Int
    
    init(title: String, description: String, image: UIImage, index: Int) {
        self.title = title
        self.description = description
        self.image = image
        self.index = index
    }
}
