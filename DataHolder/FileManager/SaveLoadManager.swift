//
//  SaveLoadManager.swift
//  RaceGame
//
//  Created by Dmitry Divin on 9.12.25.
//

import Foundation
import UIKit

// MARK: - Keys
enum Keys: String {
    case name
    case playerSet
    case records
    case date
}

// MARK: - Constants
private enum Constants {
    static let maxRecordsCount = 10
}

// MARK: - SaveLoadManager
final class SaveLoadManager {

    
    // MARK: - Properties
    private let defaults = UserDefaults.standard
    
    // MARK: - Name Methods
    func saveName(_ name: String) {
        UserDefaults.standard.set(name, forKey: Keys.name.rawValue)
    }
    
    func loadName() -> String? {
        return UserDefaults.standard.string(forKey: Keys.name.rawValue)
    }
    
    // MARK: - Settings Methods
    func saveSettings(_ playerSettings: PlayerSettings) {
        UserDefaults.standard.set(encodable: playerSettings, forKey: Keys.playerSet.rawValue)
    }
    
    func loadSettings() -> PlayerSettings? {
        return UserDefaults.standard.get(decodableType: PlayerSettings.self, forKey: Keys.playerSet.rawValue)
    }
    
    // MARK: - Records Methods
    func saveRecords(_ record: RaceRecords) {
        var allRecords = loadAllRecords()
        
        let isDuplicate = allRecords.contains { existingRecord in
            return existingRecord.playerName == record.playerName &&
                   existingRecord.record == record.record
        }
        
        if !isDuplicate {
            allRecords.append(record)
        }
        
        allRecords.sort { $0.record > $1.record }
        
        if allRecords.count > Constants.maxRecordsCount {
            allRecords = Array(allRecords.prefix(Constants.maxRecordsCount))
        }
        
        UserDefaults.standard.set(encodable: allRecords, forKey: Keys.records.rawValue)
    }
    
    func loadAllRecords() -> [RaceRecords] {
        return defaults.get(decodableType: [RaceRecords].self, forKey: Keys.records.rawValue) ?? []
    }
    
    // MARK: - Image Methods
    func saveImage(image: UIImage) -> String? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let filename = UUID().uuidString
        let fileURL = directory.appendingPathComponent(filename)
        
        guard let data = image.pngData() else { return nil }
        
        do {
            try data.write(to: fileURL)
            return filename
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadImage(filename: String) -> UIImage? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = directory.appendingPathComponent(filename)
        
        return UIImage(contentsOfFile: fileURL.path)
    }
}
