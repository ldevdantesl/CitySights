//
//  BusinessRowView.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 11.04.2024.
//

import SwiftUI

struct BusinessRowView: View {
    let business: Business
    @Environment(BusinessViewModel.self) var businessVM
    @State var showDetailView: Bool = false
    var body: some View {
        VStack{
            HStack{
                AsyncImage(url: URL(string:business.imageURL ?? "")) { img in
                    img.resizable()
                        .clipShape(.rect(cornerRadius: 15))
                        .frame(width: UIScreen.main.bounds.width / 3 - 10, height: UIScreen.main.bounds.height / 10)
                        .aspectRatio(contentMode: .fill)
                        
                } placeholder: {
                    ProgressView()
                        .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 10)
                }
                    
                VStack(alignment:.leading){
                    HStack{
                        Text(business.name)
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                        Spacer()
                        showRating(rating: business.rating)
                    }
                    Text("\(distanceCalc(distance:business.distance)) mins. away")
                        .font(.system(.subheadline, design: .rounded, weight: .light))
                        .foregroundStyle(.secondary)
                }
            }
            Divider()
        }
        .onTapGesture {
            businessVM.selectedBusiness = business
            showDetailView.toggle()
        }
        .fullScreenCover(isPresented: $showDetailView){
            BusinessDetailView(goBack: $showDetailView)
        }
    }
    func distanceCalc(distance: Double?) -> Int{
        if let distance = distance{
            return Int(distance/600)
        } else {
            return 0
        }
    }
    @ViewBuilder
    func showRating(rating: Double) -> some View{
        let ratingInt = Int(rating)
        HStack(spacing:0){
            ForEach(0..<ratingInt,id: \.self){ i in
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 15)
            }
            ForEach(ratingInt..<5,id: \.self){ i in
                Image(systemName: "star.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 15)
            }
        }
    }
}

#Preview {
    BusinessRowView(business: BusinessViewModel().selectedBusiness)
        .environment(BusinessViewModel())
}
