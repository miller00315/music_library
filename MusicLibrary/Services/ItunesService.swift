//
//  ItunesService.swift
//  MusicLibrary
//
//  Created by Idwall Go Dev 001 on 19/03/22.
//

import UIKit
import Foundation

enum AlbumError: Error {
    case urlInvalid
    case noProcessData
    case noDataAvailable
}

protocol ServicesProtocol {
    func getTracks(completion: @escaping(Result<[MusicTrack], AlbumError>) -> Void)
}

class ItunesService: ServicesProtocol {
    
    let session = URLSession.shared
    
    let url = "https://itunes.apple.com/search?media=music&term=eminem&limit=20"
    
    // Singleton pattern
    static var shared: ItunesService = {
        let instance = ItunesService()
        return instance
    }()
    
    // That function will be used to fetch data from Itunes
    func getTracks(completion: @escaping(Result<[MusicTrack], AlbumError>) -> Void) {
        
        // verify if is a valid url
        guard let url = URL(string: url) else { return completion(.failure(.urlInvalid)) }
        
        // data check
        let dataTask = session.dataTask(with: url) { data, _ , _ in
            
            do {
                
                guard let jsonData = data else { return completion(.failure(.noDataAvailable)) }
                
                let decoder = JSONDecoder()
                
                let album =  try decoder.decode(Album.self, from: jsonData)
                
                completion(.success(album.results!))
                
            } catch {
                completion(.failure(.noProcessData))
            }
        }
        
        dataTask.resume()
    }
    
}
