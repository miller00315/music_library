//
//  Album.swift
//  MusicLibrary
//
//  Created by Idwall Go Dev 001 on 19/03/22.
//

import Foundation


struct Album: Codable {
    let resultsCount: Int?
    let results: [MusicTrack]?
}
