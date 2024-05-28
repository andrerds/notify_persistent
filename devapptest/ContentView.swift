//
//  ContentView.swift
//  devapptest
//
//  Created by André de Souza on 15/04/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject  var notificationManager =  NotificationManager ()
    var vibrationService =  VibrationService.shared
    
    var body: some View {
        ZStack{
            List{
                NavigationLink("Notification", destination: NotificationView(data: ""))
                    .navigationTitle("Home")
            }
            Spacer()
            VStack{
                Text("hello word").padding(.all)
                
                Button("stop"){
                    vibrationService.stopContinuousVibration()
                    print("stoppp aqui")
                    
                }
                .buttonStyle(.bordered)
                .padding()
                .task {
                    await notificationManager.getAuthStatus()
                 }
                
                Button("Request Notification"){
                    Task{
                        await notificationManager.request()
                    }
                }.buttonStyle(.bordered)
                .foregroundColor(notificationManager.hasPermission ? .gray : .blue)
                .disabled(notificationManager.hasPermission)
                .presentationCornerRadius(30)
                .task {
                    await notificationManager.getAuthStatus()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
