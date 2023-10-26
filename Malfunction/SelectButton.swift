//
//  SelectButton.swift
//  IDEATHON_ImageReplacement
//
//  Created by 新翌王 on 2023/10/25.
//

import SwiftUI

struct SelectButton: View {
    @Binding var isSelected: Bool
    @State var color: Color
    @State var text: String
    
    var body: some View {
        ZStack {
            Text(text)
                .foregroundColor(isSelected ? color : color.opacity(0.5)) 
                .font(Font.custom("Syncopate", size: 15).weight(.bold))
        }
    }
}

#Preview {
    SelectButton(isSelected: .constant(false), color: Color("SystemBlue"), text: "Option")
}
