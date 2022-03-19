//
//  FavoriteViewController.swift
//  MusicLibrary
//
//  Created by Idwall Go Dev 001 on 19/03/22.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteTracksTableView: UITableView!
    
    var trackList = [MusicTrack]() {
        didSet {
            DispatchQueue.main.async {
                self.favoriteTracksTableView.reloadData()
            }
        }
    }
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favoritos"
        
        delegates()
        registerCell()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavoritedTracks()
    }
    
    private func delegates() {
        favoriteTracksTableView.delegate = self
        favoriteTracksTableView.dataSource = self
    }
    
    private  func deleteTrack(uuid: UUID) {
        ManagedObjectContext.shared.delete(uuid: uuid.uuidString) { result in
            
            switch result {
            case .Success:
                getFavoritedTracks()
            case .Error(let errror):
                alertError(errror)
            }
        }
    }
    
    private func registerCell() {
        let nib = UINib(nibName: AlbumTableViewCell.identifier, bundle: nil)
        
        favoriteTracksTableView.register(nib, forCellReuseIdentifier: AlbumTableViewCell.identifier)
    }
    
    private func getFavoritedTracks() {
        let trackList = ManagedObjectContext.shared.list { result in
            switch result {
                
            case .Success:
                break
            case .Error(let error):
                alertError(error)
            }
        }
            
        self.trackList = trackList;
    }
    
    private func alertSuccess() {}
    
    private func alertError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { result in
            print("Erro")
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func refreshPageWhenClickButton() {
        favoriteTracksTableView.reloadData();
    }
}

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let musicTrack = trackList[indexPath.row]
        
        deleteTrack(uuid: musicTrack.id!)
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = favoriteTracksTableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.identifier, for: indexPath) as? AlbumTableViewCell else {
            return UITableViewCell()
        }
        
        let track = trackList[indexPath.row]
        
        cell.setup(albumName: track.collectionName!,
                   trackName: track.trackName!,
                   imageUrl: track.artworkUrl100!)
        
        return cell
    }
    
    
}

