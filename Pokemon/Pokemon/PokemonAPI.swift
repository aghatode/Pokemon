//
//  PokemonAPI.swift
//  Pokemon
//
//  Created by Aditi Patil on 14/04/2024.
//
import Foundation

class PokemonAPI {
    
    static let baseUrl = "https://pokeapi.co/api/v2"
    static let cache = URLCache(
        memoryCapacity: 0,
        diskCapacity: 100*1024*1024,
        diskPath: "PokeAPICache"
    )
    
    static func get(path: String, params: Dictionary<String, String>? = nil, onSuccess: ((_ data: Data)->Void)? = nil, onError: (()->Void)? = nil){
        
       guard path.count > 0 else { onError?(); return }
        
        var url = URL(string: baseUrl + path)!
        params?.forEach({ key, value in
            url.appendQueryParam(key: key, value: value)
        })
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = .useProtocolCachePolicy
        
        if let data = cache.cachedResponse(for: request)?.data, let response = cache.cachedResponse(for: request)?.response {
            guard let response = response as? HTTPURLResponse else {
                print("Not a HTTP response")
                onError?()
                return
            }
            guard response.statusCode == 200 else {
                print("Invalid HTTP status code \(response.statusCode)")
                onError?()
                return
            }
            onSuccess?(data)
        } else {
            let sessionConfiguration = URLSessionConfiguration.default
            sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
            sessionConfiguration.urlCache = cache
            URLSession(configuration: sessionConfiguration).dataTask(with: request, completionHandler: { data, response, error -> Void in
                if let error = error {
                    print("Network error: " + error.localizedDescription)
                    onError?()
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    print("Not a HTTP response")
                    onError?()
                    return
                }
                guard response.statusCode == 200 else {
                    print("Invalid HTTP status code \(response.statusCode)")
                    onError?()
                    return
                }
                guard let data = data else {
                    print("No HTTP data")
                    onError?()
                    return
                }
                
                cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                onSuccess?(data)
            }).resume()
        }

       
    }
}


extension URL {
    
    mutating func appendQueryParam(key: String, value: String?) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: key, value: value)
        
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        
        self = urlComponents.url!
    }
}
