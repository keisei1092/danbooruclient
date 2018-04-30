//
//  Extensions.swift
//  danbooruclient
//
//  Created by Keisei Saito on 2018/04/30.
//  Copyright © 2018 Keisei Saito. All rights reserved.
//

import UIKit

class ImageDownloader {

	static let shared = ImageDownloader()

	func get(dataFrom url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
			completion(data, response, error)
		}).resume()
	}

}

extension UIImageView {

	func download(imageFrom url: URL) {
		ImageDownloader.shared.get(dataFrom: url) { data, response, error in
			guard let data = data, error == nil else { return }

			DispatchQueue.main.async() {
				self.image = UIImage(data: data)
			}
		}
	}

}
