//
//  Movie.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 6/5/2025.
//

import SwiftUI

// MovieRating struct for API call
struct MovieRating: Codable {
    let imdbRating: String
}

// Movie struct
struct Movie: Hashable, Codable {
    var title: String
    var rating: Float
    var description: String
    var runtime: Int
    private var imageName: String
    
    var image: Image {
        Image(imageName)
    }

    // allow previews
    init(title: String, rating: Float, description: String, runtime: Int, imageName: String) {
        self.title = title
        self.rating = rating
        self.description = description
        self.runtime = runtime
        self.imageName = imageName
    }
}
