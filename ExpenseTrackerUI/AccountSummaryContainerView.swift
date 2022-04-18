//
//  AccountSummaryView.swift
//  ExpenseTrackerUI
//
//  Created by Salman Jamil on 16/04/2022.
//

import SwiftUI

struct ExpenseByCategory: Codable, Hashable, Identifiable {
    let categoryTitle: String
    let expense: Int
    var id: String {categoryTitle}
    
    var formattedExpense: String {
        return currencyFormatter.string(from: NSNumber(value: expense))!
    }
}

var currencyFormatter: NumberFormatter  {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    return formatter
} 

var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}


struct AccountSummary: Codable, Hashable {
    let id: Int
    let title: String
    let availableBalance: Int
    let dailyWithdrawlLimit: Int?
    
    let incomeToday: Int
    let incomeThisMonth: Int
    
    let expensesToday: Int
    let expensesThisMonth: Int
    
    let topSpendingCategories: [ExpenseByCategory]
    
    var formattedBalance: String {
        return currencyFormatter.string(from: NSNumber(value: availableBalance))!
    }
    
    var formattedDailyLimit: String {
        if let limit = dailyWithdrawlLimit {
            return currencyFormatter.string(from: NSNumber(value: limit))!
        }
        return "N/A"
    }
    
    var formattedExpensesToday: String {
        return currencyFormatter.string(from: NSNumber(value: expensesToday))!
    }
    
    var formattedExpensesThisMonth: String {
        return currencyFormatter.string(from: NSNumber(value: expensesThisMonth))!
    }
    
    var formattedIncomeToday: String {
        return currencyFormatter.string(from: NSNumber(value: incomeToday))!
    }
    
    var formattedIncomeThisMonth: String {
        return currencyFormatter.string(from: NSNumber(value: incomeThisMonth))!
    }
    
}



struct AccountSummaryView: View {
    let account: AccountSummary
    let user: User
    let onUpdate: () -> Void
    
    @State private var showingExpenseCreationView = false
    
    var body: some View {
        VStack {
            
            VStack(spacing: 5) {
                HStack {
                    Text("Available Balance:")
                    Spacer()
                    Text(account.formattedBalance).bold()
                }
                HStack {
                    Text("Daily Spending Limit:")
                    Spacer()
                    Text(account.formattedDailyLimit)
                }
            }
            
            Divider()
            
            Text("Income Summary").bold().padding()
            
            VStack(spacing: 5) {
                HStack {
                    Text("Income Today:")
                    Spacer()
                    Text(account.formattedIncomeToday)
                }
                HStack {
                    Text("Income This Month:")
                    Spacer()
                    Text(account.formattedIncomeThisMonth)
                }
                NavigationLink  {
                    TransactionListContainerView(user: user, accountID: account.id, transactiontype: .income)
                    
                }
                label: {
                    Text("See All Incomes")
                }.buttonStyle(.automatic)
                .padding()
            }
            
            
           // Divider()
            
            Text("Expense Summary").bold().padding()
            
            VStack(spacing: 5) {
                HStack {
                    Text("Spendings Today:")
                    Spacer()
                    Text(account.formattedExpensesToday)
                }
                HStack {
                    Text("Spendings This Month:")
                    Spacer()
                    Text(account.formattedExpensesThisMonth)
                }
                HStack {
                    NavigationLink  {
                        TransactionListContainerView(user: user, accountID: account.id, transactiontype: .expense)
                        
                    }
                    label: {
                        Text("See All Expenses")
                    }.buttonStyle(.automatic)
                    .padding()
                    Spacer()
                    
                    Button("Create Expense") {
                        showingExpenseCreationView.toggle()
                    }.sheet(isPresented: $showingExpenseCreationView) {
                        onUpdate()
                    } content: {
                        ExpenseCreationContainerView(user: user, accountID: account.id)
                    }

                }
            }
            
            Divider()
            
            Text("Top Spending Categories").bold().padding()
            
            VStack(spacing: 5) {
                ForEach(account.topSpendingCategories) { category in
                    HStack {
                        Text(category.categoryTitle)
                        Spacer()
                        Text(category.formattedExpense)
                    }
                }
            }
            
            Spacer()
            
        }.padding().navigationTitle(account.title)
    }
}

struct AccountSummaryContainerView: View {
    
   // let account: AccountSummary
    let accountID: Int
    let user: User
    
    @State private var result: Result<AccountSummary, Error>?
    
    var body: some View {
        switch result {
        case .success(let account):
            AccountSummaryView(account: account,
                               user: user, onUpdate: fetchAccountSummary)
        case .failure(_):
            Text("Error Occured fetching Summary")
        case .none:
            ProgressView().onAppear(perform: fetchAccountSummary)
        }
        
    }
    
    private func fetchAccountSummary() {
        API.fetchAccountSummary(user: user, accountID: accountID) {
            result = $0
        }
    }
}

struct AccountSummaryView_Previews: PreviewProvider {
    
    static let summary = AccountSummary(
        id: 1,
        title: "Askari Bank",
        availableBalance: 50000,
        dailyWithdrawlLimit: 5000,
        incomeToday: 10,
        incomeThisMonth: 100,
        expensesToday: 2500,
        expensesThisMonth: 18000,
        topSpendingCategories: [
            ExpenseByCategory(categoryTitle: "Education", expense: 3000),
            ExpenseByCategory(categoryTitle: "Travel", expense: 2100)
        ])
    static var previews: some View {
        
        
        AccountSummaryView(account: AccountSummaryView_Previews.summary, user: User(user_id: 2, token: "")){
            
        }
    }
}
