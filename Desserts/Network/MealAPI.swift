//
//  MealAPI.swift
//  DessertsChallenge
//
//  Created by Ismail Elmaliki on 4/13/23.
//

import Foundation

/// Meal API singleton abstraction to fetch desserts.
///
/// Abstracting MealAPI functionality in order to create future unit tests. Singleton will be used so the MealAPI can be used by View Models or Repositories.
protocol MealAPI {
	/// Shared MealAPI instance.
	static var shared: Self { get }
	
	/// Fetch list of desserts.
	func fetchDessertsList(completion: @escaping ([Dessert]?, MealAPIError?) -> ())
	
	/// Fetch details for specific dessert in order to fetch instructions and ingredients.
	func fetchDessertDetails(id: String, completion: @escaping (DessertDetail?, MealAPIError?) -> ())
}

final class MealProdAPI: MealAPI {
	static let shared = MealProdAPI()
	
	/// Base URL of Meal Database.
	private let baseURL: URL
	
	/// Dessert list URL string path.
	private let listPath: String
	
	/// Shared URL session for performing data tasks.
	private let urlSession: URLSession
	
	private init() {
		baseURL = URL(string: "https://themealdb.com/api/json/v1/1/")!
		listPath = "filter.php?c=Dessert"
		urlSession = URLSession.shared
	}
	
	func fetchDessertsList(completion: @escaping ([Dessert]?, MealAPIError?) -> ()) {
		let listURL = URL(string: listPath, relativeTo: baseURL)!
		let urlRequest = URLRequest(url: listURL)
		
		urlSession.dataTask(with: urlRequest) { data, _, error in
			guard error == nil, let data else {
				completion(nil, .listUnavailable(error))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				let desserts = try decoder.decode(Desserts.self, from: data)
				completion(desserts.meals, nil)
			} catch {
				completion(nil, .listUnavailable(error))
				print("Error fetching list: \(String(describing: error))")
			}
		}.resume()
	}
	
	func fetchDessertDetails(id: String, completion: @escaping (DessertDetail?, MealAPIError?) -> ()) {
		/// Perform lookup using dessert ID.
		let dessertURL = URL(string: "lookup.php?i=\(id)", relativeTo: baseURL)!
		
		urlSession.dataTask(with: URLRequest(url: dessertURL)) { data, _, error in
			guard error == nil, let data else {
				completion(nil, .detailsUnavailable(error))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				let dessertDetails = try decoder.decode(DessertDetails.self, from: data)
				completion(dessertDetails.meals.first!, nil)
			} catch {
				completion(nil, .detailsUnavailable(error))
				print("Error fetching list: \(String(describing: error))")
			}
		}.resume()
	}
}
