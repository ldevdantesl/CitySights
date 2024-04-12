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
                    .frame(width: UIScreen.main.bounds.width - 70, height: 50)
                    .background(.secondary.opacity(0.2), in:.rect(cornerRadius: 15))
                    .onSubmit(of:.text){
                        search()
                    }
                    .onChange(of: businessVM.location) {
                        withAnimation {
                            self.showBusinessView = false
                        }
                    }
                
                Image(systemName: "magnifyingglass.circle.fill")
                    .resizable().scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.blue.opacity(0.8))
                    .onTapGesture {
                        search()
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
    func search(){
        Task{
            do{
                try await businessVM.makeTask()
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
