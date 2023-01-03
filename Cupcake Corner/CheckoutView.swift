//
//  CheckoutView.swift
//  Cupcake Corner
//
//  Created by Thaddeus Dronski on 1/1/23.
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var order: SharedOrder
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    @State private var errorAlertMessage = ""
    @State private var showErrorAlert = false
    
    var body: some View {
            ScrollView {
                VStack {
                    AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 233)
                    
                    Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                        .font(.title)
                    
                    Button("Place Order") {
                        Task {
                            await placeOrder()
                        }
                    }
                        .padding()
                }
            }
            .navigationTitle("Check out")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Thank you!", isPresented: $showingConfirmation) {
                Button("OK") {}
            } message: {
                Text(confirmationMessage)
            }
            .alert("OH NO!", isPresented: $showErrorAlert) {
                Button("OK") {}
            } message: {
                Text(errorAlertMessage)
            }
        }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order.data) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity) x \(SharedOrder.types[decodedOrder.type].lowercased()) cupcakes is on its way"
            showingConfirmation = true
        } catch {
            print("Checkout failed")
            errorAlertMessage = "No interenet connection, order not placed."
            showErrorAlert = true
        }
        
        
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: SharedOrder())
    }
}
