//
//  SearchViewController.swift
//  yelp
//
//  Created by Maricel Quesada on 9/30/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
                            UISearchBarDelegate, FilterViewDelegate, CLLocationManagerDelegate {
    
    let defaultTerm = "Restaurants"    
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    var refreshControl: UIRefreshControl!
    var searchManager: SearchManager!
    var locationManager = CLLocationManager()
    var businesses = [Business]()
    var loading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        setRefreshControl()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }        
        
        self.searchManager = SearchManager()
        
        // Load some restaurants first
        self.searchBar.text = defaultTerm
        doSearch()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row + 5 >= self.businesses.count && !self.loading) {
            loadMoreBusinesses()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("BusinessCell") as BusinessCell
        cell.frame = CGRectMake(0, 0, 9999, 9999)
        cell.business = self.businesses[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.destinationViewController is UINavigationController) {
            let navigationController = segue.destinationViewController as UINavigationController
            if (navigationController.viewControllers[0] is FiltersViewController) {
                let filterController = navigationController.viewControllers[0] as FiltersViewController
                filterController.delegate = self
                filterController.filterManager = self.searchManager.filterManager
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.searchManager.userLocation.currentLocation = locations.last as CLLocation
        self.locationManager.stopUpdatingLocation()
    }
    
    /* === FILTER DELEGATE METHODS === */
    
    func filteringDone() {
        doSearch()
    }
    
    /* === SEARCH METHODS === */
    
    func doSearch() {
        self.searchManager.executeSearch(searchBar.text,
            before: self.showLoadingSpinner,
            after:{ () -> Void in },
            onSuccess: { (businesses: [Business]) -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                // Stop refreshing if it was
                self.refreshControl.endRefreshing()
                
                self.businesses = businesses
                
                self.tableView.reloadData()
            },
            onFailure: { () -> Void in                
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                // Stop refreshing if it was
                self.refreshControl.endRefreshing()
                
                self.showNetworkErrorMsg()
            }
        )
    }
    
    func loadMoreBusinesses() {
        self.loading = true
        self.searchManager.executeSearch(searchBar.text,
            before: self.showLoadingSpinner,
            after:{ () -> Void in },
            onSuccess: { (businesses: [Business]) -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                // Stop refreshing if it was
                self.refreshControl.endRefreshing()
                
                for business in businesses {
                    var row = self.businesses.count
                    self.businesses.append(business)
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow:row, inSection:0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
                self.loading = false
            },
            onFailure: { () -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                // Stop refreshing if it was
                self.refreshControl.endRefreshing()
                
                self.showNetworkErrorMsg()
            }
        )
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        doSearch()
    }
    
    /* === LOADING SPINNER METHODS === */
    
    func showLoadingSpinner() {
        let loading = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loading.mode = MBProgressHUDModeDeterminate
        loading.color = UIColor.redColor()
        loading.labelText = "Searching...";
    }
    
    /* === REFRESH CONTROL METHODS === */
    
    func setRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.redColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
        self.refreshControl.addTarget(self, action: Selector("refresh:"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func refresh(sender: AnyObject) {
        self.searchManager.offset = 0
        if (searchBar.text.isEmpty){
            searchBar.text = defaultTerm
        }
        doSearch()
    }
    
    func showNetworkErrorMsg() {
        TSMessage.showNotificationWithTitle("Network Error", type: TSMessageNotificationType.Error)
    }

}
