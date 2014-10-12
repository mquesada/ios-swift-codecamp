Twitter Client
==============

iOS Swift application to display a list of Tweets from Twitter using [Twitter REST API](https://dev.twitter.com/rest/public).

Time Spent: 10 hours

#Project Requirements
* [x] User can sign in using OAuth login flow
* [x] User can view last 20 tweets from their home timeline
* [x] The current signed in user will be persisted across restarts
* [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
* [x] User can pull to refresh
* [x] User can compose a new tweet by tapping on a compose button.
* User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
* Optional: When composing, you should have a countdown in the upper right for the tweet limit.
* Optional: After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
* Optional: Retweeting and favoriting should increment the retweet and favorite count.
* Optional: User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
* Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
* Optional: User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

#Demo

                    
GIF created with [LiceCap](http://www.cockos.com/licecap/).

Icons used in the app from [http://www.freepik.com/](http://www.freepik.com/)

#Libraries Used

* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [MBProgressHUD] (https://github.com/jdg/MBProgressHUD)
* [TSMessage] (https://github.com/toursprung/TSMessages)
* [BDBOAuth1Manager] (https://github.com/bdbergeron/BDBOAuth1Manager)