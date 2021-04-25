//
//  Data.swift
//  TMDb-ios
//
//  Created by Juan Felipe Torres on 24/04/21.
//

import Foundation

struct DataMovies: Codable {
    
    let page: Int
    let results: [Movie]
}
