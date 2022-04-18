//
//  API.swift
//  ExpenseTrackerUI
//
//  Created by Salman Jamil on 16/04/2022.
//

import Foundation

let baseURL = "http://172.20.10.3:8000/"


struct User: Codable, Hashable {
    let user_id: Int
    let token: String
}

struct UserCredentials: Codable, Hashable {
    let username: String
    let password: String
}

struct API {
    
    static func fetchAccountList(user: User, completion: @escaping(Result<[Account], Error>) -> Void ) {
        let req = URL(string: baseURL + "accounts/").flatMap { value in
            URLRequest(url: value)
        }
        
        guard var request = req else {
            return
        }
        
        request.httpMethod = "GET"
        request.setValue("Token \(user.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode([Account].self, from: data)
                    completion(.success(result))
                    return
                } catch let error {
                    completion(.failure(error))
                    return
                }
                
            }
        }.resume()
    }
    
    static func fetchAccountSummary(user: User, accountID: Int, completion: @escaping (Result<AccountSummary, Error>) -> Void) {
        let req = URL(string: baseURL + "accountSummary/\(accountID)").flatMap { value in
            URLRequest(url: value)
        }
        
        guard var request = req else {
            return
        }
        
        
        request.httpMethod = "GET"
        request.setValue("Token \(user.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(AccountSummary.self, from: data)
                    completion(.success(result))
                    return
                } catch let error {
                    completion(.failure(error))
                    return
                }
                
            }
        }.resume()
    }
    
    static func login(usernname: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: baseURL + "login/") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        
        
        let encoder = JSONEncoder()
        let body = try! encoder.encode(
            UserCredentials(username: usernname, password: password)
        )
        

        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } catch (let error){
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    static func fetchTransactions(type: TransactionType = .expense, user: User, account: Int, completion: @escaping (Result <[Transaction], Error>) -> Void) {
        
        let endPoint: String
        switch type {
        case .income:
            endPoint = "income/"
        case .expense:
            endPoint = "expense/"
        }
        
        let req = URL(string: baseURL + "\(endPoint)\(account)").flatMap { value in
            URLRequest(url: value)
        }
        
        guard var request = req else {
            return
        }
        
        
        request.httpMethod = "GET"
        request.setValue("Token \(user.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.timeZone = .current
                formatter.locale = .current
                decoder.dateDecodingStrategy = .formatted(formatter)
                do {
                    let result = try decoder.decode([Transaction].self, from: data)
                    completion(.success(result))
                    return
                } catch let error {
                    completion(.failure(error))
                    return
                }
                
            }
        }.resume()
    }
    
    static func createAccount(user: User, title: String, startingBalance: Int, dailyLimit: Int?, completion: @escaping(Result<Account, Error>) -> Void) {
        var data = [
            "name" : title,
            "balance": startingBalance,
            "owner": user.user_id
        ] as [String : Any]
        
        if let dailyLimit = dailyLimit {
            data["daily_withdrawl_limit"] = dailyLimit
        }
        
        guard let url = URL(string: baseURL + "accounts/") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        
        
        let body = try! JSONSerialization.data(withJSONObject: data, options: [])
        

        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(user.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(Account.self, from: data)
                    completion(.success(result))
                    return
                } catch let error {
                    completion(.failure(error))
                    return
                }
                
            }
        }.resume()
    }
    
    static func fetchExpenseTypes(user: User, completion : @escaping (Result<[ExpenseType], Error>) -> Void) {
        let req = URL(string: baseURL + "expenseTypes/").flatMap { value in
            URLRequest(url: value)
        }
        
        guard var request = req else {
            return
        }
        
        
        request.httpMethod = "GET"
        request.setValue("Token \(user.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode([ExpenseType].self, from: data)
                    completion(.success(result))
                    return
                } catch let error {
                    completion(.failure(error))
                    return
                }
                
            }
        }.resume()
    }
    
    static func createExpense(user: User, accountID: Int, amount: Int, category: Int, completion: @escaping (Result<Transaction, Error>) -> Void) {
        
        let req = URL(string: baseURL + "expense/").flatMap { value in
            URLRequest(url: value)
        }
        
        guard var request = req else {
            return
        }
        
        
        request.httpMethod = "POST"
        request.setValue("Token \(user.token)", forHTTPHeaderField: "Authorization")
        
        let data = [
            "amount": amount,
            "account": accountID,
            "expense_type": category
        ]
        
        let body = try! JSONSerialization.data(withJSONObject: data, options: [])
        

        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(user.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(Transaction.self, from: data)
                    completion(.success(result))
                    return
                } catch let error {
                    completion(.failure(error))
                    return
                }
                
            }
        }.resume()
        
    }
}
