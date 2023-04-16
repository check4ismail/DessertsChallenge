//
//  MealAPIError.swift
//  Desserts
//
//  Created by Ismail Elmaliki on 4/14/23.
//

import Foundation

/// MealAPIError - custom error handling for dessert fetch failures.
///
/// Providing a description of the exact error message. At the moment, errors are only used for debugging purposes and isn't explicitly handled by the UI.
enum MealAPIError: Error, CustomStringConvertible {
	case detailsUnavailable(Error?)
	case listUnavailable(Error?)
	
	var description: String {
		switch self {
		case .detailsUnavailable(let error):
			return String(describing: error)
		case .listUnavailable(let error):
			return String(describing: error)
		}
	}
}
