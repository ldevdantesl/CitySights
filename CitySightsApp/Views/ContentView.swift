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
    @State var searchText: String = ""
    @State var categories: [String] = []
    @State var showFilterView: Bool = false
    @State var location: String = ""
    
    @State var popular = false
    @State var deals = false
    
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
                TextField("What are you looking for? ", text: $searchText)
                    .padding()
                    .autocorrectionDisabled()
                    .frame(width:screen.width - 120, height: 50)
                    .background(.secondary.opacity(0.2), in:.rect(cornerRadius: 15))
                    .onSubmit(of:.text){
                        search()
                    }
                    .onChange(of: searchText) {
                        withAnimation {
                            self.showBusinessView = false
                            if searchText.isEmpty{
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
                
                Image(systemName: "arrow.up.and.down.text.horizontal")
                    .resizable().scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.blue.opacity(0.8))
                    .onTapGesture {
                        showFilterView.toggle()
                    }
            }
            .padding(.horizontal,20)
            .padding()
            HStack{
                TextField("Where are you looking for ?", text: $location)
                    .padding()
                    .autocorrectionDisabled()
                    .frame(width: screen.width - 70, height: 50)
                    .background(.secondary.opacity(0.2), in:.rect(cornerRadius: 15))
                    .onSubmit(of:.text){
                        search()
                    }
                    .onChange(of: location) {
                        withAnimation {
                            self.showBusinessView = false
                        }
                    }
                Image(systemName: "mappin.circle.fill")
                    .resizable().scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.blue.opacity(0.8))
                    .onTapGesture {
                        Task{
                            await locateUser()
                        }
                    }
            }
            .ifModif(showUserLocationButton, equal: false)
            BusinessListView()
                .ifModif(showBusinessView)
        }
        .sheet(isPresented: $showFilterView){
            SearchFilterView(popular: $popular, deals: $deals)
                .presentationDetents([.height(200)])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled(upThrough: .height(200)))
                .presentationContentInteraction(.scrolls)
        }
        .alert("Cant find anything for: \(searchText)", isPresented: $showAlert) {
            Button(role:.cancel) {} label: {Text("OK")}
        }
    }
    func locateUser() async {
        guard let loc = businessVM.userLocationArea else {
            print("Cat locate the user.")
            return
        }
        self.location = loc
    }
    func search(){
        Task{
            do{
                if location.isEmpty{
                    await locateUser()
                }
                try await businessVM.getResults(searchText: searchText, attributes: [], categories: categories, location: location)
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
