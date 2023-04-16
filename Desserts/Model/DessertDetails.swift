//
//  DessertDetails.swift
//  DessertsChallenge
//
//  Created by Ismail Elmaliki on 4/13/23.
//

import Foundation

/// List of `Dessert`.
///
/// Explicitly used to map JSON from backend to fetch list of desserts.
struct DessertDetails: Codable {
	let meals: [DessertDetail]
}
