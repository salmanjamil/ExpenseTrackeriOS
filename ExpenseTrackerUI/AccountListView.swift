//
//  AccountListView.swift
//  ExpenseTrackerUI
//
//  Created by Salman Jamil on 16/04/2022.
//

import SwiftUI

struct Account: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let balance: Int
    

    
    var formattedBalanace: String {
        return currencyFormatter.string(from: balance as NSNumber)!
    }
}

struct AccountListView: View {
    let user: User
    let accounts: [Account]
    
    @State private var showingCreationView = false
    @State private var result: Result<[Account], Error>?
    
    var body: some View {
        switch result {
        case .success(let accounts):
            NavigationView {
                List (accounts) { account in
                    NavigationLink {
                        AccountSummaryContainerView(accountID: account.id, user: user)
                    } label: {
                        HStack {
                            Text(account.name)
                            Spacer()
                            Text(account.formattedBalanace)
                        }
                    }
                }
                .navigationTitle("Accounts")
                .onAppear(perform: fetchAccounts)
                .toolbar {
                    Button("Add Account") {
                        showingCreationView.toggle()
                    }.sheet(isPresented: $showingCreationView) {
                        fetchAccounts()
                    } content: {
                        AccountCreationView(user: user)
                    }

                }
            }
        case .failure(_):
            Text("Error Occured Fetching Accounts")
        case .none:
            ProgressView().onAppear(perform: fetchAccounts)
        }
    }
    
    private func fetchAccounts() {
        API.fetchAccountList(user: user) {
            result = $0
        }
    }
}

struct AccountListView_Previews: PreviewProvider {
    static var previews: some View {
        AccountListView(
            user: User(user_id: 1, token: "d7e744a0375b207c62f4664cd791894b05064f01"),
            accounts: [
            Account(id: 1, name: "Askari Back", balance: 30000),
            Account(id: 2, name: "SCB", balance: 46000)
        ])
    }
}
