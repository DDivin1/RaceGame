//
//  PlayerSettings.swift
//  RaceGame
//
//  Created by Dmitry Divin on 11.12.25.
//

import Foundation

final class PlayerSettings: Codable {
    var name: String
    var carName: String
    var objectName: String
    var obstacleName: String
    var avatarPictureName: String?

    
    convenience init() {
        self.init(name: "Player", carName: "yellowCar", objectName: "cone", obstacleName: "stone", avatarPictureName: nil)
    }
    init (name: String, carName: String, objectName: String, obstacleName: String, avatarPictureName: String?) {
        self.name = name
        self.carName = carName
        self.objectName = objectName
        self.obstacleName = obstacleName
        self.avatarPictureName = avatarPictureName
    }
}
