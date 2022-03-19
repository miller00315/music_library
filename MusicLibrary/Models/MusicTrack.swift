//
//  MusicTrack.swift
//  MusicLibrary
//
//  Created by Idwall Go Dev 001 on 19/03/22.
//

import Foundation

struct MusicTrack: Codable {
    let id: UUID?
    let collectionName, trackName, artworkUrl100 : String?
}
