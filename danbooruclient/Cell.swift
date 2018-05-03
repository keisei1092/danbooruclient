//
//  Cell.swift
//  danbooruclient
//
//  Created by Keisei Saito on 2018/04/30.
//  Copyright © 2018 Keisei Saito. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
	
	@IBOutlet weak var imageView: UIImageView!

	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
	}

}
