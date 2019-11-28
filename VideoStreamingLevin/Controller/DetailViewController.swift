//
//  DetailViewController.swift
//  VideoStreamingLevin
//
//  Created by Levin Varghese on 11/24/19.
//  Copyright © 2019 Levin Varghese. All rights reserved.
//

import UIKit
import AVKit

class DetailViewController: UIViewController {
     // MARK: - IBOutlets
    @IBOutlet weak var playerView: LVPlayer!
    @IBOutlet weak var playerContainerView: UIView!
    @IBOutlet weak var labelDescription: UILabel?
     // MARK: - Properties
    var viewModel :StreamViewModel!
    var player: AVPlayer?

    // MARK: - ViewController Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentModel = viewModel.currentStream {
            self.labelDescription?.text = currentModel.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentModel = viewModel.currentStream else { return }
        currentModel.getThumbnail { [weak self] (image) in
            self?.playerView.thumbnailView.image = image
        }
        setupVideoPlayer(url: currentModel.url)
    }
    
     // MARK: -  Hepler Methods
    func setupVideoPlayer(url: String) {
       self.playerView.setupVideoPlayer(url: url)
        self.playerView.playerAction = { action in
            
            switch action {
            case .expand:
                self.goToFullScreen()
            default: break
                
            }
        }
    }
    // MARK: -  Navigation
    func goToFullScreen() {
        let vc = StreamFullScreenController.intialize(model: viewModel, player: self.playerView)
        present(vc, animated: true, completion: nil)
    }
    
}
