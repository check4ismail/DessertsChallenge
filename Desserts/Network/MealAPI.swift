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
	
	/// Perform Meal network request.
	func request(_ type: MealRequestType, completion: @escaping (Result<any Codable, MealAPIError>) -> ())
}

/// Meal Network Request Type - for specifying network request action.
///
/// Each request action has its own `URL` and `MealAPIError`.
enum MealRequestType {
	case dessertList
	case dessertDetails(String)
	
	static let baseURL = URL(string: "https://themealdb.com/api/json/v1/1/")!
	static let listPath = "filter.php?c=Dessert"
	
	var url: URL {
		switch self {
		case .dessertList:
			return URL(string: MealRequestType.listPath, relativeTo: MealRequestType.baseURL)!
		case .dessertDetails(let id):
			return URL(string: "lookup.php?i=\(id)", relativeTo: MealRequestType.baseURL)!
		}
	}
	
	func mealError(with error: Error?) -> MealAPIError {
		switch self {
		case .dessertList:
			return .listUnavailable(error)
		case .dessertDetails(_):
			return .detailsUnavailable(error)
		}
	}
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
	
	func request(_ type: MealRequestType, completion: @escaping (Result<any Codable, MealAPIError>) -> ()) {
		urlSession.dataTask(with: URLRequest(url: type.url)) { data, _, error in
			guard error == nil, let data else {
				completion(.failure(type.mealError(with: error)))
				return
			}
			
			do {
				switch type {
				case .dessertList:
					let desserts: Desserts = try ClientMapper.decode(data)
					completion(.success(desserts.meals))
				case .dessertDetails(_):
					let dessertDetails: DessertDetails = try ClientMapper.decode(data)
					completion(.success(dessertDetails.meals.first!))
				}
			} catch {
				completion(.failure(type.mealError(with: error)))
				print("Request error: \(String(describing: error))")
			}
		}.resume()
	}
}
