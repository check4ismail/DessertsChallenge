//
//  DessertView.swift
//  Desserts
//
//  Created by Ismail Elmaliki on 4/14/23.
//

import SwiftUI

/// View that displays dessert details.
///
/// Details include dessert name, instructions and ingredients.
struct DessertView<T: DessertViewModel>: View {
    @StateObject var viewModel: T
	
	var body: some View {
		List {
			/// Dessert title
			HStack() {
				Text(viewModel.dessert.name)
					.font(.system(.title))
					.fontWeight(.bold)
				
				Spacer()
			}
			.listRowBackground(Color.clear)
			.listRowSeparator(.hidden)
			
			/// Ingredients section
			Section(DessertViewStr.ingredients) {
				ForEach(viewModel.ingredients, id: \.self) { ingredient in
					Text(ingredient)
						.padding([.top, .bottom], 10)
				}
			}
			
			/// Instructions section
			Section(DessertViewStr.instructions) {
				ForEach(Array(zip(viewModel.instructions.indices, viewModel.instructions)), id: \.0) { index, instruction in
					/// Display each instruction with step number and instruction text.
					/// Example: 1. Light up the stove.
					Text("\(index + 1).  \(instruction)")
						.padding([.top, .bottom], 10)
				}
			}
		}
		.listStyle(.insetGrouped)
    }
}
