//
//  User.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 6/5/2025.
//

import Foundation

class User: ObservableObject {
    @Published var bookings: [Booking] = []
    
    init(){
        self.bookings = loadBookings()
    }
    
    func cancelBooking(_ booking: Booking) {
        bookings.removeAll { $0.id == booking.id }
        saveBookings(bookings: bookings)
    }
    
    func loadBookings() -> [Booking] {
        do {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent("bookings.json")
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([Booking].self, from: data)
        } catch {
            return []
        }
    }
    
    func saveBookings(bookings: [Booking]) {
        do {
            let data = try JSONEncoder().encode(bookings)
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent("bookings.json")
            try data.write(to: fileURL)
        } catch {
            print("Error saving JSON: \(error)")
        }
    }
}
