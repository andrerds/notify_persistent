//
//  MainScreen.swift
//  keyaccesspass
//
//  Created by André de Souza on 08/04/24.
//

import SwiftUI


 
func clickBtn(nav: Any)  {
    print("Click \(nav)")
}

struct MainScreen: View {
   
  var body: some View {
      
        List{
            NavigationLink("Notification", destination: CustomNotificationView(data: {
                "teste"; "aaaa"
            }))
            .navigationTitle("Home")
        }
        
        VStack{
        Label("Main", systemImage:  "house")
        }
         
    }
}

struct MainView_Previews: PreviewProvider{
    static var previews: some View{
        
        NavigationStack{
            MainScreen()
        }
    }
}
 
