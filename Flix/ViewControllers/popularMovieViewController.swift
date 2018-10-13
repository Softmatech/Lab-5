//
//  popularMovieViewController.swift
//  Flix
//
//  Created by Joseph Andy Feidje on 10/12/18.
//  Copyright © 2018 Softmatech. All rights reserved.
//

import UIKit

class popularMovieViewController: UIViewController,UITableViewDataSource,UIScrollViewDelegate {
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
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
        indicatorSet()
//        var insets = tableView.contentInset
//        insets.bottom += InfiniteScrollActivityView.defaultHeight
//        tableView.contentInset = insets
        //................................................................
        self.tableView.separatorInset = UIEdgeInsets.zero
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        searchController = UISearchController(searchResultsController: nil)
        self.title = "Most Popular Movies"
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        definesPresentationContext = true
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMovies() {
        MovieApiManager().popularMovies { (movies: [Movie]?, error: Error?) in
            self.indicatorView.startAnimating()
            if let movies = movies {
                self.movies = movies
                self.indicatorView.stopAnimating()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularCell", for: indexPath) as! PopularCell
        
        cell.movie = movies[indexPath.row]
        
        return cell
    }
    func networkErrorAlert(){
        let alertController = UIAlertController(title: "Network Error", message: "It's Seems there is a network error. Please try again later.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: { (action) in self.fetchMovies()}))
        self.present(alertController, animated: true)
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        self.fetchMovies()
    }
    
    func indicatorSet(){
        if indicatorView.isAnimating == true {
            indicatorView.stopAnimating()
            indicatorView.isHidden = true
        }
        else{
            indicatorView.isHidden = true
            indicatorView.startAnimating()
        }
    }
    
}
