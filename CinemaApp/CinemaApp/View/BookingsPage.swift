//
//  BookingsPage.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 6/5/2025.
//

import SwiftUI

struct BookingsPage: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        NavigationView {
            List {
                // no bookings placeholder
                if user.bookings.isEmpty {
                    Text("You have no bookings.")
                        .foregroundColor(.gray)
                } else {
                    // loop through all bookings / display movie details
                    ForEach(user.bookings) { booking in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                // movie poster image
                                booking.movie.image
                                    .resizable()
                                    .frame(width: 60, height: 90)
                                    .cornerRadius(8)
                                
                                // booking details
                                VStack(alignment: .leading) {
                                    Text(booking.movie.title)
                                        .font(.headline)
                                    Text("Time: \(booking.sessionTime)")
                                    Text("Date: \(formattedDate(booking.sessionDate))")
                                    Text("Seats: \(booking.seats.map { "\($0.number)" }.joined(separator: ", "))")
                                        .font(.subheadline)
                                }
                                
                                Spacer()
                                
                                // cancel button
                                Button(role: .destructive) {
                                    user.cancelBooking(booking)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("Your Bookings") // title of the navigation bar
        }
    }
    
    // helper function to format dates
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// preview block
struct BookingsPage_Previews: PreviewProvider {
    static var previews: some View {
        // mock movie

        // dummy booking
        let mockBooking = Booking(
            movie: movies[0],
            seats: [Seat(number: 1, isBooked: true), Seat(number: 2, isBooked: true)],
            sessionDate: Date(),
            sessionTime: "7:00 PM"
        )

        // mock user with booking
        let mockUser = User()
        mockUser.bookings = [mockBooking]

        return BookingsPage()
            .environmentObject(mockUser)
    }
}
