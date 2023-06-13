//
//  HomeController.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 7/5/23.
//

import UIKit
import Alamofire
import Kingfisher

class HomeController: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
   
    let feedViewModel = FeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeTableView.dataSource = self
        self.homeTableView.delegate = self
        
        self.homeTableView.estimatedRowHeight = 350.0
        self.homeTableView.rowHeight = UITableView.automaticDimension
        
        /*
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        button.titleLabel?.textColor = UIColor.red
       // button.tintColor = UIColor(named: "appAccent")
        button.setTitle("Create Post", for: .normal)
         */
       // let createButton = UIBarButtonItem(customView: button)
        let createButton = UIBarButtonItem(title: "Create Post") {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: MinigramApp.createPostController) as? CreatePostController {
                controller.navBarTitle = "Create New Post"
                controller.createPostDelegate = self
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        self.navigationItem.rightBarButtonItem = createButton
        
        /*
        button.addControlEvent(.touchUpInside) {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: MinigramApp.createPostController) as? CreatePostController {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }*/
        self.getPostsFromAPI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newPostCreated), name: .newPostCreated, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("HomeController viewWillDisappear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("HomeController viewWillAppear")
    }
    
    @objc func newPostCreated () {
        print("HomeController newPostCreated Notification Received.")
        self.getPostsFromAPI()
    }
    

    // what happens when a row is clicked
}

extension HomeController: CreatePostProtocol {
    func reloadAllPosts() {
        print("HomeController reloadAllPosts")
        self.getPostsFromAPI()
    }
}

extension HomeController: UITableViewDataSource {
    
    // how many sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // how many rows in a particular section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedViewModel.feedSize
    }
    
    // how does each row look like
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("section = \(indexPath.section)")
        print("row = \(indexPath.row)")
        
        var feedCell: FeedCell
        
        if let mFeedCell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseIdentifier) as? FeedCell {
            feedCell = mFeedCell
        } else {
            let feedCellFromBundle = Bundle.main.loadNibNamed(FeedCell.reuseIdentifier, owner: self)?.first as! FeedCell
            feedCell = feedCellFromBundle
        }
        
        let feedData = self.feedViewModel.feedDataAtRow(row: indexPath.row)
        if let url = URL(string: feedData.userPhotoUrl) {
            print("authorPhotoUrl = \(url)")
            feedCell.userPhotoImageView.kf.setImage(with: url)
        }
        feedCell.userNameLabel.text = feedData.username
        // feedCell.contentImageView.image = feedData.contentImage
        if let url = URL(string: feedData.contentImageUrl) {
            feedCell.contentImageView.kf.setImage(with: url)
        } else {
            feedCell.contentImageView.image = UIImage(named: "placeholder")!
        }
        feedCell.contentTextLabel.text = feedData.contentText
        
        feedCell.userPhotoImageView.makeImageViewRounded()
        
        return feedCell
    }
}

extension HomeController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowDescription = "section = \(indexPath.section), row = \(indexPath.row)"
        let alertController = UIAlertController(title: "Table Row Clicked", message: rowDescription, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true)
    }
    
}

extension HomeController {
    
    func getPostsFromAPI () {
        print("getPostsFromAPI")
      /*  AF.request(MinigramApp.apiBaseUrl + "/api/posts?populate=*").response { response in
            debugPrint(response)
        } */
        let url = MinigramApp.apiBaseUrl + "/api/posts?populate=author,author.profilePhoto,imageContent"
        let parameters: [String: Any] = [:]
        let headers: HTTPHeaders = [
            "Authorization": MinigramApp.authorizationHeader
        ]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).responseDecodable(of: PostResponse.self) { response in
            debugPrint(response)
            
            switch (response.result) {
                    case .success:
                        print("Validation Successful")
                        self.parsePostResponse(value: response.value)
                    case let .failure(error):
                        print(error)
            }
            
        }
    }
    
    func parsePostResponse (value: PostResponse?) {
        self.feedViewModel.dataSet = []
        if let postResponse = value {
            if let data = postResponse.data {
                for item in data {
                    if let content = item.attributes?.content {
                        print(content)
                        var authorUsername = ""
                        if let authorName = item.attributes?.author?.data?.attributes?.username {
                            authorUsername = authorName
                        }
                        var contentUrl = ""
                        if let url = item.attributes?.imageContent?.data?.attributes?.url {
                            contentUrl = MinigramApp.apiBaseUrl + url
                        }
                        
                        var authorPhotoUrl = ""
                        if let url = item.attributes?.author?.data?.attributes?.profilePhoto?.data?.attributes?.url {
                            authorPhotoUrl = MinigramApp.apiBaseUrl + url
                        }
                        
                        let postData = FeedModel(username: authorUsername, userPhotoUrl: authorPhotoUrl, contentImageUrl: contentUrl, contentText: content)
                        self.feedViewModel.dataSet.append(postData)
                    }
                }
            }
        }
        self.homeTableView.reloadData()
    }
    
    // Assignment Class 11
    // Refactor this code and take it to View Model class, do all the processing in the view model class
    // See SwiftyJSON for alternate JSON Parsing
    
    // Assignment Class 13 - Implement Load more
}
