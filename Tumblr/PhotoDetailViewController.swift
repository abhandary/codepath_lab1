//
//  PhotoDetailViewController.swift
//  Tumblr
//
//  Created by kathy yin on 3/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    var photo: UIImage?
    var photoView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.translatesAutoresizingMaskIntoConstraints = true
        self.edgesForExtendedLayout = []
        self.photoView = UIImageView(image: photo)
        self.view.addSubview(self.photoView!)
        
        let width = self.photo?.size.width
        let height = self.photo?.size.height
        
        self.photoView?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.photoView?.widthAnchor.constraint(equalToConstant: width!).isActive = true
        self.photoView?.heightAnchor.constraint(equalToConstant: height!).isActive = true
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
