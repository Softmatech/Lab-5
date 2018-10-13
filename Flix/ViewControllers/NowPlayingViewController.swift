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
        indicatorSet()
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
    

        func networkErrorAlert(){
            let alertController = UIAlertController(title: "Network Error", message: "It's Seems there is a network error. Please try again later.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: { (action) in self.fetchMovies()}))
            self.present(alertController, animated: true)
        }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    

    func fetchMovies() {
        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            self.activityIndicator.startAnimating()
            if let movies = movies {
                self.movies = movies
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
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
    
    func indicatorSet(){
        if activityIndicator.isAnimating == true {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        else{
            activityIndicator.isHidden = true
            activityIndicator.startAnimating()
        }
    }
    
}
