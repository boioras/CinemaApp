//
//  Booking.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 6/5/2025.
//

import Foundation

struct Seat: Identifiable, Hashable {
    var id = UUID()
    var number: Int
    var isBooked: Bool
}

struct Booking: Identifiable, Hashable {
    var id = UUID()
    var movie: Movie
    var seats: [Seat]
    var sessionDate: Date
    var sessionTime: String
}
