//
//  Login.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var router: AppViewRouter

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if viewModel.isCodeSent {
                    Text("Digite o código de verificação:")
                    TextField("6 dígitos", text: $viewModel.verificationCode)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)

                    Button("Verificar") {
                        viewModel.verifyCode {
                            router.isLoggedIn = true
                        }
                    }
                } else {
                    Text("Digite seu número de telefone:")
                    TextField("+55 11 91234-5678", text: $viewModel.phoneNumber)
                        .keyboardType(.phonePad)
                        .textFieldStyle(.roundedBorder)

                    Button("Enviar Código") {
                        viewModel.sendCode()
                    }
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .padding()
            .navigationTitle("Login")
        }
    }
}
