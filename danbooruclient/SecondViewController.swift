//
//  SecondViewController.swift
//  danbooruclient
//
//  Created by Keisei Saito on 2018/04/30.
//  Copyright © 2018 Keisei Saito. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

	var url: URL?

	@IBOutlet weak var imageView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.imageView.download(imageFrom: url!)
	}

}
