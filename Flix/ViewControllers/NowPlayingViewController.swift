//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Joseph Andy Feidje on 9/17/18.
//  Copyright © 2018 Softmatech. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController,UITableViewDataSource,UIScrollViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movies: [Movie] = []

    var refreshControl: UIRefreshControl!
    var data = [String]()
    var searchController: UISearchController!
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    let placeholderURL = URL(string: "Flix/Assets.xcassets/launch_image.imageset/launch_image.png")!
    let placeholderImages = UIImage(named: "placeholder")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //.............................................................indcator
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height:InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        //................................................................
        self.tableView.separatorInset = UIEdgeInsets.zero
        tableView.dataSource = self

        refreshControl = UIRefreshControl()
        searchController = UISearchController(searchResultsController: nil)
        self.title = "Movies"
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        fetchMovies()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("@@@@@@@@@@@@@@@@@@@------------------------------------------------------------------>> ")
        if (!isMoreDataLoading) {
                        // Calculate the position of one screen length before the bottom of the results
                        let scrollViewContentHeight = tableView.contentSize.height
                        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height

                        // When the user has scrolled past the threshold, start requesting
                        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                            isMoreDataLoading = true

                            // Update position of loadingMoreView, and start loading indicator
                            let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                            loadingMoreView?.frame = frame
                            loadingMoreView!.startAnimating()

                            // Code to load more results
//                            loadMoreData()
                        }
                    }
    }


        func networkErrorAlert(){
            let alertController = UIAlertController(title: "Network Error", message: "It's Seems there is a network error. Please try again later.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: { (action) in self.fetchMovies()}))
            self.present(alertController, animated: true)
        }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
//    func loadMoreData() {
//        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=f09a904547a3537c895babf5612886fa")!
//        let myRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
//        let session = URLSession(configuration: URLSessionConfiguration.default,delegate:nil,delegateQueue:OperationQueue.main)
//        let task : URLSessionDataTask = session.dataTask(with: myRequest, completionHandler: { (data, response, error) in
//            // Update flag
//            self.isMoreDataLoading = false
//            // Stop the loading indicator
//            self.loadingMoreView!.stopAnimating()
//            // ... Use the new data to update the data source ...
//
//            // Reload the tableView now that there is new data
//            // retrieving data
//            if let error = error {
//                print(error.localizedDescription)
//                self.networkErrorAlert()
//            }
//            else if let data = data {
//                let dataDictionnary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//
//                let movies = dataDictionnary["results"] as! [[String: Any]]
//                self.movies = movies
//                self.tableView.reloadData()
//            }
//        })
//        task.resume()
//    }

    func fetchMovies() {
        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.movies = movies
                self.tableView.reloadData()
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.movie = movies[indexPath.row]
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexpath = tableView.indexPath(for: cell) {
            let movie = movies[indexpath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
