//
//  MarvinTheDepressedPackagingRobot.swift
//  Zipline Inventory
//
//  Created by Filipe Romancini on 8/21/19.
//  Copyright © 2019 Filipe Romancini. All rights reserved.
//

import UIKit

// Marvin gives you back the list of shipments, and any unfulfilled (like himself) orders
typealias MarvinsPackagingOutput = ([Shipment], UnfulfilledOrder?)

// Marvin comes back with a the products available and the number of products missing
typealias MarvinsOrderGrabbingOutput = ([Int], Int)

class MarvinTheDepressedPackagingRobot {
  // Mavin is a singleton, there is no one quite like him
  static let theOneAndOnly = MarvinTheDepressedPackagingRobot()
  
  var invetory: InventoryManager?
  
  func package(order: Order) -> MarvinsPackagingOutput {
    // [productId]
    var fulfilled: [Int] = []
    
    // [productId : quantity]
    var unfulfilled: [Int: Int] = [:]
    
    // Send marving to confusingly grab blood related products, as he himself has no use for
    for request in order.requested {
      let (productsGrabbed, missingQuantity) = unenthusiasticallyGrabItemsFromShelves(orderRequest: request)
      fulfilled.append(contentsOf: productsGrabbed)
      if missingQuantity > 0 {
        unfulfilled[request.productId] = (unfulfilled[request.productId] ?? 0) + missingQuantity
      }
    }
    
    // Marvin now has a job he actually enjoys, playing tetris with human medical supplies (he is not very efficient though)
    let shipments = pleasePlaceItemsInBoxesMarvinAndStopPlayingWithBlood(itemIds: fulfilled, order: order)
    
    if unfulfilled.count == 0 {
      return (shipments, nil)
    }
    
    let unfulfilledOrder = prepareUnfulfilledOrder(itemsAndQuantities: unfulfilled, originalOrder: order)
    
    return (shipments, unfulfilledOrder)
  }
  

  private func unenthusiasticallyGrabItemsFromShelves(orderRequest: OrderRequest) -> MarvinsOrderGrabbingOutput {
    let amountGrabbed = invetory?.pullProduct(id: orderRequest.productId, quantity: orderRequest.quantity) ?? 0
    let missing = orderRequest.quantity - amountGrabbed
    
    return (Array(repeating: orderRequest.productId, count: amountGrabbed), missing)
  }
  
  private func pleasePlaceItemsInBoxesMarvinAndStopPlayingWithBlood(itemIds: [Int], order: Order) -> [Shipment] {
    var products: [Product] = invetory?.products(productIds: itemIds) ?? []
    
    // Marvin likes sorting items by weight
    products = products.sorted(by: { (a, b) -> Bool in
      a.mass < b.mass
    })
    
    var shipments: [Shipment] = []
    
    while !products.isEmpty {
      var boxItems: [Int] = []
      var totalWeight: Int = 0
      
      // Marvin knows to do it in reverse. His reasons are 2-fold:
      // 1: He likes doing heaviest first
      // 2: He knows better not to takes items from bellow the statck of items, or they will come *crashing* down
      for index in (0..<products.count).reversed() {
        let product = products[index]
        if totalWeight + product.mass <= ZipConstants.weightLimit {
          boxItems.append(product.id)
          totalWeight += product.mass
          products.remove(at: index)
        }
      }
      
      let shipment = Shipment(order: order, productIds: boxItems)
      shipments.append(shipment)
    }
    
    return shipments
  }
  
  // This is serious business for Marvin, no jokes here
  private func prepareUnfulfilledOrder(itemsAndQuantities: [Int:Int], originalOrder: Order) -> UnfulfilledOrder {
    let orderRequests: [OrderRequest] = itemsAndQuantities.map { (item, quantity) -> OrderRequest in
      return OrderRequest(productId: item, quantity: quantity)
    }
    
    return UnfulfilledOrder(orderId: originalOrder.id, requests: orderRequests)
  }
}
