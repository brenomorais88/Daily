//
//  ProfileView.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var router: AppViewRouter

    var body: some View {
        VStack(spacing: 20) {
            Text("Perfil do Usuário")
                .font(.title)

            Button("Sair da conta") {
                AuthService.shared.logout()
                router.isLoggedIn = false
            }
            .foregroundColor(.red)
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
