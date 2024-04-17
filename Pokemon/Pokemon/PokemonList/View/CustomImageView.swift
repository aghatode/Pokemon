//
//  CustomImageView.swift
//  Pokemon
//
//  Created by Aditi Patil on 13/04/2024.
//

import UIKit

public var imageCache = NSCache<AnyObject, AnyObject>()
class CustomImageView: UIImageView {
    let activityIndicator = UIActivityIndicatorView()
    var imageId: String?
    
    override var intrinsicContentSize: CGSize {
        if let img = self.image {
            let ratio = self.frame.size.width / img.size.width
            let newHeight = img.size.height * ratio

            return CGSize(width: self.frame.size.width, height: newHeight)
        }
        return CGSize(width: -1.0, height: -1.0)
    }
    
    //Checks if the image exists in cache else downloads the image from url
    func loadImage(urlString: String, id: String) {
        self.image = nil
        imageId = id
        activityIndicator.color = .black
        activityIndicator.style = .medium
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        
        if let imageFromCache = imageCache.object(forKey: id as AnyObject) as? UIImage {
            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }
        
        if let url = URL(string: urlString) {
            downloadImage(url: url, id: id)
        }
    }

    func downloadImage(url: URL, id: String) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                if let img = UIImage(data: data) {
                    if self.imageId == id {
                        self.image = img
                    }
                    imageCache.setObject(img, forKey: id as AnyObject)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        task.resume()
    }
    
}

