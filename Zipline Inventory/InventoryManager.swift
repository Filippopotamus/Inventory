//
//  InventoryManager.swift
//  Zipline Inventory
//
//  Created by Filipe Romancini on 8/21/19.
//  Copyright © 2019 Filipe Romancini. All rights reserved.
//

import UIKit

class InventoryManager {
  let catalog: Catalog
  
  // Inventory of [ProductId : Quantity]
  private var inventory: [Int : Int] = [:]
  
  init(catalog: Catalog) {
    self.catalog = catalog
    
    // Add all catalog products to inventory
    catalog.allProductIds().forEach { (productId) in
      inventory[productId] = 0
    }
  }
  
  func restock(restockList: [Restock]) {
    restockList.forEach { (restock) in
      addProduct(id: restock.productId, quantity: restock.quantity)
    }
  }
  
  func pullProduct(id: Int, quantity: Int) -> Int {
    let available = quantityAvailable(productId: id)
    let allowed = min(quantity, available)
    
    inventory[id, default: 0] -= allowed
    
    return allowed
  }

  func inventoryProductIds() -> [Int] {
    return Array(inventory.keys)
  }
  
  func quantityAvailable(productId: Int) -> Int {
    return inventory[productId] ?? 0
  }
  
  func product(productId: Int) -> Product? {
    return catalog.product(productId: productId)
  }
  
  func products(productIds: [Int]) -> [Product] {
    return productIds.compactMap({ (id) -> Product? in
      return product(productId: id)
    })
  }
  
  // Internal
  
  private func addProduct(id: Int, quantity: Int) {
    inventory[id, default: 0] += quantity
  }
  
}
