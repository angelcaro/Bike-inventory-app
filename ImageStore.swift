//
//  ImageStore.swift
//  BikeRecords
//
//  Created by Angel Caro on 1/20/16.
//  Copyright © 2016 AngelCaro. All rights reserved.
//

import UIKit

class ImageStore {
    
    let cache = NSCache()
    
    func setImage(image: UIImage, forKey Key: String) {
        cache.setObject(image, forKey: Key)
        
        let imageURL = imageURLForKey(Key)
        
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            
            data.writeToURL(imageURL, atomically: true)
        }
    }
    
    func imageForKey(Key: String) -> UIImage? {
        
        if let existingImage = cache.objectForKey(Key) as? UIImage {
            return existingImage
        }
        
        let imageURL = imageURLForKey(Key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: Key)
        return imageFromDisk
    }
    
    func deleteImageForKey(Key: String) {
        cache.removeObjectForKey(Key)
        
        let imageURL = imageURLForKey(Key)
        do {
        try NSFileManager.defaultManager().removeItemAtURL(imageURL)
        } catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
    }
    
    func imageURLForKey(Key: String) -> NSURL {
        
        let documentsDirectories =
            NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,
                inDomains: .UserDomainMask)
        
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.URLByAppendingPathComponent(Key)
    }
}
