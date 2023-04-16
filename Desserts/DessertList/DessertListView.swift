//
//  DessertListView.swift
//  Desserts
//
//  Created by Ismail Elmaliki on 4/14/23.
//

import SwiftUI

/// Displays list of desserts in alphabetical order.
///
/// By tapping on any of the desserts, view transtions to `DessertView` which displays details of that dessert.
/// In case backend returns an error, Alert prompt is displayed.
struct DessertListView<T: DessertListViewModel>: View {
	@StateObject var viewModel: T
	
    var body: some View {
		NavigationView {
			/// Display list of desserts
			List(viewModel.desserts) { dessert in
				
				/// Link to each dessert
				NavigationLink {
					DessertView(viewModel: DessertVMImplementer(dessert))
				} label: {
					Text(dessert.name)
						.font(.system(.title3))
				}
				.padding([.top, .bottom], 10)
			}
			.listStyle(.plain)
			.navigationTitle(DessertListStr.navTitle)
			.navigationBarTitleDisplayMode(.large)
			.alert(DessertListStr.alertTitle, isPresented: $viewModel.fetchError, actions: {
				// Do Nothing
				Button(DessertListStr.alertButton) {}
			}, message: {
				Text(DessertListStr.alertMessage)
			})
			.refreshable {
				/// Allow user to refresh list if backend returns an error and existing dessert list is empty.
				if viewModel.desserts.isEmpty {
					viewModel.fetchDesserts()
				}
			}
		}
    }
}

struct DessertListView_Previews: PreviewProvider {
    static var previews: some View {
        DessertListView(viewModel: DessertListVMImplementer())
    }
}
