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
            } header: {
                Text("Free Developer Account")
            }
            
            Section {
                Button {
                    Task { await addPushNotifications() }
                } label: {
                    Text("Add Push Notifications")
                }
            } header: {
                Text("Paid Developer Account")
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
            try await viewModel.addPushNotifications()
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
