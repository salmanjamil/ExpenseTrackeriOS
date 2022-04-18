//
//  ExpenseListView.swift
//  ExpenseTrackerUI
//
//  Created by Salman Jamil on 16/04/2022.
//

import SwiftUI

enum TransactionType{
    case income, expense
}

struct Transaction: Codable, Hashable, Identifiable {
    let id: Int
    let date: Date
    let amount: Int
    
    private enum CodingKeys : String, CodingKey {
        case id, date = "transcation_date", amount
    }
    var formattedAmount: String {
        return currencyFormatter.string(from: amount as NSNumber)!
    }
    
    var formattedDate: String {
        return dateFormatter.string(from: date)
    }
}

struct TransactionListContainerView: View {
    
    let user: User
    let accountID: Int
    
    let transactiontype: TransactionType
    
    @State private var result: Result<[Transaction], Error>?
    
    
    
    var body: some View {
        switch result {
        case .success(let expenses):
            TransactionListView(transactions: expenses, title: title)
        case .failure(_):
            Text("Error Occured fetching Expenses")
        case .none:
            ProgressView().onAppear(perform: fetchTransaction)
        }
    }
    
    private func fetchTransaction() {
        API.fetchTransactions(type: transactiontype ,user: user, account: accountID) {
            result = $0
        }
    }
    
    var title: String {
        switch transactiontype {
        case .income:
            return "Incomes"
        case .expense:
            return "Expenses"
        }
    }
}

struct TransactionListView: View {
    
    let transactions: [Transaction]
    
    let title: String
    
    var body: some View {
        List (transactions) { exp in
            HStack {
                Text(exp.formattedDate)
                Spacer()
                Text(exp.formattedAmount)
            }
        }.navigationTitle(title)
    }
}

struct ExpenseListView_Previews: PreviewProvider {
    static let expenses = [
        Transaction(id: 1, date: Date.now, amount: 200),
        Transaction(id: 2, date: Date.now , amount: 500)
        
    ]
    
    static var previews: some View {
        TransactionListView(
            transactions: ExpenseListView_Previews.expenses, title: "Expenses"
        )
    }
}
