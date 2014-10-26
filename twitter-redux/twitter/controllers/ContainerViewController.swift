//
//  ContainerViewController.swift
//  twitter
//
//  Created by Maricel Quesada on 10/17/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, MenuDelegate {
    
    var slideMenuController: SlideMenuViewController!
    var loginController: LoginViewController!
    var tweetsController: UINavigationController!
    var profileController: UINavigationController!
    var mentionsController: UINavigationController!

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var panGesture: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogin", name: userDidLoginNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLogoutNotification, object: nil)

        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.slideMenuController = storyboard.instantiateViewControllerWithIdentifier("SlideMenuViewController") as SlideMenuViewController
        addChildViewController(self.slideMenuController)
        self.menuView.addSubview(self.slideMenuController.view)
        self.slideMenuController.view.frame = self.view.frame
        self.slideMenuController.didMoveToParentViewController(self)
        self.slideMenuController.menuDelegate = self
        
        if (User.currentUser != nil) {
            self.tweetsController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationViewController") as UINavigationController
            self.addChildViewController(self.tweetsController)
            self.contentView.addSubview(self.tweetsController.view)
            self.tweetsController.view.frame = self.view.frame
            self.tweetsController.didMoveToParentViewController(self)
        } else {
            self.loginController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
            addChildViewController(self.loginController)
            self.contentView.addSubview(self.loginController.view)
            self.loginController.view.frame = self.view.frame
            self.loginController.didMoveToParentViewController(self)
            
        }
        self.view.bringSubviewToFront(self.contentView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func userDidLogin() {
        self.setTweetsControllerInContentView()
        self.slideMenuController.setData()
    }
    
    func userDidLogout() {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.loginController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
        addChildViewController(self.loginController)
        self.contentView.addSubview(self.loginController.view)
        self.loginController.view.frame = self.view.frame
        self.loginController.didMoveToParentViewController(self)
    }
        
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        if (User.isLoggedIn()) {
            var location = sender.locationInView(self.view)
            
            if (sender.state == UIGestureRecognizerState.Began || sender.state == UIGestureRecognizerState.Changed) {
                var quarter = self.view.frame.width / 8
                if (location.x <= (quarter * 7)) {
                    self.contentView.frame.origin.x = location.x
                }
            } else if (sender.state == UIGestureRecognizerState.Ended) {
               var center = self.view.center
                if (location.x < center.x) {
                    self.openContentView()
                } else {
                    var quarter = self.view.frame.width / 8
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.contentView.frame.origin.x = (quarter * 7)
                    })
                }
            }
        }
    }

    func setTweetsControllerInContentView() {
        if (self.tweetsController == nil) {
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.tweetsController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationViewController") as UINavigationController
            self.addChildViewController(self.tweetsController)
        }
        
        self.contentView.addSubview(self.tweetsController.view)
        self.tweetsController.view.frame = self.view.frame
        self.tweetsController.didMoveToParentViewController(self)
    }
    
    func showTimeline() {
        self.setTweetsControllerInContentView()
        openContentView()
    }
    
    func showProfile() {
        if (self.profileController == nil) {
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.profileController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as UINavigationController
            self.addChildViewController(self.profileController)
        }
        self.contentView.addSubview(self.profileController.view)
        self.profileController.view.frame = self.view.frame
        self.profileController.didMoveToParentViewController(self)
        
        openContentView()
    }
    
    func showMentions() {
        if (self.mentionsController == nil) {
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.mentionsController = storyboard.instantiateViewControllerWithIdentifier("MentionsNavigationViewController") as UINavigationController
            self.addChildViewController(self.mentionsController)
        }
        
        self.contentView.addSubview(self.mentionsController.view)
        self.mentionsController.view.frame = self.view.frame
        self.mentionsController.didMoveToParentViewController(self)
        
        openContentView()
    }
    
    func openContentView() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.contentView.frame.origin.x = 0;
        })
    }
}
