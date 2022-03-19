//
//  MannagerObjectContext.swift
//  MusicLibrary
//
//  Created by Idwall Go Dev 001 on 19/03/22.
//

import Foundation
import UIKit
import CoreData

enum DataResult {
    case Success
    case Error(String)
}

enum DataError: Error {
    case repeatedItem
}

typealias onCompletionHandler = (DataResult) -> Void

protocol managedSaveProtocol {
    func save(track: MusicTrack, onCompletionHandler: onCompletionHandler)
}

protocol managedDeleteProtocol {
    func delete(uuid: String, onCompletionHandler: onCompletionHandler)
}

protocol managedListProtocol {
    func list(onCompletionHandler: onCompletionHandler) -> [MusicTrack]
}

class ManagedObjectContext {
    private let entity = "Music"
    
    static var shared: ManagedObjectContext = {
        let instance = ManagedObjectContext()
        
        return instance
    }()
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
}

extension ManagedObjectContext: managedSaveProtocol {
    func save(track: MusicTrack, onCompletionHandler: (DataResult) -> Void) {
        
        let context = getContext()
        
        let predicate = NSPredicate(format: "trackName == %@", track.trackName!)
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        
        fetchRequest.predicate = predicate
        
        do {
            let fetchResults = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            if let repeteadEntity = fetchResults.first {
                print(repeteadEntity)
                onCompletionHandler(.Error("Repetido"))
            } else {
            
                guard let entity = NSEntityDescription.entity(forEntityName: entity, in: context)
                    else { return }
                
                let transaction = NSManagedObject(entity: entity, insertInto: context)
                
                transaction.setValue(UUID(), forKey: "id")
                transaction.setValue(track.collectionName, forKey: "collectionName")
                transaction.setValue(track.trackName, forKey: "trackName")
                transaction.setValue(track.artworkUrl100, forKey: "artworkUrl100")
                
                do {
            
                    try context.save()
                            
                    onCompletionHandler(.Success)
                
                } catch let error as NSError {
                    onCompletionHandler(.Error(error.localizedDescription))
                }
            }
            
        } catch let error as NSError {
            onCompletionHandler(.Error(error.localizedDescription))
        }
    }
    
    func checkRepeatedData(_ data: NSManagedObject?) throws {
        if data != nil {
            throw DataError.repeatedItem
        }
    }
}

extension ManagedObjectContext: managedDeleteProtocol {
    func delete(uuid: String, onCompletionHandler: (DataResult) -> Void) {
        let context = getContext()
        
        let predicate = NSPredicate(format: "id == %@", "\(uuid)")
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        
        fetchRequest.predicate = predicate
        
        do {
            
            let fetchResults = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            if let entityToDelete = fetchResults.first {
                context.delete(entityToDelete)
            }
            
            try context.save()
            
            onCompletionHandler(.Success)
            
        } catch let error as NSError {
            onCompletionHandler(.Error(error.localizedDescription))
        }
    }
}

extension ManagedObjectContext: managedListProtocol {
    func list(onCompletionHandler: onCompletionHandler) -> [MusicTrack] {
        var listTrack: [MusicTrack] = []
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        
        do {
            
            guard let tracks = try getContext().fetch(fetchRequest) as? [NSManagedObject]
                else {return listTrack}
        
            for item in tracks {
                
                if let id = item.value(forKey: "id") as? UUID,
                   let collectionName = item.value(forKey: "collectionName") as? String,
                   let trackName = item.value(forKey: "trackName") as? String,
                   let image = item.value(forKey: "artworkUrl100") as? String
                {
                    let track = MusicTrack(id: id, collectionName: collectionName, trackName: trackName, artworkUrl100: image)
                    
                    listTrack.append(track)
                }
            }
            
        } catch let error as NSError {
            onCompletionHandler(.Error(error.localizedDescription))
        }
        
        onCompletionHandler(.Success)
        
        return listTrack
    }
}




