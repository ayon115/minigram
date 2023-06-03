//
//  Post.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 27/5/23.
//

import Foundation

struct Post : Decodable {
    var id: Int?
    var attributes: Attribute?
}

struct Attribute: Decodable {
    var content: String?
    var author: AuthorData?
    var imageContent: ImageContent?
}

struct AuthorData: Decodable {
    var data: Author?
}

struct Author: Decodable {
    var id: Int?
    var attributes: AuthorAttribute?
    
}

struct AuthorAttribute: Decodable {
    var username: String?
    var profilePhoto: ImageContent?
}

struct PostImageAttribute: Decodable {
    var url: String?
}

struct ImageContent: Decodable {
    var data: ImageContentData?
}

struct ImageContentData: Decodable {
    var attributes: PostImageAttribute?
}
