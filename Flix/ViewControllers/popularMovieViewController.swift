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
        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMovies() {
        MovieApiManager().popularMovies { (movies: [Movie]?, error: Error?) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularCell", for: indexPath) as! PopularCell
        
        cell.movie = movies[indexPath.row]
        
        return cell
    }
    
}
