//
//  BookingsPage.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 6/5/2025.
//

import SwiftUI

struct BookingsPage: View {
    @EnvironmentObject var user: User
    @State private var selectedBooking: Booking? = nil
    @State private var showPopUp = false
    
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
                        NavigationLink(destination: BookingDetailPage(booking: booking)) {
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
                                Button {
                                    selectedBooking = booking
                                    showPopUp = true
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                        .alert(isPresented: Binding(
                            get: { showPopUp && selectedBooking == booking },
                            set: { showPopUp = $0 }
                        )) {
                            Alert(
                                title: Text("Cancel Booking"),
                                message: Text("Are you sure you want to cancel this booking?"),
                                primaryButton: .destructive(Text("Cancel")) {
                                    if let bookingToCancel = selectedBooking {
                                        user.cancelBooking(bookingToCancel)
                                    }
                                },
                                secondaryButton: .cancel(Text("Return"))
                            )
                        }
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
