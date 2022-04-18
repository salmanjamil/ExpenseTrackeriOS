//
//  ExpenseTrackerUIApp.swift
//  ExpenseTrackerUI
//
//  Created by Salman Jamil on 16/04/2022.
//

import SwiftUI

@main
struct ExpenseTrackerUIApp: App {
    
    @StateObject var authentication = Auhtentication()
    
    var body: some Scene {
        WindowGroup {
            if let user = authentication.user {
                AccountListView(
                    user: user,
                    accounts: []
                )
            } else {
                LoginView().environmentObject(authentication)
            }
        }
    }
}
