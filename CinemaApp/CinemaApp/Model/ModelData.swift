//
//  ModelData.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 6/5/2025.
//

import Foundation

var movies: [Movie] = load("movieData.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            
    else{
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func loadRatings(title: String) async throws -> String {
    var movieResponse: MovieRating
    var urlString = "https://omdbapi.com/?&apikey=a411cec0&t=\(title)&y=2025"
    var url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
        guard let url = URL(string: url!) else {
            print("fail url")
            return ""
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return ""}

        do {
            movieResponse = try JSONDecoder().decode(MovieRating.self, from: data)
        } catch {
            print("fail decode")
            return ""
        }

    return movieResponse.imdbRating
}
