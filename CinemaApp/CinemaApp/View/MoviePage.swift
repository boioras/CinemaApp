//
//  MoviePage.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 6/5/2025.
//

import SwiftUI

struct MoviePage: View {
    let movie: Movie
    @State var select: String = ""
    
    private var posterName: String {
        // Convert movie title to lowercase and remove special characters

        return movie.title.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Movie poster from assets
                ZStack(alignment: .bottom) {
                    movie.image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                        .overlay(
                            // Fallback if image doesn't load
                            GeometryReader { geo in
                                if UIImage(named: posterName) == nil {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                        .foregroundColor(.gray)
                                    }
                                }
                            }
                        )
                    
                    // Gradient overlay for text visibility
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                }
                
                // Movie details
                VStack(alignment: .leading, spacing: 12) {
                    Text(movie.title)
                        .font(.title)
                        .bold()
                        .padding(.top)
                    
                    // Rating and runtime
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", movie.rating) + "/10")
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                            Text(formatRuntime(movie.runtime))
                        }
                    }
                    .font(.subheadline)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Description
                    Text("Synopsis")
                        .font(.headline)
                    
                    Text(movie.description)
                        .padding(.top, 4)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Simple showtimes section
                    Text("Showtimes")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Today")
                            .font(.subheadline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(["6:15 PM", "9:30 PM"], id: \.self) { time in
                                    Button(action: {
                                        if(select == time){
                                            select = ""
                                        } else {
                                            select = time
                                        }
                                        // connect to seats screen here
                                        // send session time data using Date
                                    }) {
                                        Text(time)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(select == time ? Color.blue : Color.white)
                                            .border(select == time ? Color.blue : Color.gray, width: 2.5)
                                            .foregroundColor(select == time ? Color.white : Color.black)
                                            .cornerRadius(6)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 4)
                    
                    // Tomorrow's showtimes
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tomorrow")
                            .font(.subheadline)
                            .padding(.top, 12)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(["1:00 PM", "4:30 PM", "7:45 PM", "10:15 PM"], id: \.self) { time in
                                    Button(action: {
                                        if(select == time){
                                            select = ""
                                        } else {
                                            select = time
                                        }
                                        // connect to seats screen here
                                        // send session time data using Date
                                    }) {
                                        Text(time)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(select == time ? Color.blue : Color.white)
                                            .border(select == time ? Color.blue : Color.gray, width: 2.5)
                                            .foregroundColor(select == time ? Color.white : Color.black)
                                            .cornerRadius(6)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Book button
                    Button(action: {
                        print("Book button tapped")
                    }) {
                        Text("Book Tickets")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Helper function to format runtime
    private func formatRuntime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)h \(mins)m"
    }
}

// Preview provider
struct MoviePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MoviePage(movie: movies[0])
        }
    }
}
