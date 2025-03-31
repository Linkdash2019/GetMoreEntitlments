//
//  AppIDView.swift
//  Entitlement
//
//  Created by s s on 2025/3/15.
//
import SwiftUI

struct AppIDEditView : View {
    @StateObject var viewModel : AppIDModel
    
    @State private var errorShow = false
    @State private var errorInfo = ""
    
    var body: some View {
        Form {
            Section {
                Button {
                    Task { await addIncreasedMemoryLimit() }
                } label: {
                    Text("Add Increased Memory Limit")
                }

                Button {
                    Task { await addGC() }
                } label: {
                    Text("GAME_CENTER")
                }

                Button {
                    Task { await addIAA() }
                } label: {
                    Text("INTER_APP_AUDIO")
                }
            } header: {
                Text("Free Developer Account")
            }
            
            Section {
                Button {
                    Task { await addPushNotifications() }
                } label: {
                    Text("Add Push Notifications")
                }
                
                 Button {
                    Task { await addIAP() }
                } label: {
                    Text("IN_APP_PURCHASE")
                }

                Button {
                    Task { await addWallet() }
                } label: {
                    Text("WALLET")
                }
            } header: {
                Text("Paid Developer Account")
            }

            Section {        
                Button {
                    Task { await addMaps() }
                } label: {
                    Text("MAPS")
                }
            } header: {
                Text("Untested")
            }
            
            Section {
                Text(viewModel.result)
                    .font(.system(.subheadline, design: .monospaced))
            } header: {
                Text("Server Response")
            }
        }
        .alert("Error", isPresented: $errorShow){
            Button("OK".loc, action: {
            })
        } message: {
            Text(errorInfo)
        }
        .navigationTitle(viewModel.bundleID)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func addIncreasedMemoryLimit() async {
        do {
            try await viewModel.addIncreasedMemory()
        } catch {
            errorInfo = error.localizedDescription
            errorShow = true
        }

    }

    func addPushNotifications() async {
        do {
            try await viewModel.addEntitlement(entitlement: "PUSH_NOTIFICATIONS")
        } catch {
            errorInfo = error.localizedDescription
            errorShow = true
        }

    }

    func addIAP() async {
        do {
            try await viewModel.addEntitlement(entitlement: "IN_APP_PURCHASE")
        } catch {
            errorInfo = error.localizedDescription
            errorShow = true
        }

    }

    func addGC() async {
        do {
            try await viewModel.addEntitlement(entitlement: "GAME_CENTER")
        } catch {
            errorInfo = error.localizedDescription
            errorShow = true
        }

    }

    func addWallet() async {
        do {
            try await viewModel.addEntitlement(entitlement: "WALLET")
        } catch {
            errorInfo = error.localizedDescription
            errorShow = true
        }

    }

    func addIAA() async {
        do {
            try await viewModel.addEntitlement(entitlement: "INTER_APP_AUDIO")
        } catch {
            errorInfo = error.localizedDescription
            errorShow = true
        }

    }

    func addMaps() async {
        do {
            try await viewModel.addEntitlement(entitlement: "Maps")
        } catch {
            errorInfo = error.localizedDescription
            errorShow = true
        }

    }
}


struct AppIDView : View {
    @StateObject var viewModel : AppIDViewModel
    
    @State private var errorShow = false
    @State private var errorInfo = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ForEach(viewModel.appIDs, id: \.self) { appID in
                        NavigationLink {
                            AppIDEditView(viewModel: appID)
                        } label: {
                            Text(appID.bundleID)
                        }
                    }
                } header: {
                    Text("App IDs")
                }
                
                Section {
                    Button("Refresh") {
                        Task { await refreshButtonClicked() }
                    }
                }
            }
            .alert("Error", isPresented: $errorShow){
                Button("OK".loc, action: {
                })
            } message: {
                Text(errorInfo)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func refreshButtonClicked() async {
        do {
            try await viewModel.fetchAppIDs()
        } catch {
            errorInfo = error.localizedDescription
            errorShow = true
        }
    }
}
