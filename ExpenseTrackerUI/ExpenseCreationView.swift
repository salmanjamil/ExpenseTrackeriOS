//
//  ExpenseCreationView.swift
//  ExpenseTrackerUI
//
//  Created by Salman Jamil on 18/04/2022.
//

import SwiftUI

struct ExpenseType: Codable, Hashable, Identifiable {
    let id: Int
    let title: String
}

struct ExpenseCreationContainerView: View {
    
    @State private var result: Result<[ExpenseType], Error>?
    @State private var amount: Int?
    @State private var selectedType: ExpenseType?
    
    @Environment(\.dismiss) var dismiss
    
    let user: User
    let accountID: Int
    
    var body: some View {
        switch result {
        case .success(let expenseTypes):
            ExpenseCreationView(
                amount: $amount,
                selectedExpenseType: $selectedType,
                expenseTypes: expenseTypes, onCreate: createExpense
            )
        case .failure(_):
            Text("Error Occured Fetching Expense Types")
        case .none:
            ProgressView().onAppear(perform: fetchExpenseTypes)
        }
    }
    
    private func fetchExpenseTypes() {
        API.fetchExpenseTypes(user: user) {
            result = $0
        }
    }
    
    private func createExpense() {
        guard let selectedType = selectedType else {
            return
        }
        
        guard let amount = amount else {
            return
        }
        
        API.createExpense(user: user, accountID: accountID, amount: amount, category: selectedType.id) { _ in
            dismiss()
        }

    }
}

struct ExpenseCreationView: View {
    
    @Binding var amount: Int?
    @State private var description = ""
    @Binding  var selectedExpenseType: ExpenseType?
    
    @Environment(\.dismiss) var dismiss
    
    let expenseTypes: [ExpenseType]
    let onCreate: () -> Void
    var body: some View {
        VStack {
            Text("Create an Expense").bold()
            
            TextField("Enter Amount", value: $amount, format: .number)
                .textFieldStyle(.roundedBorder)
                
            
            HStack {
                Text("Select Category").bold()
                Spacer()
            }
            
            List(expenseTypes) { type in
                Button {
                    selectedExpenseType = type
                } label: {
                    if (type == selectedExpenseType) {
                        Text(type.title).foregroundColor(.green)
                    } else {
                        Text(type.title)
                    }
                }
            }
            
            
            HStack {
                Text("Enter Description")
                    .bold()
                    .padding(.top)
                Spacer()
            }
            ZStack {
                TextEditor(text: $description)
                Text(description).opacity(0).padding()
            }.shadow(radius: 1)
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer()
                
                Button("Create") {
                    onCreate()
                }
            }
            
        }.padding()
        
        
    }
}

struct ExpenseCreationView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseCreationView(
            amount: .constant(nil),
            selectedExpenseType: .constant(nil),
            expenseTypes: [
                ExpenseType(id: 1, title: "Education"),
                ExpenseType(id: 2, title: "Groccery"),
                ExpenseType(id: 3, title: "Utility"),
                ExpenseType(id: 3, title: "Travel"),
                ExpenseType(id: 4, title: "Entertainment")
            ]) {
            
            }
        
    }
}
