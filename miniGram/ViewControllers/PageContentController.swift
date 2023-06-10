//
//  PageContentController.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 10/6/23.
//

import UIKit

class PageContentController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var slideImage: UIImageView!
    
    var page: Page?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = page?.title
        self.descriptionLabel.text = page?.description
        self.slideImage.image = page?.image
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
