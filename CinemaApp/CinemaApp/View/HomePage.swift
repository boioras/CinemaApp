//
//  HomePage.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 6/5/2025.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        let layout = [
            GridItem(.fixed(170)),
            GridItem(.fixed(170))
        ]
        NavigationView {
            VStack {
                Text("Now Showing")
                    .font(.title)
                
                ScrollView(.vertical, showsIndicators: false){
                    LazyVGrid(columns: layout) {
                        ForEach(movies, id: \.self) { movie in
                            VStack {
                                NavigationLink(destination: MoviePage(movie: movie)) {
                                    movie.image
                                        .resizable()
                                        .frame(width: 130, height: 200)
                                        .cornerRadius(30.0)
                                }
                                Text(movie.title)
                                    .font(.callout)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
