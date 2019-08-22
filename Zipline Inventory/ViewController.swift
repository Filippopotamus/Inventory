//
//  ViewController.swift
//  Zipline Inventory
//
//  Created by Filipe Romancini on 8/21/19.
//  Copyright © 2019 Filipe Romancini. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  var catalog: Catalog?
  var inventoryManager: InventoryManager?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchCatalog { [weak self] (catalog) in
      self?.catalog = catalog
      self?.inventoryManager = InventoryManager(catalog: catalog)
      MarvinTheDepressedPackagingRobot.theOneAndOnly.invetory = self?.inventoryManager
      self?.simulateRestockRequest()
    }
  }
  
  private func fetchCatalog(completion: @escaping (Catalog) -> Void) {
    Mothership.getCatalog(completion: completion)
  }
  
  private func simulateRestockRequest() {
    Mothership.simulateWebsocketRestockRequest { [weak self] (restock) in
      self?.inventoryManager?.restock(restockList: restock)
      self?.tableView.reloadData()
    }
  }
  
  @IBAction func restockButtonPress(_ sender: Any) {
    simulateRestockRequest()
  }
  
  @IBAction func randomOrderButtonPress(_ sender: Any) {
    Mothership.simulateOrder { [weak self] (order) in
      let (shipments, unfulfilledOrder) = MarvinTheDepressedPackagingRobot.theOneAndOnly.package(order: order)
      
      var text = ""
      for (index, shipment) in shipments.enumerated() {
        let products = self?.inventoryManager?.products(productIds: shipment.productIds) ?? []
        text += "Box \(index + 1): \(products.description)\n"
        
        let weight = products.reduce(0) { $0 + $1.mass }
        text += "Weight: \(weight)g\n"
      }
      
      if let unfulfilled = unfulfilledOrder {
        let ids = unfulfilled.unfulfilledRequests.flatMap({ (request) -> [Int] in
          return Array(repeating: request.productId, count: request.quantity)
        })
        let products = self?.inventoryManager?.products(productIds: ids) ?? []
        
        text += "\nUnfulfilled: \(products.description)"
      }
      
      let alert = UIAlertController(title: "Shipments", message: text, preferredStyle: .alert)
      let action = UIAlertAction(title: "✈️", style: .default, handler: { (action) in
        
      })
      
      alert.addAction(action)
      
      self?.present(alert, animated: true, completion: nil)
      
      self?.tableView.reloadData()
    }
  }
}

// Table View
extension ViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return inventoryManager?.inventoryProductIds().count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // not efficient, would deque cells instead
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
    guard let productId = inventoryManager?.inventoryProductIds()[indexPath.row] else { return cell }
    guard let product = inventoryManager?.product(productId: productId) else { return cell }
    let quantity = inventoryManager?.quantityAvailable(productId: productId) ?? 0
    
    cell.textLabel?.text = product.name
    // Technically mass != weight, but we are not being pedantic here
    cell.detailTextLabel?.text = "Weight: \(product.mass)g  Quantity:\(quantity)"
    
    return cell
  }
}
