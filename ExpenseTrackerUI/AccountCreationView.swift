//
//  AccountCreationView.swift
//  ExpenseTrackerUI
//
//  Created by Salman Jamil on 17/04/2022.
//

import SwiftUI

struct AccountCreationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let user: User
    @State private var accountTitle: String = ""
    @State private var startingBalance: Int = 0
    @State private var dailyLimit: Int?
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                Button("Create") {
                    API.createAccount(user: user, title: accountTitle, startingBalance: startingBalance, dailyLimit: dailyLimit) {_ in 
                        dismiss()
                    }
                }
            }.padding()
            TextField("Account Title", text: $accountTitle)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            TextField("Starting Balance", value: $startingBalance, format: .number)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            TextField("Daily Limit", value: $dailyLimit, format: .number)
                .textFieldStyle(.roundedBorder)
                .padding()
            
           Spacer()
            
            
        }
    }
}

struct AccountCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreationView(user:
            User(user_id: 1, token: "")
        )
    }
}
