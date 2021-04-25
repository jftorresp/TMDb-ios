//
//  MovieDetailPresenter.swift
//  TMDb-ios
//
//  Created by Juan Felipe Torres on 25/04/21.
//

import Foundation
import UIKit
import Kingfisher

protocol MovieDetailPresenterDelegate: AnyObject {
    func presentGenres(genres: [Genre])
}

typealias DetailPresenterDelegate = MovieDetailPresenterDelegate & UIViewController

class MovieDetailPresenter {
    
    weak var delegate: DetailPresenterDelegate?
    
    public func setBackDropImage(urlImage: String, imageView: UIImageView) {
        let url = URL(string: urlImage)!
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
    }
    
    public func getBackDropUrl(backdropPath: String)->String  {
        let url = "http://image.tmdb.org/t/p/w780" + backdropPath
        return url
    }
    
    public func getGenres() {
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=56ac45a74cc38d542dac4bbbf3ca7eb8&language=en-US") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
                        
            do {
                let response = try JSONDecoder().decode((Genres).self, from: data)
                self?.delegate?.presentGenres(genres: response.genres)
                
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    public func setViewDelegate(delegate: DetailPresenterDelegate) {
        
        self.delegate = delegate
    }
    
}
