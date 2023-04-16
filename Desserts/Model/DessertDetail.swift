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
	enum DessertDetailKey: CodingKey {
		case strInstructions
		
		case strIngredient1
		case strIngredient2
		case strIngredient3
		case strIngredient4
		case strIngredient5
		case strIngredient6
		case strIngredient7
		case strIngredient8
		case strIngredient9
		case strIngredient10
		case strIngredient11
		case strIngredient12
		case strIngredient13
		case strIngredient14
		case strIngredient15
		case strIngredient16
		case strIngredient17
		case strIngredient18
		case strIngredient19
		case strIngredient20
		
		
		case strMeasure1
		case strMeasure2
		case strMeasure3
		case strMeasure4
		case strMeasure5
		case strMeasure6
		case strMeasure7
		case strMeasure8
		case strMeasure9
		case strMeasure10
		case strMeasure11
		case strMeasure12
		case strMeasure13
		case strMeasure14
		case strMeasure15
		case strMeasure16
		case strMeasure17
		case strMeasure18
		case strMeasure19
		case strMeasure20
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: DessertDetailKey.self)
		
		/// Format instructions to separate into array.
		instructions = try values.decode(String.self, forKey: .strInstructions).formatInstructions()
		
		/// Parsing ingredients and corresponding measurements.
		for i in 1...20 {
			let ingredientKey = DessertDetailKey(stringValue: "strIngredient\(i)")
			let ingredient = try values.decode(String.self, forKey: ingredientKey!)
			
			let measureKey = DessertDetailKey(stringValue: "strMeasure\(i)")
			let measure = try values.decode(String.self, forKey: measureKey!)
			
			/// Once there are no more ingredients, no need to continue loop.
			guard !ingredient.isEmpty && !measure.isEmpty else {
				break
			}
			
			/// Example: Milk - 2 ML.
			ingredients.append(ingredient + " - " + measure)
		}
	}
}
