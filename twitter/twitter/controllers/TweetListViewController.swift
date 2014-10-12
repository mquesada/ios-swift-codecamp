//
//  TweetListViewController.swift
//  twitter
//
//  Created by Maricel Quesada on 10/11/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit



class TweetListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    var refreshControl: UIRefreshControl!
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        TSMessage.setDefaultViewController(self)
        
        setRefreshControl()
        
        homeTimeline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func homeTimeline() {
        showLoadingSpinner()
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if (error == nil) {
                self.tweets = tweets!
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            } else {
                TSMessage.showNotificationWithTitle("Error loading timeline", type: TSMessageNotificationType.Error)
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        cell.tweet = self.tweets[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tweetDetailsSegue") {
            var detailsController = segue.destinationViewController as TweetDetailsViewController
            var cell = sender as TweetCell
            detailsController.tweet = cell.tweet
        }
    }
    
    
    @IBAction func logoutAction(sender: AnyObject) {
        User.currentUser?.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func addTweet(sender: AnyObject) {
        self.performSegueWithIdentifier("tweetSegue", sender: self)
    }
    
    /* === LOADING SPINNER METHODS === */
    
    func showLoadingSpinner() {
        let loading = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loading.mode = MBProgressHUDModeDeterminate
        loading.color = self.navigationController?.navigationBar.backgroundColor
        loading.labelText = "Loading...";
    }
    
    /* === REFRESH CONTROL METHODS === */
    
    func setRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.blueColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName : UIColor.blueColor()])
        self.refreshControl.addTarget(self, action: Selector("refresh:"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func refresh(sender: AnyObject) {
        homeTimeline()
    }
    
}
