//
//  SecondViewController.swift
//  danbooruclient
//
//  Created by Keisei Saito on 2018/04/30.
//  Copyright © 2018 Keisei Saito. All rights reserved.
//

import UIKit
import SafariServices

class SecondViewController: UIViewController, UIScrollViewDelegate {

	var post: Post?

	var imageView = UIImageView(frame: UIScreen.main.bounds)
	@IBOutlet weak var scrollView: UIScrollView!

	override func viewDidLoad() {
		super.viewDidLoad()
		guard let post = post else { return }
		print(post)

		navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveDidTap))]

		if post.source.absoluteString.contains(find: "twitter.com") {
			navigationItem.rightBarButtonItems! += [UIBarButtonItem(title: "Twitter", style: .plain, target: self, action: #selector(twitterDidTap))]
		} else if post.pixivID != nil {
			navigationItem.rightBarButtonItems! += [UIBarButtonItem(title: "pixiv", style: .plain, target: self, action: #selector(pixivDidTap))]
		}

		imageView.download(imageFrom: post.fileURL)
		imageView.contentMode = .scaleAspectFit
		scrollView.addSubview(imageView)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		if let size = imageView.image?.size {
			let wrate = scrollView.frame.width / size.width
			let hrate = scrollView.frame.height / size.height
			let rate = min(wrate, hrate, 1)
			imageView.frame.size = CGSize(width: size.width * rate, height: size.height * rate)

			scrollView.contentSize = imageView.frame.size

			updateScrollInset()
		}
	}

	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}

	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		updateScrollInset()
	}

	private func updateScrollInset() {
		scrollView.contentInset = UIEdgeInsetsMake(
			max((scrollView.frame.height - imageView.frame.height) / 2, 0),
			max((scrollView.frame.width - imageView.frame.width) / 2, 0),
			0,
			0
		);
	}

	@objc func saveDidTap() {
		UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
	}

	@objc func twitterDidTap() {
		let vc = SFSafariViewController(url: post!.source)
		present(vc, animated: true)
	}

	@objc func pixivDidTap() {
		let url = URL(string: "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=\(post!.pixivID!)")!
		let vc = SFSafariViewController(url: url)
		present(vc, animated: true)
	}

	@IBAction func doubleTapDidFire(_ sender: UITapGestureRecognizer) {
		if scrollView.zoomScale == 1 {
			scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
		} else {
			scrollView.setZoomScale(1, animated: true)
		}
	}

	private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
		var zoomRect = CGRect.zero
		zoomRect.size.height = imageView.frame.size.height / scale
		zoomRect.size.width  = imageView.frame.size.width  / scale
		let newCenter = scrollView.convert(center, from: imageView)
		zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
		zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
		return zoomRect
	}

}
