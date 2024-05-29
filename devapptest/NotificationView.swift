//
//  NotificationView.swift
//  devapptest
//
//  Created by André de Souza on 16/04/24.
//

import SwiftUI

struct NotificationView: View {
    
    @State private var navigateToNotificationView: Bool = false
    @State private var notificationData: [AnyHashable: Any]?
   
    
    var data: Any
    var body: some View {
        VStack(alignment: .center, spacing: 10.0) {
            CircleView()
            ContatctView(title: "Liberar evento", desc: "Evento nome")
            Spacer()
            ButtonsAction()
        }
        .frame(maxWidth: .infinity)
    }
}

struct CircleView:View {
    var body: some View {
        Circle()
            .fill(Color.green)
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .foregroundColor(.red)
            .frame(width: 250.0, height: 250.0)
            
    }
}


struct ContatctView:View {
    var title: String
    var desc: String
    var body: some View {
        VStack(alignment: .center, spacing: 3.0){
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .frame(width: 300.0)
               
            Text(desc)
                .font(.callout)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .frame(width: 200.0)
                 
        }
        .padding(10.0)
        .frame(maxWidth: .infinity)
 
       
    
    }
}

struct  ButtonsAction: View {
    var vibrationService = VibrationService.shared
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var showToast = false
    @State private var message = ""
    
    var body: some View {
        VStack {
            
            HStack(spacing: 70) {
              
                ButtonView(
                    labelName: "Recusar", icon: "check",
                    colorBackground:  Color.red, colorForegroundColor: Color.white,
                    action: {
                        print("Decline")
                        vibrationService.stopContinuousVibration()
                        navigationManager.currentScreen = .home
                        message = "Recusado com sucesso!"
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showToast = false
                            
                        }
                    }
                )
                
                ButtonView(
                    labelName: "Liberar", icon: "check",
                    colorBackground:  Color.green, colorForegroundColor: Color.white,
                    action: {
                        print("Accept")
                        vibrationService.stopContinuousVibration()
                        message = "Liberado com sucesso!"
                        showToast = true
                        navigationManager.currentScreen = .home
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showToast = false
                        }
                    }
                )
            }
            .padding(.horizontal)
            
            if showToast {
                ToastView(message: message)
                    .transition(.opacity)
            }
        }
    }
}

struct ToastView:View {
    var message:String
    
    var body: some View {
       
        Text(message)
            .padding()
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 20)
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
            
        }.padding(.bottom, 30)
    }
}

#Preview {
    NotificationView(data: "")
}
