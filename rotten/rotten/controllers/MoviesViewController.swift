//
//  MoviesViewController.swift
//  rotten
//
//  Created by Maricel Quesada on 9/23/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [Movie] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Set the refresh control
        setRefreshControl()
        
        // Load the movie list
        loadMovieList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var movie = movies[indexPath.row]
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        
        cell.titleLabel.text = movie.title
        cell.synopsisLabel.text = movie.synopsis
        cell.posterImage.setImageWithURL(NSURL(string: movie.posterUrl))
        
        UIView.animateWithDuration(1.5, animations: {
            cell.posterImage.alpha = 1.0
        })
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var cell = sender as MovieCell
        let selectedIndex = self.tableView.indexPathForCell(cell)
        
        var detailsController = segue.destinationViewController as MovieDetailsViewController
        
        var movie = movies[selectedIndex!.row]
        movie.posterImage = cell.posterImage.image
        detailsController.movie = movie

    }
    
    func setRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: Selector("refresh:"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func refresh(sender: AnyObject) {
        loadMovieList()
        
        self.refreshControl.endRefreshing()
    }
    
    func loadMovieList() {
        if (hasConnectivity()) {
            // Show loading state
            showLoadingSpinner()
            
            // Request the movie list
            let url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=vdcqkrw8bk2s44kymf9rrf2y"
            var request = NSURLRequest(URL: NSURL(string: url))
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                
                // Get the JSON data from the response
                var jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                
                // Process the JSON to get the movies
                var movieList = jsonObject["movies"] as [NSDictionary]
                for m in movieList {
                    var movie = Movie(data: m)
                    self.movies.append(movie)
                }
                
                // Update the table view
                self.tableView.reloadData()
                
                // Hide loading state
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        } else {
            showNetworkErrorMsg()
        }
    }
    
    func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().value
        return networkStatus != 0
    }
    
    func showLoadingSpinner() {
        let loading = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loading.mode = MBProgressHUDModeDeterminate
        loading.labelText = "Loading...";
    }
    
    func showNetworkErrorMsg() {
        TSMessage.showNotificationWithTitle("Network Error", type: TSMessageNotificationType.Error)
    }

}
