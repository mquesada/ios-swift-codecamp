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

        self.title = movie.title
        
        self.movieTitle.text = "\(movie.title) \(movie.year) (\(movie.rating))"
        self.movieScore.text = "Critics score: \(movie.criticsScore)  Audience score: \(movie.audienceScore)"
        self.movieSynopsis.text = movie.synopsis
        
        self.posterImage.setImageWithURL(NSURL(string: movie.posterUrlOrig), placeholderImage: movie.posterImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
