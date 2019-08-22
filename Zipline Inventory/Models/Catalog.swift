//
//  Catalog.swift
//  Zipline Inventory
//
//  Created by Filipe Romancini on 8/21/19.
//  Copyright © 2019 Filipe Romancini. All rights reserved.
//

import UIKit

class Catalog {
  private var products: [Int : Product] = [:]
  
  init(data: [[String : Any]]) {
    data.forEach { (productData) in
      if let product = Product(data: productData) {
        products[product.id] = product
      }
    }
  }
  
  func allProductIds() -> [Int] {
    return Array(products.keys)
  }
  
  func product(productId: Int) -> Product? {
    return products[productId]
  }
}
