//
//  MoviesViewController.swift
//  rotten
//
//  Created by Maricel Quesada on 9/23/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITabBarDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [Movie]()
    var filteredMovies = [Movie]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tabBar.delegate = self
        
        setUpSearchTableView()
        
        // Set the refresh control
        setRefreshControl()
        
        // Select first
        tabBar.selectedItem = tabBar.items?.first as? UITabBarItem
        
        // Load the movie list
        loadMovieList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* === TABLE VIEW METHODS === */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredMovies.count
        } else {
            return self.movies.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var movie : Movie
        if (tableView == self.searchDisplayController!.searchResultsTableView) {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        cell.movie = movie
        cell.titleLabel.text = movie.title
        cell.synopsisLabel.text = movie.synopsis
        
        var image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(movie.posterUrl)
        if (image != nil) {
            cell.posterImage.image = image
        } else {
            // If image not in cache then load it asynchronously and store it in the cache
            let request = NSURLRequest(URL: NSURL(string: movie.posterUrl))
            cell.posterImage.setImageWithURLRequest(request, placeholderImage: nil,
                success: { (request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
                        cell.posterImage.image = image
                        cell.posterImage.setNeedsLayout()
                        SDImageCache.sharedImageCache().storeImage(image, forKey: movie.posterUrl, toDisk: true)
                }, failure: {
                    (request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
                        cell.posterImage.image = nil
                        cell.posterImage.setNeedsLayout()
            })
        }
        
        UIView.animateWithDuration(1.5, animations: {
            cell.posterImage.alpha = 1.0
        })
        
        return cell
    }
    
    /*
        Method to load the list of movies asynchronously.
        It updates the the table view and the list of movies.
    */
    func loadMovieList() {
        if (hasConnectivity()) {
            // Show loading state
            showLoadingSpinner()
            
            // Clear the movie list
            self.movies = []
            
            // Request the movie list
            var url: String
            if (tabBar.selectedItem?.tag == 0) {
                url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=vdcqkrw8bk2s44kymf9rrf2y"
            } else {
                url = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=vdcqkrw8bk2s44kymf9rrf2y"
            }
            
            var request = NSURLRequest(URL: NSURL(string: url))
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                
                // Get the JSON data from the response
                var jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                
                // Process the JSON to get the movies
                var movieList = jsonObject["movies"] as [NSDictionary]
                for movie in movieList {
                    self.movies.append(Movie(data: movie))
                }
                
                // Update the table view
                self.tableView.reloadData()
                
                // Hide loading state
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        } else {
            // If there is no connectivity, show a network error message
            showNetworkErrorMsg()
        }
    }
    
    /* === SEGUE METHODS === */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var cell = sender as MovieCell
        var detailsController = segue.destinationViewController as MovieDetailsViewController
        cell.movie.posterImage = cell.posterImage.image
        detailsController.movie = cell.movie
    }
    
    /* === TAB BAR METHODS === */
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        loadMovieList()
    }
    
    /* === REFRESH CONTROL METHODS === */
    
    func setRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = UIColor.blackColor()
        self.refreshControl.tintColor = UIColor.orangeColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: Selector("refresh:"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func refresh(sender: AnyObject) {
        loadMovieList()
        
        self.refreshControl.endRefreshing()
    }
    
    /* === CONNECTIVITY METHODS === */
    
    func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().value
        return networkStatus != 0
    }

    func showNetworkErrorMsg() {
        TSMessage.showNotificationWithTitle("Network Error", type: TSMessageNotificationType.Error)
    }
    
    /* === LOADING SPINNER METHODS === */
    
    func showLoadingSpinner() {
        let loading = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loading.mode = MBProgressHUDModeDeterminate
        loading.labelText = "Loading...";
    }
    
    /* === TABLE SEARCH METHODS === */
    
    func setUpSearchTableView() {
        self.searchDisplayController!.searchResultsTableView.rowHeight = 100
        self.searchDisplayController!.searchResultsTableView.backgroundColor = UIColor.blackColor()
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredMovies = self.movies.filter({( movie: Movie) -> Bool in
            let titleMatch = movie.title.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let synopsisMatch = movie.synopsis.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return (titleMatch != nil || synopsisMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }

}
