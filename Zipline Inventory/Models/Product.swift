//
//  Product.swift
//  Zipline Inventory
//
//  Created by Filipe Romancini on 8/21/19.
//  Copyright © 2019 Filipe Romancini. All rights reserved.
//

import UIKit

class Product : NSObject {
  let name: String
  let mass: Int
  let id: Int
  
  init?(data: [String : Any]) {
    guard let name = data["product_name"] as? String,
      let mass = data["mass_g"] as? Int,
      let id = data["product_id"] as? Int else { return nil }
    
    self.name = name
    self.mass = mass
    self.id = id
  }
  
  override var description: String {
    return name
  }
}
