//
//  MoviePage.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 6/5/2025.
//

import SwiftUI

struct MoviePage: View {
    let movie: Movie
    @State private var selectedTime: String = ""
    @State private var selectedDate: Date = Date()
    @State private var navigateToSeatPage = false
    @State private var rating = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Movie poster from assets
                ZStack(alignment: .bottom) {
                    movie.image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 600)
                        .cornerRadius(20)
                        .clipped()
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
//                            Text(String(format: "%.1f", rating) + "/10")
                            Text(rating.isEmpty ? "Loading..." : "\(rating)/10")
                        }
                        .task {
                            do {
                                rating = try await loadRatings(title: movie.title)
                                if(rating == "N/A") { rating = String(format: "%.1f", movie.rating) }
                            } catch {
                                print("error")
                            }
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
                                        selectedTime = time
                                        selectedDate = Date()
                                    }) {
                                        Text(time)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(selectedTime == time && Calendar.current.isDateInToday(selectedDate) ? Color.blue : Color.white)
                                            .border(selectedTime == time && Calendar.current.isDateInToday(selectedDate) ? Color.blue : Color.gray, width: 2.5)
                                            .foregroundColor(selectedTime == time && Calendar.current.isDateInToday(selectedDate) ? Color.white : Color.black)
                                            .cornerRadius(6)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 4)
                    
                    // Tomorrow's showtimes
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tomorrow")
                            .font(.subheadline)
                            .padding(.top, 12)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(["1:00 PM", "4:30 PM", "7:45 PM", "10:15 PM"], id: \.self) { time in
                                    Button(action: {
                                        selectedTime = time
                                        selectedDate = tomorrow
                                    }) {
                                        Text(time)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(selectedTime == time && Calendar.current.isDate(selectedDate, inSameDayAs: tomorrow) ? Color.blue : Color.white)
                                            .border(selectedTime == time && Calendar.current.isDate(selectedDate, inSameDayAs: tomorrow) ? Color.blue : Color.gray, width: 2.5)
                                            .foregroundColor(selectedTime == time && Calendar.current.isDate(selectedDate, inSameDayAs: tomorrow) ? Color.white : Color.black)
                                            .cornerRadius(6)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Book button
                    Button(action: {
                        if !selectedTime.isEmpty {
                            navigateToSeatPage = true
                        }
                    }) {
                        Text("Book Tickets")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedTime.isEmpty ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(selectedTime.isEmpty)
                    .padding(.top, 20)
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                NavigationLink(
                    destination: SeatPage(
                        movie: movie,
                        sessionTime: selectedTime,
                        sessionDate: selectedDate
                    ),
                    isActive: $navigateToSeatPage
                ) {
                    EmptyView()
                }
            )
        }
    }
    
    // Helper function to format runtime
    private func formatRuntime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)h \(mins)m"
    }
    
    // Helper function to check if a date is today
    private func isToday(_ date: Date) -> Bool {
        return Calendar.current.isDateInToday(date)
    }
}

// Preview provider
struct MoviePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MoviePage(movie: movies[1])
        }
    }
}
