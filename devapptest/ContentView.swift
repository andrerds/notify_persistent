//
//  ContentView.swift
//  devapptest
//
//  Created by André de Souza on 15/04/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List{
            NavigationLink("Notification", destination: NotificationView(data: {
                "teste"; "aaaa"
            }))
            .navigationTitle("Home")
            
        }
        
        VStack{
            Label("Main", systemImage:  "house")
        }.padding()
       
        
       
    }
}

#Preview {
    ContentView()
   
}
