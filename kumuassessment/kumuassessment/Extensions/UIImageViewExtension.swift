//
//  UIIMageViewExtension.swift
//  kumuassessment
//
//  Created by Lian Concepcion on 6/21/23.
//

import UIKit

extension UIImageView {
    /// Loads and sets the image from the URL
    ///  - Parameters:
    ///         - url: the URL containing the image to be loaded
    func loadUrl(_ url: URL) {
        let session = URLSession(configuration: .default)
        
        let imageLoadTask = session.dataTask(with: url) { (data, response, error) in
            if let e = error {
                print (e)
            } else {
                if let imageData = data {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: imageData)
                    }
                }
            }
            
        }
        
        imageLoadTask.resume()
    }
}
