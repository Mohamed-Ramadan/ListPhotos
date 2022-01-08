//
//  UIImageView+Extension.swift
//  ListPhotos
//
//  Created by Mohamed Ramadan on 07/01/2022.
//
 
import UIKit
import ObjectiveC
  
extension UIImageView {
    
    private struct AssociatedKey {
        static var task = "task"
        static var spinner = "spinner"
    }
    
    var task: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.task) as? URLSessionDataTask
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.task, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func loadImage(from url: URL, backgroundImage: UIImage? = nil, identifier: String? = nil) {
        image = backgroundImage
        
        addSpinner()
        
        var imageFileName = ""
        if let identifier = identifier {
            imageFileName = identifier
        } else {
            imageFileName = url.pathComponents.dropFirst().joined()
        }
         
        if let task = task {
            task.cancel()
        }
    
        if let imageFromCache = self.loadImageFromDocumentDirectory(fileName: imageFileName) {
            self.image = imageFromCache
            self.backgroundColor = self.image?.averageColor
            self.removeSpinner()
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard
               let data = data,
               let newImage = UIImage(data: data)
            else {
                print("coundn't load image from url: \(url)")
                return
            }
            
            if self.saveImageInDocumentDirectory(image: newImage, fileName: imageFileName) != nil {
                //print("Image saved successfully to url: \(url.absoluteString)")
            }
            
            DispatchQueue.main.async {
                self.image = newImage
                self.backgroundColor = self.image?.averageColor
                self.removeSpinner()
            }
        }
        
        task?.resume()
        
    }
    
    func addSpinner() {
        let spinner = UIActivityIndicatorView(style: .medium)
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 2).isActive = true
        
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        for view in self.subviews {
            if view is UIActivityIndicatorView {
                view.removeFromSuperview()
            }
        }
    }
    
    func saveImageInDocumentDirectory(image: UIImage, fileName: String) -> URL? {
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.pngData() {
            try? imageData.write(to: fileURL, options: .atomic)
            return fileURL
        }
        return nil
    }

    func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {}
        return nil
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
