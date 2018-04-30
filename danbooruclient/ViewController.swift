//
//  ViewController.swift
//  danbooruclient
//
//  Created by Keisei Saito on 2018/04/30.
//  Copyright © 2018 Keisei Saito. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {

	var urls: [String] = [] {
		didSet {
			collectionView?.reloadData()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let itemSize = CGSize(width: UIScreen.main.bounds.width / 4 - 2, height: UIScreen.main.bounds.width / 4 - 2)
		let collectionViewLayout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
		collectionViewLayout.itemSize = itemSize
		collectionViewLayout.minimumInteritemSpacing = 2
		collectionViewLayout.minimumLineSpacing = 2

		var request = URLRequest(url: URL(string: "https://danbooru.donmai.us/posts.json?tags=hatsune_miku")!)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response, error in
			guard let data = data else { return }

			do {
				let result = try JSONSerialization.jsonObject(with: data, options: []) as! [AnyObject]

				DispatchQueue.main.async {
					self?.urls = result.map { $0["preview_file_url"] as! String }
				}
			} catch {
				print("JSON parse error")
			}
		}).resume()
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return urls.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
		cell.imageView.download(imageFrom: URL(string: urls[indexPath.row])!)
		return cell
	}

}

