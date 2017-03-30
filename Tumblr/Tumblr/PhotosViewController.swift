//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Akshay Bhandary on 3/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    var post: [[String:AnyObject]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: {[weak self] (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                    
                    let dictionary = responseDictionary.value(forKey: "response") as! NSDictionary
                    self?.post = dictionary.value(forKey: "posts") as! [[String : AnyObject]]
                }
            }
        });
        task.resume()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

