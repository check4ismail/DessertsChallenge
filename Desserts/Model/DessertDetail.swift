//
//  DessertDetail.swift
//  DessertsChallenge
//
//  Created by Ismail Elmaliki on 4/13/23.
//

import Foundation

/// Dessert details model representation.
///
/// It includes extended dessert details and properties to display to user.
struct DessertDetail: Codable {
	
	/// List of Instructions to make dessert.
	var instructions: [String]
	
	/// List of ingredients with corresponding measurements for dessert.
	var ingredients: [String] = []

	/// Coding keys to match backend representation in order to fetch all required info.
	///
	/// Use struct for customization of `CodingKey`.
	struct DessertDetailKey: CodingKey {
		static let strInstructions = DessertDetailKey(stringValue: "strInstructions")!
		
		static func ingredient(_ index: Int) -> DessertDetailKey {
			return DessertDetailKey(stringValue: "strIngredient\(index)")!
		}
		
		static func measure(_ index: Int) -> DessertDetailKey {
			return DessertDetailKey(stringValue: "strMeasure\(index)")!
		}
		
		var stringValue: String
		
		init?(stringValue: String) {
			self.stringValue = stringValue
		}
		
		var intValue: Int? { return nil }
		
		init?(intValue: Int) {
			return nil
		}
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: DessertDetailKey.self)
		
		/// Format instructions to separate into array.
		instructions = try values.decode(String.self, forKey: .strInstructions).formatInstructions()
		
		/// Parsing ingredients and corresponding measurements.
		var i = 1
		
		while true {
			let ingredient = try values.decode(String.self, forKey: .ingredient(i))
			let measure = try values.decode(String.self, forKey: .measure(i))
			
			/// Once there are no more ingredients, no need to continue loop.
			guard !ingredient.isEmpty && !measure.isEmpty else {
				break
			}
			
			i += 1
			
			/// Example: Milk - 2 ML.
			ingredients.append(ingredient + " - " + measure)
		}
	}
}
