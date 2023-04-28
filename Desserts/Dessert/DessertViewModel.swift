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
	var imageLoader: ImageLoader { get }
	
	var image: UIImage? { get }
	
	/// List of instructions.
	var instructions: [String] { get }
	
	/// List of ingredients.
	var ingredients: [String] { get }
	
	/// Executes request to fetch dessert details.
	///
	/// Before performing a network call, check if dessert details exist. If so, no network call is made to prevent redundant network calls.
	func fetchDetails()
	
	/// Executes request to load dessert image.
	func fetchImage()
}

/// Implementation of `DessertListViewModel`.
///
/// Because dependency injection for `MealAPI` is supported, this class can be used for unit testing purposes by passing in a mock version of `MealAPI`.
/// Same applies to `ImageLoader`.
final class DessertVMImplementer: DessertViewModel {
	@Published var dessert: Dessert
	@Published var image: UIImage?
	
	let mealsAPI: MealAPI
	let imageLoader: ImageLoader
	
	init(
		_ dessert: Dessert,
		imageLoader: ImageLoader = ImageProdLoader.shared,
		mealsAPI: MealAPI = MealProdAPI.shared
	) {
		self.dessert = dessert
		self.imageLoader = imageLoader
		self.mealsAPI = mealsAPI
		
		fetchImage()
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
		
		mealsAPI.request(.dessertDetails(dessert.id)) { result in
			/// Thread-safety to update UI on main thread.
			DispatchQueue.main.async { [weak self] in
				guard let self, let details = try? result.get() as? DessertDetail else {
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
	
	func fetchImage() {
		imageLoader.downloadImage(dessert) { image in
			/// Thread-safety to update UI on main thread.
			DispatchQueue.main.async {
				self.image = image
			}
		}
	}
}
