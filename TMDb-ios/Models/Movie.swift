//
//  Movie.swift
//  TMDb-ios
//
//  Created by Juan Felipe Torres on 24/04/21.
//

import Foundation

struct Movie: Codable {
    
    let adult: Bool
    let backdrop_path: String
    let genre_ids: [Int]
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    var poster_path: String
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
}
