//
//  OrderRequest.swift
//  Zipline Inventory
//
//  Created by Filipe Romancini on 8/21/19.
//  Copyright © 2019 Filipe Romancini. All rights reserved.
//

import UIKit

class OrderRequest {
  let productId: Int
  let quantity: Int
  
  init(productId: Int, quantity: Int) {
    self.productId = productId
    self.quantity = quantity
  }
  
  init?(data: [String : Any]) {
    guard let productId = data["product_id"] as? Int,
      let quantity = data["quantity"] as? Int else { return nil }
    
    self.productId = productId
    self.quantity = quantity
  }
}
