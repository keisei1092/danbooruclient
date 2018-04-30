//
//  ViewController.swift
//  danbooruclient
//
//  Created by Keisei Saito on 2018/04/30.
//  Copyright © 2018 Keisei Saito. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var urls: [String] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		var request = URLRequest(url: URL(string: "https://danbooru.donmai.us/posts.json?tags=hatsune_miku")!)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response, error in
			guard let data = data else { return }

			do {
				let result = try JSONSerialization.jsonObject(with: data, options: []) as! [AnyObject]
				self?.urls = result.map { $0["file_url"] as! String }
				print(result)
			} catch {
				print("JSON parse error")
			}
		}).resume()
	}

}

