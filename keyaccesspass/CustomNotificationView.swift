//
//  CustomNotificationView.swift
//  keyaccesspass
//
//  Created by André de Souza on 04/04/24.
//
 
 import Foundation

 import UIKit
 import SwiftUI

 @available(iOS 15.0, *)
struct CustomNotificationView: View {
    var data: Any
    var body: some View {
        VStack {
            CircleView()
            Spacer()
            ContatctView(name: "Teste name", desc: "")
            ButtonsAction()
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        
    }
}

struct CircleView:View {
    var body: some View {
        Circle()
            .fill(Color.blue)
            .foregroundColor(.green)
            .frame(width: 200, height: 200)
            .padding(.top, 20)
    }
}


struct ContatctView:View {
    var name: String
    var desc: String
    var body: some View {
        VStack{
            Text("090909090" )
                .fontWeight(.semibold)
               
            Text(name)
                .fontWeight(.semibold)
                 
        }.frame(maxWidth: .infinity)
        .padding(100)
    }
}

struct ButtonsAction:View {
    var body: some View {
        HStack(spacing: 70) {
      
            ButtonView(
                labelName: "decline", icon: "phone.down.circle.fill",
                  colorBackground:  Color.red, colorForegroundColor:Color.white,
            action: {
                print("decline")
            }
            )
           
            
            ButtonView(
                labelName: "Accept", icon: "phone.circle.fill",
                  colorBackground:  Color.green, colorForegroundColor:Color.white,
            action: {
                print("Accept")
            }
            )

        }
        .padding(.horizontal)
    }
}

struct ButtonView: View {
    var labelName: String
    var icon: String
    var colorBackground: Color
    var colorForegroundColor: Color
    var action: Any
    var body: some View {
        Button(action: action as! () -> Void) {
            Label(labelName, systemImage: icon)
                .padding()
                .background(colorBackground)
                .foregroundColor(colorForegroundColor)
                .cornerRadius(40)
            
        }
    }
}

 #Preview {
     CustomNotificationView(data: "")
 }

 
