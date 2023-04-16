//
//  Strings.swift
//  Desserts
//
//  Created by Ismail Elmaliki on 4/14/23.
//

import Foundation

/// Collection of user-facing strings for all views and their subviews.
///
/// Each view has its own inner `struct` with static NSLocalizedString to account for localization in future releases.
struct Strings {
	struct DessertList {
		static let navTitle = NSLocalizedString("Desserts", comment: "nav-title")
		static let alertTitle = NSLocalizedString("Server Sugar Rush", comment: "server-down")
		static let alertButton = NSLocalizedString("OK", comment: "ok")
		static let alertMessage = NSLocalizedString("Dessert server is having issues due to a massive sugar rush. Try re-loading the list by pulling to refresh.", comment: "server-down-message")
	}
	
	struct DessertView {
		static let instructions = NSLocalizedString("Instructions", comment: "instructions")
		static let ingredients = NSLocalizedString("Ingredients", comment: "ingredients")
	}
}

typealias DessertListStr = Strings.DessertList
typealias DessertViewStr = Strings.DessertView
