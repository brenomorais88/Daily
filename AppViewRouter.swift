//
//  AppViewRouter.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import Foundation
import FirebaseAuth

class AppViewRouter: ObservableObject {
    @Published var isLoggedIn: Bool = Auth.auth().currentUser != nil

    init() {
        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                self.isLoggedIn = user != nil
            }
        }
    }
}
