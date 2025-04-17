//
//  LoginViewModel.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var phoneNumber = ""
    @Published var verificationCode = ""
    @Published var verificationID: String?
    @Published var isCodeSent = false
    @Published var isLoggedIn = false
    @Published var errorMessage: String?

    init() {
        self.isLoggedIn = AuthService.shared.currentUser != nil
    }

    func sendCode() {
        AuthService.shared.sendVerificationCode(to: phoneNumber) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let id):
                    self.verificationID = id
                    self.isCodeSent = true

                case .failure(let error):
                    print("ERRO Firebase Auth:", error)
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func verifyCode() {
        guard let verificationID = verificationID else { return }

        AuthService.shared.verifyCode(verificationID: verificationID, code: verificationCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.isLoggedIn = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func verifyCode(onSuccess: @escaping () -> Void) {
        guard let verificationID = verificationID else { return }

        AuthService.shared.verifyCode(verificationID: verificationID, code: verificationCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.isLoggedIn = true
                    onSuccess()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
