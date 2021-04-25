//
//  ViewController.swift
//  TMDb-ios
//
//  Created by Juan Felipe Torres on 24/04/21.
//

import UIKit
import Kingfisher

class MoviesViewController: UIViewController, MoviePresenterDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var movies = [Movie]()
    var filteredMovies: [Movie]!
    private let presenter = MoviePresenter()
    var page: Int = 1
    var isPageRefreshing:Bool = false
    var dataFetched: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies"
        
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        searchBar.delegate = self
        
        moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCollectionViewCell")
        
        // The spinner will show if the data hasn't been fetched yet
        showSpinner(onView: self.view)
        
        // Presenter
        presenter.setViewDelegate(delegate: self)
        presenter.getMovies(page: self.page, viewController: self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //MARK: - Presenter Delegate Methods
    
    func presentMovies(movies: [Movie]) {
        
        dataFetched = true
        
        self.movies = self.movies + movies
        
        // Update poster_path url for all images adding the base URL
        for i in 0..<self.movies.count{
            self.movies[i].poster_path = "http://image.tmdb.org/t/p/w342" + self.movies[i].poster_path
        }
        
        self.filteredMovies = self.movies
        
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
    
    //MARK: - ScrollView Handler for Pagination
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if searchBar.showsCancelButton == false || searchBar.isSearchResultsButtonSelected == false {
            if(self.moviesCollectionView.contentOffset.y >= (self.moviesCollectionView.contentSize.height - self.moviesCollectionView.bounds.size.height)) {
                if !isPageRefreshing {
                    isPageRefreshing = true
                    page = page + 1
                    presenter.getMovies(page: page, viewController: self)
                }
             
             isPageRefreshing = false
            }
        }
   }
}

//MARK: - UICollectionViewDelegate Methods

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionViewCell", for: indexPath as IndexPath) as! MovieCollectionViewCell
        let movie = filteredMovies?[indexPath.row]
        
        cell.movieTitle.text = movie?.title
        let dateFormatterStringToDate = DateFormatter()
        dateFormatterStringToDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterStringToDate.dateFormat = "yyyy-MM-dd"
        let date = dateFormatterStringToDate.date(from:movie!.release_date)!
        
        // Call presenter to fetchImage URL and download the data
        presenter.setImage(urlImage: movie!.poster_path, imageView: cell.movieImage)
        
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
        presenter.didTap(movie: filteredMovies[indexPath.row], nav: self.navigationController!)
    }
    
}

//MARK: - UISearchBarDelegate Methods

extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredMovies = searchText.isEmpty ? movies : movies.filter { (item: Movie) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
}
