Twitter Client
==============

iOS Swift application to display a list of Tweets from Twitter using [Twitter REST API](https://dev.twitter.com/rest/public).

Time Spent: 10 hours

#Project Requirements

## Hamburger menu
* [x] Dragging anywhere in the view should reveal the menu.
* [x] The menu should include links to your profile, the home timeline, and the mentions view. - The menu can look similar to the LinkedIn menu below or feel free to take liberty with the UI.

## Profile page
* [x] Contains the user header view
* [x] Contains a section with the users basic stats: # tweets, # following, # followers
* Optional: Implement the paging view for the user description.
* Optional: As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
* Optional: Pulling down the profile page should blur and resize the header image.

## Home Timeline
* [x] Tapping on a user image should bring up that user's profile page
* Optional: Account switching
    * Long press on tab bar to bring up Account view with animation
    * Tap account to switch to
    * Include a plus button to Add an Account
    * Swipe to delete an account

#Demo

![Application demo](twitter-demo.gif)
                    
GIF created with [LiceCap](http://www.cockos.com/licecap/).

Icons used in the app from [http://www.freepik.com/](http://www.freepik.com/) and [http://www.iconarchive.com/](http://www.iconarchive.com/)

#Libraries Used

* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [MBProgressHUD] (https://github.com/jdg/MBProgressHUD)
* [TSMessage] (https://github.com/toursprung/TSMessages)
* [BDBOAuth1Manager] (https://github.com/bdbergeron/BDBOAuth1Manager)
* [DateTools] (https://github.com/MatthewYork/DateTools)
