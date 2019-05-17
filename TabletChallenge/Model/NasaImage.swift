//
//  NasaImage.swift
//  TabletChallenge
//
//  Created by Felix Changoo on 4/8/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import Foundation

struct NasaImage {
    var imageThumbURL: String
    var imageLinksURL: String
    var title: String
    var description: String
    var photographer: String?
    var location: String?
    var creator: String?
    
    init?(with json: [String: Any]) {
        guard let dict = json["data"] as? [[String: Any]] else {
            return nil
        }
        
        let firstEntry = dict[0]
        
        imageThumbURL = ""
        
        if let links = json["links"] as? [[String: String]],
            let firstLink = links[0] as? [String: String],
            let thumbURL = firstLink["href"] {
            imageThumbURL = thumbURL
        }
        
        description = ""
        title = ""
        imageLinksURL = ""
        
        if let imageLinksURL = json["href"] as? String,
            let description = firstEntry["description"] as? String,
            let title = firstEntry["title"] as? String {
                self.description = description
                self.title = title
                self.imageLinksURL = imageLinksURL
        }
        
        if let creator = firstEntry["secondary_creator"] as? String,
            let location = firstEntry["location"] as? String,
            let photographer = firstEntry["photographer"] as? String {
                self.creator = creator
                self.location = location
                self.photographer = photographer
        }
    }
}
