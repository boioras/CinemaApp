//
//  ContentView.swift
//  CinemaApp
//
//  Created by Ella Gibbs on 5/5/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomePage()
                .tabItem() {
                    Image(systemName: "film")
                    Text("Movies")
                }
            BookingsPage()
                .tabItem() {
                    Image(systemName: "book.fill")
                    Text("Bookings")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
