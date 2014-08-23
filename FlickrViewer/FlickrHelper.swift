//
//  FlickrHelper.swift
//  FlickrViewer
//
//  Created by Oliver Rosner on 16.08.14.
//  Copyright (c) 2014 Schilum23. All rights reserved.
//

import UIKit

class FlickrHelper: NSObject {
    
    class func URLForSearchString(Suchbergriff searchString: String) -> String {
        
        let apiKey:String = "a77071aee2e61cda4756402f2774ff95"
        let search:String = searchString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let returnValue:String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(search)&per_page=1&format=json&nojsoncallback=1"
        
        return returnValue
        
    }
    
    class func URLForFlickrPhoto(photo:FlickrPhoto, size:String)->String {
        
        var _size:String = size
        if _size.isEmpty {
            
            _size = "m"
            
        }
        
        let returnValue = "http://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.photoID)_\(photo.secret)_\(_size).jpg"
        
        return returnValue
        
    }
    
    func searchFlickrForString(searchStr:String, completion:(searchString:String!, flickerPhotos:NSMutableArray!, error:NSError!)->()){
        
        let searchURL:String = FlickrHelper.URLForSearchString(Suchbergriff: searchStr)
        let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(queue, {
            
            var error:NSError?
            let searchReultString:String! = String.stringWithContentsOfURL(NSURL.URLWithString(searchURL), encoding: NSUTF8StringEncoding, error: &error)
            
            if error != nil {
                
                completion(searchString: searchStr, flickerPhotos: nil, error: error)
                
            } else {
                
                // Parse JSON Response
                let jsonData:NSData! = searchReultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                let resultDict:NSDictionary! = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as NSDictionary
                
                if error != nil {
                    
                    completion(searchString: searchStr, flickerPhotos: nil, error: error)
                    
                } else {
                    
                    let status:String = resultDict.objectForKey("stat") as String
                    
                    if status == "fail" {
                        
                        let error:NSError? = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:resultDict.objectForKey("message")])
                        completion(searchString: searchStr, flickerPhotos: nil, error: error)
                        
                    } else {
                        
                        let resultArray:NSArray = resultDict.objectForKey("photos").objectForKey("photo") as NSArray
                        let flickrPhotos:NSMutableArray = NSMutableArray()
                        
                        for photoObject in resultArray {
                            
                            let photoDict:NSDictionary = photoObject as NSDictionary
                            
                            var flickrPhoto:FlickrPhoto = FlickrPhoto()
                            flickrPhoto.farm = photoDict.objectForKey("farm") as Int
                            flickrPhoto.server = photoDict.objectForKey("server") as String
                            flickrPhoto.secret = photoDict.objectForKey("secret") as String
                            flickrPhoto.photoID = photoDict.objectForKey("id") as String

                            let searchURL:String = FlickrHelper.URLForFlickrPhoto(flickrPhoto, size: "m")
                            let imageData:NSData = NSData(contentsOfURL:NSURL.URLWithString(searchURL), options: nil, error: &error)
                            
                            let image:UIImage = UIImage(data: imageData)
                            
                            flickrPhoto.thumbnail = image
                            flickrPhotos.addObject(flickrPhoto)
                            
                            
                        }
                        
                        completion(searchString: searchStr, flickerPhotos: flickrPhotos, error: nil)
                        
                    }
                    
                }
                
            }
            
            
        })
        
    }
   
}
































