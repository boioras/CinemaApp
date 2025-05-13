//
//  BookingDetailPage.swift
//  CinemaApp
//
//  Created by Raymond on 12/05/2025.
//

import SwiftUI

struct BookingDetailPage: View {
    let booking: Booking

    // seat grid constants
    private let rowsCount = 6
    private let seatsPerRow = 10
    private var totalSeats: Int { rowsCount * seatsPerRow }
    private var leftSide: Range<Int> { 0..<(totalSeats / 2) }
    private var rightSide: Range<Int> { (totalSeats / 2)..<totalSeats }

    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode
    @State private var showPopUp = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // booking details
                Text(booking.movie.title)
                    .font(.title)
                    .bold()
                
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Session Details")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(formattedDate(booking.sessionDate))
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Image(systemName: "clock")
                        Text(booking.sessionTime)
                    }
                    .font(.subheadline)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Your Seats")
                        .font(.headline)
                    
                    Text(booking.seats.map { $0.number }
                         .sorted()
                         .map { "\($0)" }
                         .joined(separator: ", "))
                        .font(.subheadline)
                }
                
                Divider()
                    .padding(.vertical, 10)

                // screen
                VStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 280, height: 8)
                            .foregroundColor(.gray)
                        Text("SCREEN")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .offset(y: 18)
                    }
                    
                    Spacer().frame(height: 30)

                    // seat grid
                    HStack(spacing: 30) {
                        let leftColumns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
                        LazyVGrid(columns: leftColumns, spacing: 13) {
                            ForEach(leftSide, id: \.self) { index in
                                let seatNumber = index + 1
                                SeatView(
                                    seatNumber: seatNumber,
                                    isSelected: isMySeat(seatNumber),
                                    isBooked: false,
                                    isMyBooking: false
                                )
                            }
                        }

                        let rightColumns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
                        LazyVGrid(columns: rightColumns, spacing: 13) {
                            ForEach(rightSide, id: \.self) { index in
                                let seatNumber = index + 1
                                SeatView(
                                    seatNumber: seatNumber,
                                    isSelected: isMySeat(seatNumber),
                                    isBooked: false,
                                    isMyBooking: false
                                )
                            }
                        }
                    }
                    .padding(.top)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Booking Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { // individual cancel button
                    showPopUp = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert(isPresented: $showPopUp) {
            Alert(
                title: Text("Cancel Booking"),
                message: Text("Are you sure you want to cancel this booking?"),
                primaryButton: .destructive(Text("Cancel")) {
                    user.cancelBooking(booking)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text("Return"))
            )
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func isMySeat(_ number: Int) -> Bool {
        booking.seats.contains { $0.number == number }
    }
}
