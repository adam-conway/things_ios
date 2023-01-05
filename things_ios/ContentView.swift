//
//  ContentView.swift
//  things_ios
//
//  Created by Adam Conway on 1/3/23.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    @State private var isSubmittingForm: Bool = false
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Credentials")) {
                    TextField("Email", text: $username) // Add validation for being proper email
                    SecureField("Password", text: $password) // Add validation for passwords matching, security toggle
                    SecureField("Password", text: $passwordConfirmation) // Add validation for passwords matching, security toggle
                }
                Button("Sign up") {
                    isSubmittingForm = true
                    
                    // API functionality should be extracted from the view
                    var request = URLRequest(url: URL(string: "http://localhost:3000/users")!) // Replace this with environment variable
                    request.httpMethod = "POST"
                    let json: [String: Any] = ["user": ["email": username,"password": password]]
                    
                    if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        request.httpBody = jsonData
                    }
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        isSubmittingForm = false
                        guard let data = data, let response = response, error == nil else {
                            print("Something went wrong: error: \(error?.localizedDescription ?? "unkown error")")
                            return
                        }
                        
                        print(response)
                        print(String(decoding: data, as: UTF8.self))
                    }
                    
                    task.resume()
                    // Add something to indicate activity happening
                }.disabled(isSubmittingForm)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
