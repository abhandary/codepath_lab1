//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Akshay Bhandary on 3/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var isMoreDataLoading = false
    var posts: [NSDictionary] = []
    var loadingview = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ready to read?"
        self.edgesForExtendedLayout = []
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100
        self.tableView.refreshControl = UIRefreshControl();
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshTable), for: UIControlEvents.allEvents);
        
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 70;
        
        let footerview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        loadingview.center = (footerview.center)
        footerview.addSubview(loadingview)
        self.tableView.tableFooterView = footerview
        
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
                    self?.title = dictionary.value(forKeyPath: "blog.title") as! String?
                    self?.tableView.reloadData();
                    self?.isMoreDataLoading = false
                    self?.loadingview.stopAnimating()
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
            let indexPath: IndexPath = tableView.indexPath(for: cell!)!
            let section = indexPath.section
            let blog = self.posts[section].value(forKey: "caption")
            vc.blog = blog as! String?
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 70))
        let datelabel = UILabel()
        let namelabel = UILabel()
        
        let date: String = self.posts[section].value(forKey: "date") as! String
        let blogName: String = self.posts[section].value(forKey: "blog_name") as! String
    
        datelabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        datelabel.text = date
        namelabel.text = blogName
        datelabel.numberOfLines = 0
        namelabel.numberOfLines = 0
        
        
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        let profiileView = UIImageView()
        
        profiileView.translatesAutoresizingMaskIntoConstraints = false
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        datelabel.translatesAutoresizingMaskIntoConstraints = false
        
        profiileView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profiileView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profiileView.clipsToBounds = true
        profiileView.layer.cornerRadius = 25;
        profiileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profiileView.layer.borderWidth = 1;
        
        profiileView.setImageWith(NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")! as URL)
        
        profiileView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        profiileView.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        namelabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        let content = UIStackView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.axis = .horizontal
        content.alignment = .center
        content.spacing = 10
        headerView.addSubview(content)
        content.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        content.widthAnchor.constraint(equalTo: headerView.widthAnchor).isActive = true
        content.addArrangedSubview(profiileView)
        content.addArrangedSubview(namelabel)
        content.addArrangedSubview(datelabel)
        
        return headerView
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "com.tumblr.cell", for: indexPath) as! PhotoCell

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
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isMoreDataLoading else {
            return
        }

        
        let scrollViewContentHeight = tableView.contentSize.height
        let threshold =  scrollViewContentHeight - tableView.bounds.size.height
        
        if(scrollView.contentOffset.y > threshold && tableView.isDragging) {
            isMoreDataLoading = true
            refreshTable()
            loadingview.startAnimating()
        }
        
        
    }
 

}

