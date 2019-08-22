//
//  Shipment.swift
//  Zipline Inventory
//
//  Created by Filipe Romancini on 8/21/19.
//  Copyright © 2019 Filipe Romancini. All rights reserved.
//

import UIKit

class Shipment {
  let order: Order
  let productIds: [Int]
  
  init(order: Order, productIds: [Int]) {
    self.order = order
    self.productIds = productIds
  }
  
  func description() -> String {
    return productIds.description
  }
}
