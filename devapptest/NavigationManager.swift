//
//  NavigationManager.swift
//  devapptest
//
//  Created by André de Souza on 28/05/24.
//
enum AppScreen {
    case home
    case specificScreen
}
import Foundation
class NavigationManager: ObservableObject {
    @Published var currentScreen: AppScreen = .home  
    
}
