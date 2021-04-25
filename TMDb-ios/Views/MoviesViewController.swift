//
//  ViewController.swift
//  TMDb-ios
//
//  Created by Juan Felipe Torres on 24/04/21.
//

import UIKit
import Kingfisher

class MoviesViewController: UIViewController, MoviePresenterDelegate {

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private var movies = [Movie]()
    private let presenter = MoviePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies"
        
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        
        moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCollectionViewCell")
        
        // Presenter
        presenter.setViewDelegate(delegate: self)
        presenter.getMovies()
                
    }
    
    //MARK: - Presenter Delegate Methods
    
    func presentMovies(movies: [Movie]) {
        
        self.movies = movies
                
        for i in 0..<self.movies.count{
            self.movies[i].poster_path = "http://image.tmdb.org/t/p/w342" + self.movies[i].poster_path
        }
        
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDelegate Methods

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionViewCell", for: indexPath as IndexPath) as! MovieCollectionViewCell
                
        let movie = movies[indexPath.row]
        
        cell.movieTitle.text = movie.title
        let dateFormatterStringToDate = DateFormatter()
        dateFormatterStringToDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterStringToDate.dateFormat = "yyyy-MM-dd"
        let date = dateFormatterStringToDate.date(from:movie.release_date)!
        
        // Call presenter to fetchImage URL and download the data
        presenter.setImage(urlImage: movie.poster_path, imageView: cell.movieImage)
        
        let dateFormatterDateToStrIng = DateFormatter()
        dateFormatterDateToStrIng.dateFormat = "MMM dd, yyyy"
        
        let dateString = dateFormatterDateToStrIng.string(from: date)
        cell.movieReleaseDate.text = dateString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (view.frame.width / 2) - 5, height: 292)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Ask presenter to handle the tap
        presenter.didTap(movie: movies[indexPath.row], nav: self.navigationController!)
    }

}
