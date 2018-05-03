//
//  Post.swift
//  danbooruclient
//
//  Created by Keisei Saito on 2018/05/03.
//  Copyright © 2018 Keisei Saito. All rights reserved.
//

import Foundation

struct Post {
	private let previewFileURLString: String
	private let fileURLString: String
	private let sourceString: String
	let pixivID: Int?

	var previewFileURL: URL { return URL(string: previewFileURLString)! }
	var fileURL: URL { return URL(string: fileURLString)! }
	var source: URL { return URL(string: sourceString)! }

	static func decode(from json: AnyObject) -> Post {
		return Post(
			previewFileURLString: json["preview_file_url"] as! String,
			fileURLString: json["file_url"] as! String,
			sourceString: json["source"] as! String,
			pixivID: json["pixiv_id"] as? Int
		)
	}
}
