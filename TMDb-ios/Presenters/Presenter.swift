//
//  Presenter.swift
//  TMDb-ios
//
//  Created by Juan Felipe Torres on 24/04/21.
//

import Foundation
import UIKit
import Kingfisher

protocol MoviePresenterDelegate: AnyObject {
    func presentMovies(movies: [Movie])
    func presentAlert(title: String, message: String)
}

typealias PresenterDelegate = MoviePresenterDelegate & UIViewController

class MoviePresenter {
    
    weak var delegate: PresenterDelegate?
    
    public func getMovies() {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=56ac45a74cc38d542dac4bbbf3ca7eb8&language=en-US") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
                        
            do {
                let response = try JSONDecoder().decode((DataMovies).self, from: data)
                self?.delegate?.presentMovies(movies: response.results)
                
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
        
    public func setViewDelegate(delegate: PresenterDelegate) {
        
        self.delegate = delegate
    }
    
    public func setImage(urlImage: String, imageView: UIImageView) {        
        let url = URL(string: urlImage)!
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url) { result in
            switch result {
            case .success(let value):
                print(value.image)

                print(value.cacheType)

                print(value.source)

            case .failure(let error):
                print(error)
            }
        }
    }
}
