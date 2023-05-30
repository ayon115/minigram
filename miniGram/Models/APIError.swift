//
//  APIError.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 30/5/23.
//

import Foundation

struct APIError: Codable {
    var status: Int?
    var name: String?
    var message: String?
}
