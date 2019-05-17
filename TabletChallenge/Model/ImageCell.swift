//
//  ImageCell.swift
//  TabletChallenge
//
//  Created by Felix Changoo on 4/9/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit
import Kingfisher

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    func configure(with nasaImg: NasaImage) {
        if let url = URL(string: nasaImg.imageThumbURL) {
            imgView.kf.setImage(with: url)
        }
    }
}
