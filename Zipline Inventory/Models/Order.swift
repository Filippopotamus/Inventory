//
//  Order.swift
//  Zipline Inventory
//
//  Created by Filipe Romancini on 8/21/19.
//  Copyright © 2019 Filipe Romancini. All rights reserved.
//

import UIKit

class Order {
  let id: Int
  let requested: [OrderRequest]
  
  init?(data: [String : Any]) {
    guard let id = data["order_id"] as? Int,
      let requestedData = data["requested"] as? [[String : Any]] else { return nil }
    
    self.id = id
    self.requested = requestedData.compactMap({ (orderRequestData) -> OrderRequest? in
      return OrderRequest(data: orderRequestData)
    })
  }
}


