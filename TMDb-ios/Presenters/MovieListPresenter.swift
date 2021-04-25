//
//  Presenter.swift
//  TMDb-ios
//
//  Created by Juan Felipe Torres on 24/04/21.
//

import Foundation
import UIKit
import Kingfisher
import SystemConfiguration

protocol MoviePresenterDelegate: AnyObject {
    func presentMovies(movies: [Movie])
}

typealias PresenterDelegate = MoviePresenterDelegate & UIViewController

class MoviePresenter {
    
    weak var delegate: PresenterDelegate?
    
    public func getMovies(page: Int, viewController: UIViewController) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=56ac45a74cc38d542dac4bbbf3ca7eb8&language=en-US&page=\(page)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                viewController.removeSpinner()
                let response = try JSONDecoder().decode((DataMovies).self, from: data)
                self?.delegate?.presentMovies(movies: response.results)
                
            }
            catch {
                print(error)
                DispatchQueue.main.async {
                    self!.showAlert(viewController: viewController)
                }
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
        imageView.kf.setImage(with: url)
    }
    
    public func didTap(movie: Movie, nav: UINavigationController) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailVC = (storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController)!
        movieDetailVC.movie = movie
        nav.pushViewController(movieDetailVC, animated: true)
    }
    
    public func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func showAlert(viewController: UIViewController) {
        if !isInternetAvailable() {
            let alert = UIAlertController(title: "Warning", message: "Problem with internet connectivity or server, please try after some time", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(action)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
}
