//
//  Genre.swift
//  TMDb-ios
//
//  Created by Juan Felipe Torres on 25/04/21.
//

import Foundation

struct Genres: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
