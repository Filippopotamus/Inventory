//
//  UnfulfileldOrder.swift
//  Zipline Inventory
//
//  Created by Filipe Romancini on 8/21/19.
//  Copyright © 2019 Filipe Romancini. All rights reserved.
//

import UIKit


class UnfulfilledOrder {
  let originalOrderId: Int
  let unfulfilledRequests: [OrderRequest]
  
  init(orderId: Int, requests: [OrderRequest]) {
    self.originalOrderId = orderId
    self.unfulfilledRequests = requests
  }
}
