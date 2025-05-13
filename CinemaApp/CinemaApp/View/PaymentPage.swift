//
//  PaymentPage.swift
//  CinemaApp
//
//  Created by Ena Debnath on 13/5/2025.
//

import SwiftUI

struct PaymentPage: View {
    let movie: Movie
    let selectedSeats: [Int]
    let sessionTime: String
    let sessionDate: Date
    
    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode
    
    // payment details
    @State private var cardNumber = ""
    @State private var cardHolderName = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    
    // validation states
    @State private var cardNumberError = false
    @State private var cardHolderNameError = false
    @State private var expiryDateError = false
    @State private var cvvError = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var paymentProcessing = false
    @State private var paymentSuccessful = false

    // calculated price
    var totalPrice: Int {
        return selectedSeats.count * 12 // $15 per seat
    }
    
    var isFormValid: Bool {
        return isCardNumberValid() &&
               !cardHolderName.isEmpty &&
               isExpiryDateValid() &&
               isCVVValid()
    }
    
    // MARK: - the actual view
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // booking summary
                bookingSummarySection
                
                // credit card details
                creditCardSection
                
                // payment button
                paymentButtonSection
            }
            .padding()
            .disabled(paymentProcessing)
            .overlay(
                Group {
                    if paymentProcessing {
                        processingOverlay
                    }
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text(paymentSuccessful ? "Success" : "Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if paymentSuccessful {
                            // back to homepage after successful payment
                            confirmBooking()
                        }
                    }
                )
            }
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // booking summary section
    var bookingSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Booking Summary")
                .font(.headline)
            
            HStack(alignment: .top) {
                movie.image
                    .resizable()
                    .frame(width: 80, height: 120)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("\(formattedDate(sessionDate)) • \(sessionTime)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Seats: \(selectedSeats.sorted().map { String($0) }.joined(separator: ", "))")
                        .font(.subheadline)

                    
                    Text("Total: $\(totalPrice).00")
                        .font(.headline)
                        .padding(.top, 4)
                }
            }
            Divider()
        }
    }
    
    // inputting card details section
    var creditCardSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Card Details")
                .font(.headline)
            
            // card number field
            VStack(alignment: .leading, spacing: 4) {
                Text("Card Number")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("1234 5678 9012 3456", text: $cardNumber)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .onChange(of: cardNumber) { _ in
                        cardNumberError = !isCardNumberValid() && !cardNumber.isEmpty
                        
                        // card number will be formatted with spaces
                        let numbers = cardNumber.filter { $0.isNumber }
                        let formatted = formatCardNumber(numbers)
                        if formatted != cardNumber {
                            cardNumber = formatted
                        }
                    }
                
                if cardNumberError {
                    Text("Please enter a valid 16-digit card number")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            // card holder name field
            VStack(alignment: .leading, spacing: 4) {
                Text("Cardholder Name")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("Name Surname", text: $cardHolderName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .onChange(of: cardHolderName) { _ in
                        cardHolderNameError = cardHolderName.isEmpty
                    }
                
                if cardHolderNameError {
                    Text("Please enter the cardholder's name")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            // row with expiry date and CVV fields
            HStack(spacing: 12) {
                // expiry date field
                VStack(alignment: .leading, spacing: 4) {
                    Text("Expiry Date")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("MM/YY", text: $expiryDate)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                        .onChange(of: expiryDate) { _ in
                            expiryDateError = !isExpiryDateValid() && !expiryDate.isEmpty
                            
                            // expiry date is formatted with a slash in between
                            let numbers = expiryDate.filter { $0.isNumber }
                            let formatted = formatExpiryDate(numbers)
                            if formatted != expiryDate {
                                expiryDate = formatted
                            }
                        }
                    
                    if expiryDateError {
                        Text("Invalid expiry date")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // CVV field
                VStack(alignment: .leading, spacing: 4) {
                    Text("CVV")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("123", text: $cvv)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                        .onChange(of: cvv) { _ in
                            cvvError = !isCVVValid() && !cvv.isEmpty
                            
                            // limits CVV's input count to 3 digits
                            if cvv.count > 3 {
                                cvv = String(cvv.prefix(3))
                            }
                        }
                    
                    if cvvError {
                        Text("3 digits required")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            
            Divider()
        }
    }
    
    var paymentButtonSection: some View {
        VStack(spacing: 16) {
            // total amount
            HStack {
                Text("Total Payment")
                    .font(.headline)
                Spacer()
                Text("$\(totalPrice).00")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .padding(.vertical, 4)
            
            // payment button
            Button(action: {
                processPayment()
            }) {
                Text("Complete Payment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!isFormValid)
        }
    }
    
    var processingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                
                Text("Processing Payment...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(30)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    // MARK: - functions for validation
    
    private func isCardNumberValid() -> Bool {
        let digits = cardNumber.filter { $0.isNumber }
        return digits.count == 16
    }
    
    private func isExpiryDateValid() -> Bool {
        let components = expiryDate.split(separator: "/")
        
        guard components.count == 2,
              let month = Int(components[0]),
              let year = Int(components[1]) else {
            return false
        }
        
        let currentYear = Calendar.current.component(.year, from: Date()) % 100
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        // basic validation - month between 1-12 and year >= current year
        return month >= 1 && month <= 12 &&
               (year > currentYear || (year == currentYear && month >= currentMonth))
    }
    
    private func isCVVValid() -> Bool {
        return cvv.count == 3 && cvv.allSatisfy { $0.isNumber }
    }
    
    // MARK: - functionas for formatting
    
    private func formatCardNumber(_ string: String) -> String {
        var formatted = ""
        for (index, char) in string.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted.append(char)
            
            // limited to 16 digits as per card number regulations; which is 19 chars with spaces
            if formatted.count >= 19 {
                break
            }
        }
        return formatted
    }
    
    private func formatExpiryDate(_ string: String) -> String {
        if string.count > 2 {
            let month = string.prefix(2)
            let year = string.dropFirst(2).prefix(2)
            return "\(month)/\(year)"
        } else {
            return string
        }
    }
    
    // MARK: - action functions
    
    private func processPayment() {
        // start processing animation
        paymentProcessing = true
        
        // simulate payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if simulatePaymentSuccess() {
                // successful
                paymentSuccessful = true
                alertMessage = "Payment successful! Your booking is confirmed."
            } else {
                // failed
                paymentSuccessful = false
                alertMessage = "Payment failed. Please check your card details and try again."
            }
            
            paymentProcessing = false
            showingAlert = true
        }
    }
    
    private func simulatePaymentSuccess() -> Bool {
        // for demo purposes, simulating a payment success/failure
        // this is to be replaced with actual payment gateway integration
        let lastFourDigits = cardNumber.filter { $0.isNumber }.suffix(4)
        
        // payment succeeds if last digit is even (for demo)
        if let lastDigit = Int(String(lastFourDigits.last ?? "0")) {
            return lastDigit % 2 == 0
        }
        
        return false
    }
    
    // MARK: - helper functions
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // MARK: - booking confirmation
    
    private func confirmBooking() {
        // creating seat objects from selected seat numbers
        let seats = selectedSeats.map { Seat(number: $0, isBooked: true) }
        
        // creating new booking
        let newBooking = Booking(
            movie: movie,
            seats: seats,
            sessionDate: sessionDate,
            sessionTime: sessionTime
        )
        
        // adding to user's bookings
        user.bookings.append(newBooking)
        
        // saving bookings
        user.saveBookings(bookings: user.bookings)
        
        // dismiss, so that screen goes bakc - seat selection can be updated and thus blocks possibility of repeat booking payment
        presentationMode.wrappedValue.dismiss()
    }
}

struct PaymentPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaymentPage(
                movie: movies[0],
                selectedSeats: [3, 4, 5],
                sessionTime: "7:30 PM",
                sessionDate: Date()
            )
            .environmentObject(User())
        }
    }
}
