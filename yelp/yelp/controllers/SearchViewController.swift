//
//  SearchViewController.swift
//  yelp
//
//  Created by Maricel Quesada on 9/30/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let consumerKey = "bb0cSZQ5TjORqBXJdLYSWQ"
    let consumerSecret = "g4fCISJKin7M5rqjk2_VMEAhjXQ"
    let accessToken = "suComg6zANp1rCasqN8CdQLmeyWdN7TA"
    let accessSecret = "1n_x9wo20ZOLi9z1OOA1TNfQ-Ds"
    
    var client : YelpClient!
    var searchBar: UISearchBar!
    var refreshControl: UIRefreshControl!
    
    var businesses = [Business]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.client = YelpClient(consumerKey: consumerKey, consumerSecret: consumerSecret, accessToken: accessToken, accessSecret: accessSecret)
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("BusinessCell") as BusinessCell
        cell.business = self.businesses[indexPath.row]
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        showLoadingSpinner()
        
        client.searchWithTerm(searchBar.text,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let businesses = (response["businesses"] as Array).map({
                    (data: NSDictionary) -> Business in
                    return Business(data: data)
                })
                
                self.businesses = businesses
                
                // Hide loading state
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                self.tableView.reloadData()
                
                
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.showNetworkErrorMsg()
            }
        )
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
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName : UIColor.orangeColor()])
        self.refreshControl.addTarget(self, action: Selector("refresh:"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func refresh(sender: AnyObject) {
        
    }
    
    func showNetworkErrorMsg() {
        TSMessage.showNotificationWithTitle("Network Error", type: TSMessageNotificationType.Error)
    }

}
