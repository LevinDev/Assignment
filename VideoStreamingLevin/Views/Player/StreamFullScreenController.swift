//
//  StreamFullScreenController.swift
//  VideoStreamingLevin
//
//  Created by Levin varghese on 24/11/19.
//  Copyright © 2019 Levin Varghese. All rights reserved.
//

import UIKit


class StreamFullScreenController: UIViewController {
     // MARK: - IBOutlet
    @IBOutlet var btnClose: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fullscreenPlayerView: VideoFullscreenPlayerView!
    @IBOutlet weak var playBackButton: UIButton!
    
   var viewModel: StreamViewModel!
    var player: LVPlayer?

    lazy var transitioner: VideoFullscreenTransitioner = {
        loadViewIfNeeded()
        _ = self.view
        let transition = VideoFullscreenTransitioner()
        transition.fullscreenControls = [self.btnClose,self.collectionView]
        transition.fullscreenPlayerView = fullscreenPlayerView
        transition.fullscreenVideoGravity = .resizeAspect
        return transition
    }()
     // MARK: - Dependency Injection
    static func intialize(model: StreamViewModel, player: LVPlayer) -> StreamFullScreenController{
        let vc = StreamFullScreenController(nibName: "StreamFullScreenController", bundle: nil)
        vc.viewModel = model
        vc.modalPresentationStyle = .fullScreen
        vc.transitioner.playerView = player
        vc.transitioningDelegate = vc.transitioner
        vc.setPlaybackButton()
        vc.observePlayerState()
        vc.player = player
        return vc
        
    }
    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "StreamCollectionCell", bundle: nil), forCellWithReuseIdentifier: "StreamCollectionCell")
    }
    // MARK: -  Observer
    func observePlayerState() {
        self.transitioner.playerView?.playerStateCallback = {[weak self] state in
            switch state {
            case .playing:
               self?.playBackButton.setTitle("Pause", for: .normal)
            case .paused:
                self?.playBackButton.setTitle("Play", for: .normal)
            default:break
                
            }
        }
    }
   // MARK: - IBActions
    @IBAction func tapClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hideControls(_ sender: UIButton) {
        if sender.titleLabel?.text == "HideControls" {
            sender.setTitle("ShowControls", for: .normal)
            hideControls(true)
        } else {
             sender.setTitle("HideControls", for: .normal)
             hideControls(false)
        }
    }
    @IBAction func playbackButtonPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "Play" {
            self.player?.play()
        } else {
            self.player?.pause()
        }
    }
     // MARK:- Helper
    func hideControls(_ val : Bool) {
        self.btnClose.isHidden = val
        self.collectionView.isHidden = val
        self.playBackButton.isHidden = val
    }
    func setPlaybackButton() {
        guard let state = self.transitioner.playerView?.playerState else { return }
        switch state {
        case .playing:
            self.playBackButton.setTitle("Pause", for: .normal)
        case .paused,.none:
            self.playBackButton.setTitle("Play", for: .normal)
        default: break
            
        }
    }
}
// MARK: - UICollectionView datasource delegates
extension StreamFullScreenController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return  viewModel?.streamList.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel?.streamList[indexPath.row]
        if let stream = model as? StreamCellConfigurator {
            let cell =   stream.item.convert().cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            cell.layer.borderWidth = viewModel?.currentStream?.url == stream.item.url ? 3.0 :0
            cell.layer.borderColor = viewModel?.currentStream?.url == stream.item.url ? UIColor.blue.cgColor : UIColor.clear.cgColor
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel?.streamList[indexPath.row]
        viewModel?.currentStream = (model as? StreamCellConfigurator)?.item
        collectionView.reloadData()
        self.transitioner.playerView?.play(url: ((model as? StreamCellConfigurator)?.item.url)!)
    }


}
