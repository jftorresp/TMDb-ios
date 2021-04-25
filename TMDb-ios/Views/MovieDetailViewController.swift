//
//  MovieDetailViewController.swift
//  TMDb-ios
//
//  Created by Juan Felipe Torres on 25/04/21.
//

import UIKit

class MovieDetailViewController: UIViewController, MovieDetailPresenterDelegate {
    
    @IBOutlet weak var movieBackdropImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieTotalVotes: UILabel!
    @IBOutlet weak var movieAverageVotes: UILabel!
    @IBOutlet weak var totalVotesView: UIView!
    @IBOutlet weak var averageVotesView: UIView!
    
    var movie: Movie?
    var genres: [Genre]?
    private let presenter = MovieDetailPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalVotesView.layer.cornerRadius = 10
        averageVotesView.layer.cornerRadius = 10
        
        movieTitle.text = movie?.title
        movieGenres.text = ""
        
        let dateFormatterStringToDate = DateFormatter()
        dateFormatterStringToDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterStringToDate.dateFormat = "yyyy-MM-dd"
        let date = dateFormatterStringToDate.date(from:movie!.release_date)!
        let dateFormatterDateToStrIng = DateFormatter()
        dateFormatterDateToStrIng.dateFormat = "dd/MM/yyyy"
        
        let dateString = dateFormatterDateToStrIng.string(from: date)
        movieReleaseDate.text = dateString
        movieOverview.text = movie?.overview
        movieTotalVotes.text = "\(movie?.vote_count ?? 0) total votes"
        movieAverageVotes.text = "\(movie?.vote_average ?? 0.0) average votes"
        
        // Presenter methods
        // Presenter
        presenter.setViewDelegate(delegate: self)
        presenter.getGenres()
        let urlImage = presenter.getBackDropUrl(backdropPath: movie!.backdrop_path)
        presenter.setBackDropImage(urlImage: urlImage, imageView: movieBackdropImage)

    }
    
    //MARK: - Presenter Delegate Methods

    func presentGenres(genres: [Genre]) {
        self.genres = genres
        
        for i in 0..<genres.count {
            for j in 0..<(movie?.genre_ids.count)! {
                if(genres[i].id == movie?.genre_ids[j]) {
                    DispatchQueue.main.async {
                        self.movieGenres.text = self.movieGenres.text! + " / " + genres[i].name
                    }
                }
            }
        }
    }
}
