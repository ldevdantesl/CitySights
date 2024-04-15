//
//  ContentView.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 8.04.2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(BusinessViewModel.self) var businessVM
    @State var showAlert: Bool = false
    @State var showBusinessView: Bool = false
    @State var showUserLocationButton: Bool = true
    
    var body: some View {
        @Bindable var businessVM = businessVM
        VStack(spacing:0){
            
            Text("Search")
                .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                .foregroundStyle(.secondary)
                .hSpacing()
                .padding(15)
                .ifModif(showBusinessView, equal: false)
            
            HStack {
                TextField("Which city are you looking for? ", text: $businessVM.location)
                    .padding()
                    .autocorrectionDisabled()
                    .frame(width: showUserLocationButton ? screen.width - 120 : screen.width - 70, height: 50)
                    .background(.secondary.opacity(0.2), in:.rect(cornerRadius: 15))
                    .onSubmit(of:.text){
                        search()
                    }
                    .onChange(of: businessVM.location) {
                        withAnimation {
                            self.showBusinessView = false
                            if businessVM.location.isEmpty{
                                self.showUserLocationButton = true
                            } else {
                                self.showUserLocationButton = false
                            }
                        }
                    }
                
                Image(systemName: "magnifyingglass.circle.fill")
                    .resizable().scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.blue.opacity(0.8))
                    .onTapGesture {
                        search()
                    }
                if showUserLocationButton{
                    Image(systemName: "mappin.circle.fill")
                        .resizable().scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.blue.opacity(0.8))
                        .onTapGesture {
                            search(with: true)
                        }
                }
            }
            .padding(.horizontal,20)
            .padding()
            
            BusinessListView()
                .ifModif(showBusinessView)
        }
        .alert("Cant find anything for: \(businessVM.location)", isPresented: $showAlert) {
            Button(role:.cancel) {} label: {Text("OK")}
        }
    }
    func search(with userLocation: Bool = false){
        Task{
            do{
                if !userLocation{
                    try await businessVM.getResultsForSearchLocation()
                } else {
                    try await businessVM.getResultsForUserLocation()
                }
                await MainActor.run {
                    withAnimation {
                        self.showBusinessView.toggle()
                    }
                }
                
            } catch{
                await MainActor.run {
                    self.showAlert.toggle()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(BusinessViewModel())
}
