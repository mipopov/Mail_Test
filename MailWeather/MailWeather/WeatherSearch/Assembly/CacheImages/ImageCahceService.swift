//
//  PhotoService.swift
//  WeatherApp
//
//  Created by Andrey Antropov on 02/10/2019.
//  Copyright © 2019 Morizo Digital. All rights reserved.
//

import UIKit
import Alamofire

class ImageCahceService {
    private var memoryCache = [String: UIImage]()
    private let cacheLifetime: TimeInterval = 60*60*24*7
    private let isolationQueue = DispatchQueue(label: "isolationQueue", qos: .default)
    
    private static let pathName: String = {
        let pathName = "WeatherImages"
        
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cacheDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private func getFilePath(urlString: String) -> String? {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hashName = urlString.split(separator: "/").last ?? "default.png"
        return cacheDirectory.appendingPathComponent(ImageCahceService.pathName + "/" + hashName).path
    }
    
    private func saveImageToFilesystemCache(urlString: String, image: UIImage) {
        guard let filename = getFilePath(urlString: urlString) else { return }
        let data = image.pngData()
        FileManager.default.createFile(atPath: filename, contents: data, attributes: nil)
    }
    
    private func getImageFromFilesystemCache(urlString: String) -> UIImage? {
        guard let filename = getFilePath(urlString: urlString),
            let info = try? FileManager.default.attributesOfItem(atPath: filename),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return nil }
        
        let lifetime = Date().timeIntervalSince(modificationDate)
        guard lifetime <= cacheLifetime,
            let image = UIImage(contentsOfFile: filename) else { return nil }
        
        isolationQueue.async { [weak self] in
            guard let self = self else {return }
            self.memoryCache[urlString] = image
        }
        
        return image
    }
    
    private func loadPhoto(urlString: String, completion: @escaping (UIImage?) -> Void) {
        AF.request(urlString).responseData { [weak self] response in
            guard let self = self,
                let data = response.data,
                let image = UIImage(data: data) else {
                    completion(nil)
                    return
            }
            self.isolationQueue.async { [weak self] in
                guard let self = self else {return }
                self.memoryCache[urlString] = image
            }
            self.saveImageToFilesystemCache(urlString: urlString, image: image)
            completion(image)
        }
    }
    
    public func getPhoto(by urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let image = memoryCache[urlString] {
            completion(image)
        } else if let image = getImageFromFilesystemCache(urlString: urlString) {
            completion(image)
        } else {
            loadPhoto(urlString: urlString, completion: completion)
        }
    }
}
