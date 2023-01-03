//
//  AddressView.swift
//  Cupcake Corner
//
//  Created by Thaddeus Dronski on 1/1/23.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: SharedOrder
    var body: some View {
            Form {
                Section {
                    TextField("Name", text: $order.name)
                    TextField("Street Address", text: $order.streetAddress)
                    TextField("City", text: $order.city)
                    TextField("Zip", text: $order.zip)
                }
                Section {
                    NavigationLink {
                        CheckoutView(order: order)
                    } label: {
                        Text("Check out")
                    }
                }
                .disabled(order.hasValidAddress == false)
            }
            .navigationTitle("Delivery details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }


struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: SharedOrder())
    }
}
