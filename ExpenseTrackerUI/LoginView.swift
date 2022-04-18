//
//  LoginView.swift
//  ExpenseTrackerUI
//
//  Created by Salman Jamil on 17/04/2022.
//

import SwiftUI

class Auhtentication: ObservableObject {
    @Published var user: User?
    
    func setLoggedInUser(user: User) {
        withAnimation {
            self.user = user
        }
    }
}

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @EnvironmentObject var authentication: Auhtentication
    var body: some View {
        VStack {
            Text("Expense Tracker").font(.system(size: 40)).bold()
            
            TextField("username", text: $username)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            SecureField("password", text: $password)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button("Sign In") {
                API.login(usernname: username, password: password) {
                    switch $0 {
                    case .success(let user):
                        authentication.user = user
                    
                    case .failure(let error):
                        username = ""
                        password = ""
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
