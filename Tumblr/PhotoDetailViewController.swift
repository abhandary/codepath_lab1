//
//  PhotoDetailViewController.swift
//  Tumblr
//
//  Created by kathy yin on 3/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    var scrollview: UIScrollView?
    var photo: UIImage?
    var photoView: UIImageView?
    var blog: String?
    var blogView: UILabel = UILabel()
    var content: UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        self.scrollview?.translatesAutoresizingMaskIntoConstraints = false
        self.content.translatesAutoresizingMaskIntoConstraints = false
        self.scrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(scrollview!)
        self.scrollview?.addSubview(self.content)
        
        self.content.bottomAnchor.constraint(equalTo: (self.scrollview?.bottomAnchor)!).isActive = true
        self.content.topAnchor.constraint(equalTo: (self.scrollview?.topAnchor)!).isActive = true
        self.photoView?.translatesAutoresizingMaskIntoConstraints = false
        self.blogView.translatesAutoresizingMaskIntoConstraints = false
        self.photoView = UIImageView(image: photo)
        self.content.addSubview(self.photoView!)
        let width = self.photo?.size.width
        let height = self.photo?.size.height
        let ratio = (height!/width!)
        
        self.photoView?.topAnchor.constraint(equalTo: self.content.topAnchor).isActive = true
        self.photoView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.photoView?.heightAnchor.constraint(lessThanOrEqualTo: (self.photoView?.widthAnchor)!, multiplier: ratio).isActive = true
    
        self.content.addSubview(self.blogView)
        self.blogView.preferredMaxLayoutWidth = self.view.frame.size.width - 20
        self.blogView.leadingAnchor.constraint(equalTo: self.content.leadingAnchor, constant: 10).isActive = true
        self.blogView.trailingAnchor.constraint(equalTo: self.content.trailingAnchor, constant: -10).isActive = true
        
        let str = self.blog?.replacingOccurrences(of: "<[^>]*>", with: "", options: .regularExpression, range: nil)
       
        self.blogView.topAnchor.constraint(equalTo: (self.photoView?.bottomAnchor)!, constant: 5).isActive = true
        self.blogView.bottomAnchor.constraint(equalTo: self.content.bottomAnchor).isActive = true
        self.blogView.numberOfLines = 0
        self.blogView.text = str
    
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
