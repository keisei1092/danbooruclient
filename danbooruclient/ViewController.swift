//
//  ViewController.swift
//  danbooruclient
//
//  Created by Keisei Saito on 2018/04/30.
//  Copyright © 2018 Keisei Saito. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {

	var page = 1

	var urls: [[String: URL]] = [] {
		didSet {
			collectionView?.reloadData()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(loadNext))

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
					self?.urls = result.map {
						[
							"preview_file_url": URL(string: $0["preview_file_url"] as! String)!,
							"file_url": URL(string: $0["file_url"] as! String)!
						]
					}
				}
			} catch {
				print("JSON parse error")
			}
		}).resume()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard
			let cell = sender as? UICollectionViewCell,
			let indexPath = collectionView?.indexPath(for: cell)
		else { return }

		let vc = segue.destination as! SecondViewController
		vc.url = urls[indexPath.row]["file_url"]
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return urls.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
		cell.imageView.download(imageFrom: urls[indexPath.row]["preview_file_url"]!)
		return cell
	}

	@objc private func loadNext() {
		page += 1

		var request = URLRequest(url: URL(string: "https://danbooru.donmai.us/posts.json?tags=hatsune_miku&page=\(page)")!)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response, error in
			guard let data = data else { return }

			do {
				let result = try JSONSerialization.jsonObject(with: data, options: []) as! [AnyObject]

				DispatchQueue.main.async {
					self?.urls += result.map {
						[
							"preview_file_url": URL(string: $0["preview_file_url"] as! String)!,
							"file_url": URL(string: $0["file_url"] as! String)!
						]
					}
				}
			} catch {
				print("JSON parse error")
			}
		}).resume()
	}

}

