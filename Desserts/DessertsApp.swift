//
//  DessertsApp.swift
//  Desserts
//
//  Created by Ismail Elmaliki on 4/13/23.
//

import SwiftUI

@main
struct DessertsApp: App {
	var body: some Scene {
        WindowGroup {
			DessertListView(viewModel: DessertListVMImplementer())
        }
    }
}
