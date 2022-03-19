//
//  AboutViewController.swift
//  MusicLibrary
//
//  Created by Idwall Go Dev 001 on 19/03/22.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutImageView: UIImageView!
    
    @IBOutlet weak var aboutTitleLabel: UILabel!
    
    @IBOutlet weak var aboutDescription: UILabel!
    
    
    @IBOutlet weak var aboutMembersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }

    
    private func setLayout() {
        aboutTitleLabel.text = "Music Library"
        
        aboutDescription.text = """
        Aproveite o que há de melhor nas parada musicas, sucessos nacionais e internacionais
        """
        
        aboutMembersLabel.text = """
            💻 Everton Santana
        
            💻 Jady Linnit
        
            💻 Lucas de Castro Souza
        
            💻 Miller César de OLiveira
        
            💻 Pablo Gustavo
        """
        
        aboutImageView.image = UIImage(named: "logo")
    }
}
