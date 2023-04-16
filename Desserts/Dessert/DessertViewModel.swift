//
//  DessertViewModel.swift
//  Desserts
//
//  Created by Ismail Elmaliki on 4/14/23.
//

import Combine
import Foundation
import SwiftUI

/// View Model abstraction for `DessertView`.
protocol DessertViewModel: ObservableObject {
	var dessert: Dessert { get }
	var mealsAPI: MealAPI { get }
	
	/// List of instructions.
	var instructions: [String] { get }
	
	/// List of ingredients.
	var ingredients: [String] { get }
	
	/// Executes request to fetch dessert details.
	///
	/// Before performing a network call, check if dessert details exist. If so, no network call is made to prevent redundant network calls.
	func fetchDetails()
}

/// Implementation of `DessertListViewModel`.
///
/// Because dependency injection for `MealAPI` is supported, this class can be used for unit testing purposes by passing in a mock version of `MealAPI`.
final class DessertVMImplementer: DessertViewModel {
	@Published var dessert: Dessert
	
	let mealsAPI: MealAPI
	
	init(_ dessert: Dessert, mealsAPI: MealAPI = MealProdAPI.shared) {
		self.dessert = dessert
		self.mealsAPI = mealsAPI
		
		fetchDetails()
	}
	
	var instructions: [String] {
		dessert.details?.instructions ?? []
	}
	
	var ingredients: [String] {
		dessert.details?.ingredients ?? []
	}
	
	func fetchDetails() {
		/// Only if details do not exist, proceed with network call.
		/// Otherwise exit function.
		guard dessert.details == nil else {
			return
		}
		
		mealsAPI.fetchDessertDetails(id: dessert.id) { details, error in
			/// Thread-safety to update UI on main thread.
			DispatchQueue.main.async { [weak self] in
				guard let self, let details else {
					return
				}
				
				/// Because `Dessert` is a class, the reference will be updated with dessert details.
				/// This prevents future network calls for any dessert that's viewed the first time.
				self.dessert.details = details
				
				/// Fire an alert to UI of changes.
				self.objectWillChange.send()
			}
		}
	}
}
