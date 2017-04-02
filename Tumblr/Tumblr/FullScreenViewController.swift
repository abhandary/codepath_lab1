//
//  FullScreenViewController.swift
//  Tumblr
//
//  Created by kathy yin on 4/1/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    var image: UIImage?
    var fullScreenImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        self.fullScreenImageView = UIImageView(image: image)
        scrollView.contentSize = (fullScreenImageView?.image?.size)!
        self.scrollView.addSubview(fullScreenImageView!)
      
    }

    @IBAction func tapDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.fullScreenImageView
    }
    //func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //return imageView
    //}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
