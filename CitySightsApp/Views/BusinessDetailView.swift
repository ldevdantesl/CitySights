//
//  BusinessDetailView.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 12.04.2024.
//

import SwiftUI
import CallKit

struct BusinessDetailView: View {
    @Environment(BusinessViewModel.self) var businessVM
    @Binding var goBack: Bool
    var body: some View {
        VStack{
            GeometryReader { geo in
                AsyncImage(url: URL(string: businessVM.selectedBusiness.imageURL ?? "")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: geo.size.height) // Adjust knownOffset accordingly
                            .clipped()
                            .ignoresSafeArea()
                    } else {
                        // Handle loading or error state
                        Text("Loading image...")
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .overlay(alignment: .bottom){
                ZStack{
                    Rectangle().fill(.green).frame(width: screen.width, height: 30)
                    Text("Open")
                        .font(.system(.callout, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                        .hSpacing()
                        .padding(.horizontal,10)
                }
            }
            .overlay(alignment: .topLeading) {
                Button{
                    withAnimation {
                        goBack.toggle()
                    }
                } label:{
                    Image(systemName: "arrow.left.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.blue, .white)
                        .padding(10)
                        .offset(y: -20)
                }
            }
            ScrollView{
                
                Text(businessVM.selectedBusiness.name)
                    .font(.system(.title, design: .rounded, weight: .semibold))
                    .hSpacing()
                
                ForEach(businessVM.selectedBusiness.location.displayAddress ?? [], id:\.self){ loc in
                    Text(loc)
                        .font(.system(.callout, design: .rounded, weight: .light))
                        .foregroundStyle(.secondary)
                }
                .hSpacing()
                showRating(rating: businessVM.selectedBusiness.rating)
                    .hSpacing()
                    .padding(.bottom,10)
                
                Button{
                    
                } label:{
                    HStack{
                        Image(systemName: "phone")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text(businessVM.selectedBusiness.displayPhone ?? "")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                        Spacer()
                        Image(systemName: "arrow.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.vertical,10)
                }
                .foregroundStyle(.black)
                Divider()
                Button{
                    
                } label:{
                    HStack{
                        Image(systemName: "globe")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text(businessVM.selectedBusiness.url ?? "")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.vertical,10)
                }
                .foregroundStyle(.black)
                Divider()
                Button{
                    
                } label:{
                    HStack{
                        Image(systemName: "quote.bubble")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("\(businessVM.selectedBusiness.reviewCount ?? 0) reviews" )
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.vertical,10)
                }
                .foregroundStyle(.black)
                Divider()
            }
            .padding(.horizontal, 20)
            Button{
                
            } label:{
                HStack{
                    Image(systemName: "paperplane")
                        .resizable().scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                    Text("Get Directions")
                        .font(.system(.title, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: screen.width - 50, height: 50)
                .background(Color.blue.opacity(0.8), in:.rect(cornerRadius: 15))
                .padding(10)
            }
            .foregroundStyle(.black)
        }
    }
    @ViewBuilder
    func showRating(rating: Double) -> some View{
        let ratingInt = Int(rating)
        HStack(spacing:0){
            ForEach(0..<ratingInt, id: \.self){ i in
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 15)
            }
            ForEach(ratingInt..<5, id: \.self){ i in
                Image(systemName: "star.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 15)
            }
        }
    }
}

#Preview {
    BusinessDetailView(goBack: .constant(false))
        .environment(BusinessViewModel())
}
