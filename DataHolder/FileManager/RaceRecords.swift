//
//  RaceRecords.swift
//  RaceGame
//
//  Created by Dmitry Divin on 11.12.25.
//

import Foundation

final class RaceRecords: Codable {
    let playerName: String
    let record: Int
    let date: Date

    init (playerName: String, record: Int, date: Date) {
        self.playerName = playerName
        self.record = record
        self.date = date
    }
}
