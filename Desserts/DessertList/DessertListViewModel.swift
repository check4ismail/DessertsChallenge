//
//  DessertListViewModel.swift
//  Desserts
//
//  Created by Ismail Elmaliki on 4/14/23.
//

import Combine
import Foundation

/// View model for `DessertListView`.
protocol DessertListViewModel: ObservableObject {
	
	/// Full list of desserts.
	var desserts: [Dessert] { get }
	
	/// Meal API to perform network operations.
	var mealAPI: MealAPI { get }
	
	/// Signals whether or not an error was thrown.
	var fetchError: Bool { set get }
	
	/// Executes request to fetch list of desserts.
	func fetchDesserts()
}

/// Implementation of `DessertListViewModel`.
///
/// Because dependency injection for `MealAPI` is supported, this class can be used for unit testing purposes by passing in a mock version of `MealAPI`.
final class DessertListVMImplementer: DessertListViewModel {
	@Published private(set) var desserts: [Dessert] = []
	@Published var fetchError: Bool = false
	
	let mealAPI: MealAPI
	
	init(_ mealAPI: MealAPI = MealProdAPI.shared) {
		self.mealAPI = mealAPI
		fetchDesserts()
	}
	
	func fetchDesserts() {
		mealAPI.request(.dessertList) { result in
			/// Update variables on main thread for thread-safe UI updates.
			DispatchQueue.main.async { [weak self] in
				guard let self else { return }
				guard let desserts = try? result.get() as? [Dessert] else {
					fetchError = true
					return
				}
				
				self.desserts = desserts
			}
		}
	}
}
