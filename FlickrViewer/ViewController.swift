//
//  ViewController.swift
//  FlickrViewer
//
//  Created by Oliver Rosner on 16.08.14.
//  Copyright (c) 2014 Schilum23. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var flickrIconImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var flickrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func searchForImage(sender: UIButton) {
        
        searchTextField.resignFirstResponder()
        
        let flickr:FlickrHelper = FlickrHelper()
        if searchTextField.text.isEmpty {
            
            let alert:UIAlertController = UIAlertController(title: "Oops", message: "Please enter a search term", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            flickrIconImageView.backgroundColor = UIColor.blackColor()
            activity.startAnimating()
            
            flickr.searchFlickrForString(searchTextField.text, completion: { (searchString:String!, flickerPhotos:NSMutableArray!, error:NSError!) -> () in
            
                if !error {
                    
                    let flickrPhoto:FlickrPhoto = flickerPhotos.objectAtIndex(Int(arc4random_uniform(UInt32(flickerPhotos.count)))) as FlickrPhoto
                    
                    let image:UIImage = flickrPhoto.thumbnail
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.flickrImageView.image = image
                        self.activity.stopAnimating()
                        self.flickrIconImageView.backgroundColor = UIColor.clearColor()
                        
                    })
                    
                }
               
            
            })
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

