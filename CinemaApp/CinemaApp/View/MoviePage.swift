//
//  MoviePage.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 6/5/2025.
//

import SwiftUI

struct MoviePage: View {
    // Sample movie data
    let movie: Movie
    
    // State variables to manage the UI
    @State private var selectedDate: Date = Date()
    @State private var showBookingOptions = false
    
    // Sample showtimes
    let showtimes = [
        "12:30 PM",
        "3:00 PM",
        "6:15 PM",
        "9:30 PM"
    ]
    
    // Sample theaters
    let theaters = [
        "Theater 1 - Standard",
        "Theater 3 - IMAX",
        "Theater 5 - Dolby"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Movie poster/header area
                headerSection
                
                // Movie details
                infoSection
                
                Divider()
                    .padding(.horizontal)
                
                // Description
                descriptionSection
                
                Divider()
                    .padding(.horizontal)
                
                // Showtimes
                showtimesSection
                
                // Book button
                bookButton
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
    
    // MARK: - UI Sections
    
    private var headerSection: some View {
        ZStack(alignment: .bottom) {
            // Movie poster placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 250)
                .overlay(
                    VStack {
                        Image(systemName: "film")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text(movie.title)
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                )
            
            // Gradient for text readability
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)
        }
    }
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(movie.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
                .padding(.horizontal)
            
            HStack(spacing: 16) {
                // Rating
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", movie.rating) + "/10")
                }
                
                // Duration
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text(formatRuntime(movie.runtime))
                }
            }
            .font(.subheadline)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Synopsis")
                .font(.headline)
                .padding(.top, 16)
                .padding(.horizontal)
            
            Text(movie.description)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                .padding(.bottom, 16)
        }
    }
    
    private var showtimesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Showtimes")
                .font(.headline)
                .padding(.top, 16)
                .padding(.horizontal)
            
            // Date selector
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding(.horizontal)
            
            // Show times
            VStack(alignment: .leading, spacing: 12) {
                ForEach(theaters, id: \.self) { theater in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(theater)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(showtimes, id: \.self) { time in
                                    Button(action: {
                                        showBookingOptions = true
                                    }) {
                                        Text(time)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(.bottom, 4)
                        }
                    }
                    .padding(.horizontal)
                    
                    if theater != theaters.last {
                        Divider()
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                    }
                }
            }
            .padding(.bottom, 16)
        }
    }
    
    private var bookButton: some View {
        Button(action: {
            showBookingOptions = true
        }) {
            Text("Book Tickets")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .alert(isPresented: $showBookingOptions) {
            Alert(
                title: Text("Seat Selection Coming Soon"),
                message: Text("This feature will be integrated with your team's work on Friday"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Helper Functions
    
    private func formatRuntime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)h \(mins)m"
    }
}

// MARK: - Preview Provider

struct MoviePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MoviePage(movie: Movie(
                title: "Inception",
                rating: 8.8,
                description: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O. This complex sci-fi action film explores the architecture of the mind through a dream within a dream within a dream.",
                runtime: 148
            ))
        }
    }
}
