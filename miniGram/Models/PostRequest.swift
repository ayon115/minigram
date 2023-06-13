//
//  PostRequest.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 13/6/23.
//

import Foundation

class PostRequest: Encodable {
    var data: PostData?
}

class PostData: Encodable {
    var content: String?
    var author: Int?
}
