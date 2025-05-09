//
//  HomeView.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isCreatingEvent = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Topo com data e botão de adicionar
                HStack {
                    Text("Hoje, \(DataHelpers.todayFormatted)")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        isCreatingEvent = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .background(
                        NavigationLink(
                            destination: EventDetailView(),
                            isActive: $isCreatingEvent,
                            label: { EmptyView() }
                        )
                        .hidden()
                    )
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
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadTodayEvents()
            }
        }
    }
}
