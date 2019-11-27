//
//  StreamFullScreenController.swift
//  VideoStreamingLevin
//
//  Created by Levin varghese on 24/11/19.
//  Copyright © 2019 Levin Varghese. All rights reserved.
//

import UIKit


class StreamFullScreenController: UIViewController {
    
    @IBOutlet var btnClose: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var fullscreenPlayerView: VideoFullscreenPlayerView!
    
   var viewModel: StreamViewModel!

    lazy var transitioner: VideoFullscreenTransitioner = {
        loadViewIfNeeded()
        _ = self.view
        let transition = VideoFullscreenTransitioner()
        transition.fullscreenControls = [self.btnClose]
        transition.fullscreenPlayerView = fullscreenPlayerView
        transition.fullscreenVideoGravity = .resizeAspect
        return transition
    }()
    
    static func intialize(model: StreamViewModel, player: LVPlayer) -> StreamFullScreenController{
        let vc = StreamFullScreenController(nibName: "StreamFullScreenController", bundle: nil)
        vc.viewModel = model
        vc.modalPresentationStyle = .fullScreen
        vc.transitioner.playerView = player
        vc.transitioningDelegate = vc.transitioner
        return vc
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "StreamCollectionCell", bundle: nil), forCellWithReuseIdentifier: "StreamCollectionCell")
    }

    @IBAction func tapClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

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
