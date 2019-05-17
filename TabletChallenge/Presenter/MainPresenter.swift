//
//  MainPresenter.swift
//  TabletChallenge
//
//  Created by Felix Changoo on 4/8/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import Foundation

class MainPresenter {
    enum ImageLoadState {
        case firstLoad, loadMore
    }
    
    var nextPageUrl: String?
    var nasaService: NASAServiceProtocol
    weak var presenterDelegate: MainPresenterDelegate?
    
    var nasaImages: [NasaImage]
    
    init(presenterDelegate: MainPresenterDelegate, nasaService: NASAServiceProtocol = NasaService()) {
        self.nasaService = nasaService
        self.nasaImages = []
        self.presenterDelegate = presenterDelegate
    }
    
    func clearImages() {
        nasaImages.removeAll()
        presenterDelegate?.onfetchImagesSuccess()
    }
    
    func fetchImages(for search: String) {
        nasaService.fetchImages(for: search) { result in
            if let result = result {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.loadImages(with: result, imageLoadState: .firstLoad)
                }
            }
        }
    }
    
    func loadMoreImages() {
        if let nextPageUrl = nextPageUrl {
            nasaService.fetchMoreImages(with: nextPageUrl) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.loadImages(with: result, imageLoadState: .loadMore)
                }
            }
        }
    }
    
    private func loadImages(with result: [String: Any]?, imageLoadState: ImageLoadState) {
        if let result = result?["collection"] as? [String: Any] {
            if let links = result["links"] as? [[String: String]] {
                let nextLink = links.filter { $0["prompt"] == "Next" }.first
                nextPageUrl = nextLink?["href"]
            }
            
            var images: [NasaImage] = []
            
            if let items = result["items"] as? [[String: Any]] {
                images = items.compactMap { NasaImage(with: $0) }

                switch imageLoadState {
                    case .firstLoad:
                        nasaImages = images
                    case .loadMore:
                        nasaImages += images
                }
                presenterDelegate?.onfetchImagesSuccess() 
            } else {
                presenterDelegate?.onfetchImagesFailed()
            }
        }
    }
}
