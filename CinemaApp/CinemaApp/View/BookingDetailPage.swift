//
//  BookingDetailPage.swift
//  CinemaApp
//
//  Created by Raymond on 12/05/2025.
//

import SwiftUI

struct BookingDetailPage: View {
    let booking: Booking
    @EnvironmentObject var user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            booking.movie.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)

            Text(booking.movie.title)
                .font(.title)
                .bold()

            Text("Time: \(booking.sessionTime)")
            Text("Date: \(formattedDate(booking.sessionDate))")
            Text("Seats: \(booking.seats.map { "\($0.number)" }.joined(separator: ", "))")

            Spacer()
        }
        .padding()
        .navigationTitle("Booking Details")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
