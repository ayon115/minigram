//
//  ProfileController.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 7/5/23.
//

import UIKit
import ActionKit

class ProfileController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImageView.image = profileViewModel.profilePhoto
        self.profileImageView.makeImageViewRounded()
        
        self.followButton.addCornerToView(radius: 5.0)
        
        // Do any additional setup after loading the view.
        
        self.segmentedControl.addControlEvent(.valueChanged) {
            print("currently selected segment index = \(self.segmentedControl.selectedSegmentIndex)")
        }
        
        self.mCollectionView.dataSource = self
        self.mCollectionView.delegate = self
        
        self.mCollectionView.setCollectionViewLayout(UICollectionViewFlowLayout.init(), animated: true)
        let postNib = UINib(nibName: PostCell.reuseIdentifier, bundle: nil)
        self.mCollectionView.register(postNib, forCellWithReuseIdentifier: PostCell.reuseIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(newPostCreated), name: .newPostCreated, object: nil)
        
        
    }
    
    @objc func newPostCreated () {
        print("ProfileController newPostCreated Notification Received.")
    }
    
    // task - write a function that changes selected segment title color to white
    // 3 posts in each row, uniform spacing, post image will be square
    // when segmented control is selected to 0, then show all posts from dataSet, if second segment is selected then show posts from datasetTagged
    
}

extension ProfileController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileViewModel.numberOfPosts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseIdentifier, for: indexPath) as! PostCell
        let post = self.profileViewModel.postAtRow(itemIndex: indexPath.item)
       // cell.contentImageView.image = post.contentImage
        
        return cell
    }
}

extension ProfileController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post = self.profileViewModel.postAtRow(itemIndex: indexPath.item)
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: MinigramApp.PostController) as? PostController {
            controller.post = post
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return sizeForItem()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    
}

extension ProfileController {
    
    func sizeForItem () -> CGSize {
        let screenWidth = self.view.frame.width
        let spacingBetweenItems = 10.0
        let spacingAtEdges = 10.0
        let numberOfItemsInEachRow = 3
        
        let totalSpacing = (spacingAtEdges * 2) + (Double((numberOfItemsInEachRow - 1)) * spacingBetweenItems)
        let itemWidth = (screenWidth - totalSpacing) / 3
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
