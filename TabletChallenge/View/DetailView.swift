//
//  DetailView.swift
//  TabletChallenge
//
//  Created by Felix Changoo on 4/9/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit
import Kingfisher

class DetailView: UIViewController {
    var image: NasaImage?
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var photographerLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    func setupView() {
        if let image = image {
            titleLbl.text = image.title
            descLbl.text = "Description: \(image.description)"
            photographerLbl.text = "By: \(image.creator ?? "n/a")"
            locationLbl.text = "Location: \(image.location ?? "n/a")"
            
            if let url = URL(string: image.imageThumbURL) {
                imgView.kf.setImage(with: url)
            }
        }
    }
    
}
