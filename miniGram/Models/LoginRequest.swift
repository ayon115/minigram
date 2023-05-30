//
//  LoginRequest.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 30/5/23.
//

import Foundation

struct LoginRequest: Codable {
    let identifier: String
    let password: String
}
