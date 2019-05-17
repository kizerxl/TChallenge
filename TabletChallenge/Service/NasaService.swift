//
//  NasaService.swift
//  TabletChallenge
//
//  Created by Felix Changoo on 4/8/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import Foundation

class NasaService: NASAServiceProtocol {
    func fetchImages(for search: String, completionHandler: @escaping completion) {
        guard let url = URL(string: Endpoints.Images.search.url) else {
            return
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completionHandler(.none)
            return
        }
        
        let queryItems = [URLQueryItem(name: "q", value: search)]
        urlComponents.queryItems = queryItems
        
        guard let urlWithQuery = urlComponents.url else {
            completionHandler(.none)
            return
        }
        
        fetch(url: urlWithQuery, completionHandler: completionHandler)
    }
    
    func fetchMoreImages(with urlString: String, completionHandler: @escaping completion) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        fetch(url: url, completionHandler: completionHandler)
    }
    
    private func fetch(url: URL, completionHandler: @escaping completion) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                guard let data = data else {
                    completionHandler(.none)
                    return
                }
                
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                guard let jsonDict = jsonObject else {
                    completionHandler(.none)
                    return
                }
                
                completionHandler(jsonDict)
                
            } catch {
                completionHandler(.none)
            }
        }.resume()
    }
}
