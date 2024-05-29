//
//  ContentView.swift
//  devapptest
//
//  Created by André de Souza on 15/04/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject  var notificationManager =  NotificationManager()
    @EnvironmentObject var navigationManager: NavigationManager
    var vibrationService =  VibrationService.shared
    
    var body: some View {
        
        if navigationManager.currentScreen == .home {
            ZStack{
                Spacer()
                VStack{
                    Text("Bem-vindo!").padding(.all)
                    
//                    Button("stop"){
//                        vibrationService.stopContinuousVibration()
//                        print("stoppp aqui")
//                    }
                    .buttonStyle(.bordered)
                    .padding()
                    .task {
                        await notificationManager.getAuthStatus()
                    }
                   
                    if(!notificationManager.hasPermission){
                        Button("Pedir permissão de notificação"){
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
        } else if navigationManager.currentScreen == .specificScreen {
            NotificationView(data: "")
        }
         
    }
}
 

#Preview {
    ContentView()
}
