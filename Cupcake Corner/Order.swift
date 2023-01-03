//
//  Order.swift
//  Cupcake Corner
//
//  Created by Thaddeus Dronski on 1/1/23.
//

import SwiftUI


@dynamicMemberLookup
class SharedOrder: ObservableObject {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    @Published var data = Order()
    
    subscript<T>(dynamicMember keypath: KeyPath<Order, T>) -> T {
        data[keyPath: keypath]
    }
    subscript<T>(dynamicMember keypath: WritableKeyPath<Order, T>) -> T {
        get {
            data[keyPath: keypath]
        }
        
        set {
            data[keyPath: keypath] = newValue
        }
    }
}

struct Order: Codable {
    
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty || streetAddress.trimmingCharacters(in: .whitespaces).isEmpty
            || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty {
                return false
        }
        
        return true
    }
    
    var cost: Double {
        //$2 per cake
        var cost = Double(quantity) * 2
        
        //complicated cakes cost more
        cost += (Double(type) / 2)
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
             cost += Double(quantity) / 2
        }
         return cost
    }
}

//class Order: ObservableObject, Codable {
//
//    enum CodingKeys: CodingKey {
//        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
//    }
//
//    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
//
//    @Published var type = 0
//    @Published var quantity = 3
//
//    @Published var specialRequestEnabled = false {
//        didSet {
//            if specialRequestEnabled == false {
//                extraFrosting = false
//                addSprinkles = false
//            }
//        }
//    }
//
//    @Published var extraFrosting = false
//    @Published var addSprinkles = false
//
//    @Published var name = ""
//    @Published var streetAddress = ""
//    @Published var city = ""
//    @Published var zip = ""
//
//    var hasValidAddress: Bool {
//        if name.trimmingCharacters(in: .whitespaces).isEmpty || streetAddress.trimmingCharacters(in: .whitespaces).isEmpty
//            || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty {
//                return false
//        }
//
//        return true
//    }
//
//    var cost: Double {
//        //$2 per cake
//        var cost = Double(quantity) * 2
//
//        //complicated cakes cost more
//        cost += (Double(type) / 2)
//
//        // $1/cake for extra frosting
//        if extraFrosting {
//            cost += Double(quantity)
//        }
//
//        // $0.50/cake for sprinkles
//        if addSprinkles {
//             cost += Double(quantity) / 2
//        }
//         return cost
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        type = try container.decode((Int.self), forKey: .type)
//        quantity = try container.decode(Int.self, forKey: .quantity)
//
//        extraFrosting =  try container.decode(Bool.self, forKey: .extraFrosting)
//        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
//
//        name = try container.decode(String.self, forKey: .name)
//        streetAddress = try container.decode(String.self, forKey: .streetAddress)
//        city = try container.decode(String.self, forKey: .city)
//        zip = try container.decode(String.self, forKey: .zip)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(type, forKey: .type)
//        try container.encode(quantity, forKey: .quantity)
//
//        try container.encode(extraFrosting, forKey: .extraFrosting)
//        try container.encode(addSprinkles, forKey: .addSprinkles)
//
//        try container.encode(name, forKey: .name)
//        try container.encode(streetAddress, forKey: .streetAddress)
//        try container.encode(city, forKey: .city)
//        try container.encode(zip, forKey: .zip)
//    }
//
//    init() { }
//
//}
