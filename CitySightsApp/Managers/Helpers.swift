//
//  Helpers.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 12.04.2024.
//

import Foundation
import SwiftUI

let screen = UIScreen.main.bounds

struct ifModifier: ViewModifier{
    var boolean: Bool
    var equal: Bool?
    func body(content: Content) -> some View {
        if boolean == equal{
            content
        }
    }
}

extension View{
    func ifModif(_ bool: Bool, equal: Bool? = true) -> some View{
        modifier(ifModifier(boolean: bool, equal: equal))
    }
}

struct HSpacingModifier: ViewModifier {
    var width: CGFloat?
    
    func body(content: Content) -> some View {
        if let width = width {
            HStack {
                content
                Spacer()
                    .frame(width: width)
            }
        } else {
            HStack{
                content
                Spacer()
            }
        }
    }
}

extension View {
    func hSpacing(width: CGFloat? = nil) -> some View {
        modifier(HSpacingModifier(width: width))
    }
}
