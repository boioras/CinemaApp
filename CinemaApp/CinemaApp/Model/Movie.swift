//
//  Movie.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 6/5/2025.
//

import SwiftUI

struct Movie: Hashable, Codable {
    var title: String
    var rating: Float
    var description: String
    var runtime: Int
}
