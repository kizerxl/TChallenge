//
//  MainProtocols.swift
//  TabletChallenge
//
//  Created by Felix Changoo on 4/8/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import Foundation

protocol MainPresenterDelegate: class {
    func onfetchImagesSuccess()
    func onfetchImagesFailed()
    func onfetchMoreImages()
}

protocol NASAServiceProtocol {
    typealias completion = ([String: Any]?) -> ()
    typealias jsonCompletion = ([String]?) -> ()
    
    func fetchImages(for search: String, completionHandler: @escaping completion)
    func fetchMoreImages(with urlString: String, completionHandler: @escaping completion)
}
