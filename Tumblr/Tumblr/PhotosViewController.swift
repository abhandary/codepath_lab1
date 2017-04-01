//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Akshay Bhandary on 3/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import AFNetworking



class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [NSDictionary] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = true
        self.edgesForExtendedLayout = []
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100
        self.tableView.refreshControl = UIRefreshControl();
        self.tableView.tableHeaderView = UIView(frame:CGRect.zero)
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshTable), for: UIControlEvents.allEvents);
        
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        let loadingview = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingview.startAnimating()
        loadingview.center = (self.tableView.tableFooterView?.center)!
        self.tableView.tableFooterView?.addSubview(loadingview)
        
        refreshTable();
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    func refreshTable () {
        
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
                    self?.tableView.refreshControl?.endRefreshing();
                    
                    NSLog("response: \(responseDictionary)")
                    
                    let dictionary = responseDictionary.value(forKey: "response") as! NSDictionary
                    self?.posts = dictionary["posts"] as! [NSDictionary]
                    self?.tableView.reloadData();
                }
            }
            });
        task.resume()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoDetail" {
            let cell = sender as? PhotoCell
            let vc = segue.destination as! PhotoDetailViewController
            vc.photo = (cell?.photoView?.image)!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "com.tumblr.cell", for: indexPath) as! PhotoCell
        // let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCellReuseID") as! PhotoCell
        
        let post = posts[indexPath.section]
        if let photos = post["photos"] as? [NSDictionary] {
            //make the photo fit the aspect ratio
            let width = photos[0].value(forKeyPath: "original_size.width") as! CGFloat
            let height = photos[0].value(forKeyPath: "original_size.height") as! CGFloat
            let aspectRatio = height/width
            
            cell.photoView?.widthAnchor.constraint(equalTo: (cell.contentView.widthAnchor)).isActive = true
            cell.photoView?.heightAnchor.constraint(equalTo: (cell.photoView?.widthAnchor)!, multiplier:aspectRatio).isActive = true
            
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageUrl = URL(string: imageUrlString!) {
                cell.photoView.setImageWith(imageUrl);
                
            }
        }
      //  cell.textLabel?.text = "This is row \(indexPath.row)"
        
        return cell
    }
    
 

}

