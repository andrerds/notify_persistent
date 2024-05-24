//
//  VoipActivityAttributes.swift
//  devapptest
//
//  Created by André de Souza on 23/05/24.
//
import ActivityKit

import ActivityKit

struct VoIPActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var message: String
    }

    var title: String
}
