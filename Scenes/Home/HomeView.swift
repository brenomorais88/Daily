//
//  HomeView.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Topo com data e botão de adicionar
                HStack {
                    Text("Hoje, \(viewModel.todayFormatted)")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        // Navegar para criação de evento
                        print("Adicionar evento")
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                .padding()

                // Lista de eventos
                if viewModel.events.isEmpty {
                    Spacer()
                    Text("Nenhum evento para hoje.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List(viewModel.events) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            VStack(alignment: .leading) {
                                Text(event.title)
                                    .font(.headline)
                                if let time = event.time {
                                    Text(time)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                }

                // TabBar
                Divider()
                HStack {
                    Spacer()
                    Image(systemName: "house.fill")
                        .foregroundColor(.blue)
                    Spacer()
                    Image(systemName: "calendar")
                    Spacer()
                    Image(systemName: "person")
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadTodayEvents()
            }
        }
    }
}
