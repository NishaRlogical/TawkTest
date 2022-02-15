//
//  ImageCacheService.swift
//  TawkDevTest
//
//  Created by rlogical-dev-59 on 15/02/22.
//

import Foundation
import UIKit

extension UIImageView {
    /// Downaload and Cache Image to storage
    /// - Parameter remoteURL: chached image path
    func setImage(from remoteURL: URL) {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let targetURL = documentURL.appendingPathComponent(remoteURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: targetURL.path) {
            image = UIImage(contentsOfFile: targetURL.path)
        } else {
            URLSession.shared.dataTask(with: remoteURL) { (data, response, error) in
                if error != nil {
                    print("Error needs to be handled")
                    return
                }
                try? data?.write(to: targetURL)
                let image = UIImage.init(data: data!)
                DispatchQueue.main.async {
                    self.image = image
                }
            }.resume()
        }
        
    }
}

extension UIImage {
    /// Invert Color of Image
    /// - Returns: inverted image
    func invertedImage() -> UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }
        let image = CoreImage.CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setDefaults()
        filter?.setValue(image, forKey: "inputImage")
        let context = CIContext(options: nil)

        guard let filter = filter, let outputImage = filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
