//
//  ContentView.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 8.04.2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(BusinessViewModel.self) var businessVM
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State var showAlert: Bool = false
    @State var showBusinessView: Bool = false
    @State var showUserLocationButton: Bool = true
    @State var showFilterView: Bool = false
    
    @State var searchText: String = ""
    @State var categories: [String] = []
    @State var location: String = ""
    @State var limit: Int = 10
    
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
                    .focused($isTextFieldFocused)
                    .keyboardType(.webSearch)
                    .padding()
                    .autocorrectionDisabled()
                    .frame(width:screen.width - 120, height: 50)
                    .background(.secondary.opacity(0.2), in:.rect(cornerRadius: 15))
                    .scrollDismissesKeyboard(.immediately)
                    .onSubmit(of: .search) {
                        isTextFieldFocused = false
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
                
                Image(systemName: showBusinessView ? "xmark.circle.fill" : "magnifyingglass.circle.fill")
                    .resizable().scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.blue.opacity(0.8))
                    .onTapGesture {
                        if showBusinessView{
                            searchText = ""
                            showBusinessView.toggle()
                        } else {
                            isTextFieldFocused = false
                            search()
                        }
                    }
                
                Image(systemName: "arrow.up.and.down.text.horizontal")
                    .resizable().scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.blue.opacity(0.8))
                    .onTapGesture {
                        isTextFieldFocused = false
                        showFilterView.toggle()
                    }
                    .ifModif(showBusinessView, equal: false)
            }
            .padding(.horizontal,20)
            .padding()
            HStack{
                TextField("Where are you looking for ?", text: $location)
                    .focused($isTextFieldFocused)
                    .keyboardType(.webSearch)
                    .padding()
                    .autocorrectionDisabled()
                    .frame(width: screen.width - 70, height: 50)
                    .background(.secondary.opacity(0.2), in:.rect(cornerRadius: 15))
                    .scrollDismissesKeyboard(.immediately)
                    .onSubmit{
                        if location.isEmpty {
                            Task{
                                await locateUser()
                            }
                        }
                        isTextFieldFocused = false
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
                        isTextFieldFocused = false
                        Task{
                            await locateUser()
                        }
                    }
            }
            .ifModif(showUserLocationButton, equal: false)
            BusinessListView(location: $location)
                .ifModif(showBusinessView)
        }
        .sheet(isPresented: $showFilterView){
            SearchFilterView(popular: $popular, deals: $deals, limit: $limit)
                .presentationDetents([.fraction(1/3)])
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
    
    func checkAttributes() -> [String]{
        var returnedAttr:[String] = []
        if popular{
            returnedAttr.append("hot_and_new")
        } else {
            returnedAttr.removeAll(where: {$0 == "hot_and_new"})
        }
        if deals{
            returnedAttr.append("deals")
        } else {
            returnedAttr.removeAll(where: {$0 == "deals"})
        }
        print(returnedAttr)
        return returnedAttr
    }
    
    func search(){
        Task{
            do{
                if location.isEmpty{
                    await locateUser()
                }
                try await businessVM.getResults(searchText: searchText, attributes: checkAttributes(), categories: categories, location: location, limit: limit)
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
