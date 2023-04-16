//
//  Dessert.swift
//  DessertsChallenge
//
//  Created by Ismail Elmaliki on 4/13/23.
//

import Foundation

/// Dessert model representation.
class Dessert: Codable, Identifiable {
	
	/// Name of dessert.
	let name: String
	
	/// Unique identifier - important for fetching dessert specific information.
	let id: String
	
	/// Sub-model, which includes more dessert details.
	var details: DessertDetail?
	
	enum DessertKey: CodingKey {
		case strMeal, idMeal
	}
	
	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: DessertKey.self)
		name = try values.decode(String.self, forKey: .strMeal)
		id = try values.decode(String.self, forKey: .idMeal)
	}
}
