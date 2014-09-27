//
//  MovieDetailsViewController.swift
//  rotten
//
//  Created by Maricel Quesada on 9/23/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var movie: Movie!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieScore: UILabel!
    @IBOutlet weak var movieSynopsis: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var detailsViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMovieData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMovieData() {
        self.title = movie.title
        self.movieTitle.text = "\(movie.title) \(movie.year) (\(movie.rating))"
        self.movieScore.text = "Critics score: \(movie.criticsScore)  Audience score: \(movie.audienceScore)"
        self.movieSynopsis.text = movie.synopsis
        setMovieImage()
    }
    
    func setMovieImage() {
        // Check if image is in cache
        var image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(movie.posterUrlOrig)
        if (image != nil) {
            self.posterImage.image = image
        } else {
            // If image is not in cache, load it
            let request = NSURLRequest(URL: NSURL(string: movie.posterUrlOrig))
            self.posterImage.setImageWithURLRequest(request, placeholderImage: movie.posterImage,
                success: { (request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
                    self.posterImage.image = image
                    SDImageCache.sharedImageCache().storeImage(image, forKey: self.movie.posterUrlOrig, toDisk: true)
                }, failure: {
                    (request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
                    self.posterImage.image = self.movie.posterImage
            })
        }
    }
    
}
