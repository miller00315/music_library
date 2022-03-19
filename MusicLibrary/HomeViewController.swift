//
//  ViewController.swift
//  MusicLibrary
//
//  Created by Idwall Go Dev 001 on 19/03/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var albumsTableView: UITableView!
    
    @IBOutlet weak var homeActivityIndicator: UIActivityIndicatorView!
    
    lazy var trackList = [MusicTrack]() {
        didSet {
            DispatchQueue.main.async {
                self.albumsTableView.reloadData()
                
                self.hideLoading()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegates()
        getTracks()
        registerCell()
        showLoader()
        
        title = "Home"
        // Do any additional setup after loading the view.
    }

    private func delegates() {
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
    }
    
    private func registerCell() {
        let nib = UINib(nibName: AlbumTableViewCell.identifier, bundle: nil)
        
        albumsTableView.register(nib, forCellReuseIdentifier: AlbumTableViewCell.identifier)
    }
    
    private func getTracks() {
        ItunesService.shared.getTracks { result in
            switch result {
            case .success(let res):
                self.trackList = res
            case .failure(let error):
                print("deu ruim \(error)")
            }
        }
    }
    
    private func showLoader() {
        homeActivityIndicator.startAnimating()
        
        homeActivityIndicator.isHidden = false
    }
    
    private func hideLoading() {
        DispatchQueue.main.async {
            self.homeActivityIndicator.stopAnimating()
            
            self.homeActivityIndicator.isHidden = true
        }
    }
    
    func alertSuccess() {}
    
    func alertError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { result in
            print("Erro")
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let musicTrack = trackList[indexPath.row]
        
        ManagedObjectContext.shared.save(track: musicTrack) { result in
            switch result {
            case .Success:
                print("Salvo")
                break
            case .Error(let error):
                alertError(error)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = albumsTableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.identifier, for: indexPath) as? AlbumTableViewCell else {
            return UITableViewCell()
        }
        
        let track = trackList[indexPath.row]
        
        cell.setup(albumName: track.collectionName!,
                   trackName: track.trackName!,
                   imageUrl: track.artworkUrl100!)
        
        return cell
    }
    
    
}

