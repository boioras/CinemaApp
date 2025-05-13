//
//  SeatPage.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 6/5/2025.
//

import SwiftUI

struct SeatPage: View {
    let movie: Movie
    let sessionTime: String
    let sessionDate: Date
    @State private var selectedSeats: [Int] = []
    @State private var bookedSeats: [Int] = []
    @State private var showBookingConfirmation = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var user: User
    
    // Constants for the seat grid
    private let rowsCount = 6
    private let seatsPerRow = 10
    private let totalSeats: Int
    private let leftSide: Range<Int>
    private let rightSide: Range<Int>
    
    init(movie: Movie, sessionTime: String, sessionDate: Date) {
        self.movie = movie
        self.sessionTime = sessionTime
        self.sessionDate = sessionDate
        
        // Calculating total seats and creating the left/right side ranges
        self.totalSeats = rowsCount * seatsPerRow
        self.leftSide = 0..<totalSeats/2
        self.rightSide = totalSeats/2..<totalSeats
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with title and back button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Select Seats")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Screen image
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 280, height: 8)
                    .foregroundColor(.gray)
                
                Text("SCREEN")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .offset(y: 18)
            }
            .padding(.bottom, 40)
            
            // Seat grid
            HStack(spacing: 30) {
                // Left side of seats
                let leftColumns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
                LazyVGrid(columns: leftColumns, spacing: 13) {
                    ForEach(leftSide, id: \.self) { index in
                        let seatNumber = index + 1
                        SeatView(
                            seatNumber: seatNumber,
                            isSelected: selectedSeats.contains(seatNumber),
                            isBooked: bookedSeats.contains(seatNumber),
                            isMyBooking: isMyBookedSeat(seatNumber)
                        )
                        .onTapGesture {
                            toggleSeatSelection(seatNumber)
                        }
                        .disabled(bookedSeats.contains(seatNumber) || isMyBookedSeat(seatNumber))
                    }
                }
                
                // Right side of seats
                let rightColumns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
                LazyVGrid(columns: rightColumns, spacing: 13) {
                    ForEach(rightSide, id: \.self) { index in
                        let seatNumber = index + 1
                        SeatView(
                            seatNumber: seatNumber,
                            isSelected: selectedSeats.contains(seatNumber),
                            isBooked: bookedSeats.contains(seatNumber),
                            isMyBooking: isMyBookedSeat(seatNumber)
                        )
                        .onTapGesture {
                            toggleSeatSelection(seatNumber)
                        }
                        .disabled(bookedSeats.contains(seatNumber) || isMyBookedSeat(seatNumber))
                    }
                }
            }
            .padding()
            
            // Seat legend
            HStack(spacing: 30) {
                legendItem(color: .white, borderColor: Color.blue, text: "Available")
                legendItem(color: Color.blue, borderColor: Color.blue, text: "Selected")
            }
            HStack(spacing: 30) {
                legendItem(color: .white, borderColor: Color.gray, text: "Booked")
                legendItem(color: Color.gray, borderColor: Color.gray, text: "Your Booking")
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Selection summary
            VStack(alignment: .leading, spacing: 8) {
                Text("\(movie.title)")
                    .font(.headline)
                
                HStack {
                    Text("\(formattedDate(sessionDate))")
                    Spacer()
                    Text("\(sessionTime)")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
                HStack {
                    Text("Selected Seats:")
                    Text(selectedSeatsText)
                        .foregroundColor(.blue)
                    Spacer()
                    if !selectedSeats.isEmpty {
                        Text("$\(selectedSeats.count * 12).00")
                            .fontWeight(.bold)
                    }
                }
                .padding(.top, 5)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Book button
            Button(action: {
                confirmBooking()
            }) {
                Text("Confirm Booking")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedSeats.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .disabled(selectedSeats.isEmpty)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .onAppear {
            loadBookedSeats()
        }
        .alert(isPresented: $showBookingConfirmation) {
            Alert(
                title: Text("Booking Confirmed"),
                message: Text("Your booking for \(movie.title) at \(sessionTime) on \(formattedDate(sessionDate)) has been confirmed."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // Checks if current user has already booked this seat for this session
    private func isMyBookedSeat(_ seatNumber: Int) -> Bool {
        for booking in user.bookings {
            if booking.movie.title == movie.title &&
                booking.sessionTime == sessionTime &&
                Calendar.current.isDate(booking.sessionDate, inSameDayAs: sessionDate) {
                if booking.seats.contains(where: { $0.number == seatNumber }) {
                    return true
                }
            }
        }
        return false
    }
    
    // Loads already booked seats from other bookings
    private func loadBookedSeats() {
        // Adding some default booked seats
        let tempBookedSeats = [3, 7, 12, 22, 30, 34, 41, 45]
        
        // To not add seats already booked by the user
        bookedSeats = tempBookedSeats.filter { !isMyBookedSeat($0) }
    }
    
    // Helper function to toggle seat selection
    private func toggleSeatSelection(_ seatNumber: Int) {
        if selectedSeats.contains(seatNumber) {
            selectedSeats.removeAll { $0 == seatNumber }
        } else {
            selectedSeats.append(seatNumber)
        }
    }
    
    // Helper function to create legend items
    private func legendItem(color: Color, borderColor: Color, text: String) -> some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 4)
                .stroke(borderColor, lineWidth: 2)
                .background(color.cornerRadius(4))
                .frame(width: 20, height: 20)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    // Formats the selected seats as a string
    private var selectedSeatsText: String {
        if selectedSeats.isEmpty {
            return "None"
        }
        let sortedSeats = selectedSeats.sorted()
        return sortedSeats.map { String($0) }.joined(separator: ", ")
    }
    
    // Helper function to format dates
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Function to confirm booking and save it
    private func confirmBooking() {
        // Creates Seat objects from selected seat numbers
        let seats = selectedSeats.map { Seat(number: $0, isBooked: true) }
        
        // Creates new booking
        let newBooking = Booking(
            movie: movie,
            seats: seats,
            sessionDate: sessionDate,
            sessionTime: sessionTime
        )
        
        // Adds to user's bookings
        user.bookings.append(newBooking)
        
        // Saves bookings
        user.saveBookings(bookings: user.bookings)
        
        // Shows confirmation dialog
        showBookingConfirmation = true
        
        // Clears selection (in same page)
        selectedSeats = []
        
        // Updating the booked seats view
        loadBookedSeats()
    }
}

// Seat view component
struct SeatView: View {
    let seatNumber: Int
    let isSelected: Bool
    let isBooked: Bool
    let isMyBooking: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .stroke(
                    isBooked ? Color.gray :
                        isMyBooking ? Color.gray :
                        Color.blue,
                    lineWidth: 2
                )
                .background(
                    isSelected ? Color.blue :
                        isMyBooking ? Color.gray :
                        Color.clear
                )
                .cornerRadius(6)
                .frame(width: 30, height: 30)
            
            if isBooked {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            } else if isMyBooking {
                Text("\(seatNumber)")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            } else if isSelected {
                Text("\(seatNumber)")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            } else {
                Text("\(seatNumber)")
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
            }
        }
    }
}

struct SeatPage_Previews: PreviewProvider {
    static var previews: some View {
        // Creating a mock user for the preview
        let mockUser = User()
        
        return NavigationView {
            SeatPage(
                movie: movies[0],
                sessionTime: "7:30 PM",
                sessionDate: Date()
            )
            .environmentObject(mockUser)
        }
    }
}

