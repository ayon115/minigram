/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct User : Codable {
	let id : Int?
	let username : String?
	let email : String?
	let provider : String?
	let confirmed : Bool?
	let blocked : Bool?
	let createdAt : String?
	let updatedAt : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case username = "username"
		case email = "email"
		case provider = "provider"
		case confirmed = "confirmed"
		case blocked = "blocked"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		provider = try values.decodeIfPresent(String.self, forKey: .provider)
		confirmed = try values.decodeIfPresent(Bool.self, forKey: .confirmed)
		blocked = try values.decodeIfPresent(Bool.self, forKey: .blocked)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
	}

}