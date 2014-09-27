Rotten Tomatoes Client
======================

iOS Swift application to display the list of box office movies or DVDs from [RottenTomatoes API](http://www.rottentomatoes.com/).

Time Spent: 15 hours

*Install Pods before opening project*

#Project Requirements
* [x] User can view a list of movies from Rotten Tomatoes. Poster images must be loading asynchronously.
* [x] User can view movie details by tapping on a cell
* [x] User sees loading state while waiting for movies API. You can use one of the 3rd party libraries at cocoacontrols.com.
* [x] User sees error message when there's a networking error. You may not use UIAlertView to display the error. See this screenshot for what the error message should look like: network error screenshot.
* [x] User can pull to refresh the movie list.
* [x] All images fade in (optional)
* [x] For the large poster, load the low-res image first, switch to high-res when complete (optional)
* [x] All images should be cached in memory and disk. In other words, images load immediately upon cold start (optional).
* [x] Customize the highlight and selection effect of the cell. (optional)
* [x] Customize the navigation bar. (optional)
* [x] Add a tab bar for Box Office and DVD. (optional)
* [x] Add a search bar. (optional)

##Additional Requirements
* [x] Must use Cocoapods.
* [x] Asynchronous image downloading must be implemented using the UIImageView category in the AFNetworking library.

#Libraries Used
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [MBProgressHUD] (https://github.com/jdg/MBProgressHUD)
* [TSMessage] (https://github.com/toursprung/TSMessages)
* [SDWebImage] (https://github.com/rs/SDWebImage)
* [Reachability] (https://developer.apple.com/library/ios/samplecode/Reachability/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007324-Intro-DontLinkElementID_2)

#Demo

![Application demo](rotten-demo.gif)
                    
GIF created with [LiceCap](http://www.cockos.com/licecap/).

Icons used in the app from [http://www.freepik.com/](http://www.freepik.com/)