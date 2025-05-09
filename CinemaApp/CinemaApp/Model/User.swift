//
//  User.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 6/5/2025.
//

import Foundation

class User: ObservableObject {
    @Published var bookings: [Booking] = []
    
    func cancelBooking(_ booking: Booking) {
        bookings.removeAll { $0.id == booking.id }
    }
}
