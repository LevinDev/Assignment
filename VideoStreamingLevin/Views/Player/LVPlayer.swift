//
//  LVPlayer.swift
//  VideoStreamingLevin
//
//  Created by Levin Varghese on 11/25/19.
//  Copyright © 2019 Levin Varghese. All rights reserved.
//

import UIKit
import AVKit


class LVPlayer: UIView {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var playPauseButton: UIButton?
    @IBOutlet weak var expand: UIButton?
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var thumbnailView: UIImageView!
    
    var timeObserver: Any?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer = AVPlayerLayer()
    var currentItem: AVPlayerItem?
    var playerAction: ((_ action: PlayerAction) -> Void )?
    var playerState: PlayerState = .none
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    func setupPlayer() {
        
    }
    
    func setupVideoPlayer(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        player = AVPlayer(url: url)
        
        self.playerLayer.player = player
        playerLayer.frame = self.view.bounds;
        
        playerLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(playerLayer)
        let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsedTime in
            self.updateVideoPlayerSlider()
        })
        self.addObserverPlayerItem()
        self.enableControls(val: false)
        self.controlView.layer.zPosition = 1
        self.activityIndicator.layer.zPosition = 2
        self.handleTapGesture()
        
    }
    
    func play(url: String) {
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        player!.replaceCurrentItem(with: playerItem)
    }
    

     override var contentMode: UIView.ContentMode {
        didSet {
            switch contentMode {
            case .scaleAspectFill:  playerLayer.videoGravity = .resizeAspectFill
            case .scaleAspectFit:   playerLayer.videoGravity = .resizeAspect
            default:                playerLayer.videoGravity = .resize
            }
        }
    }
    
     override func layoutSubviews() {
        super.layoutSubviews()
        guard playerLayer.superlayer == layer else { return }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.frame = bounds
        self.view?.bringSubviewToFront(self.controlView)
        CATransaction.commit()
    }
    
    func updateVideoPlayerSlider() {
        guard let currentTime = player?.currentTime() else { return }
        let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
        progressSlider.value = Float(currentTimeInSeconds)
        if let currentItem = player?.currentItem {
            let duration = currentItem.duration
            if (CMTIME_IS_INVALID(duration)) {
                return;
            }
            let currentTime = currentItem.currentTime()
            progressSlider.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
        }
    }
    
    func handleTapGesture() {
        self.view.superview?.addTapGestureRecognizer { [weak self] in
            guard let StrongSelf = self else { return }
            switch StrongSelf.playerState {
            case .playing:
            self?.controlView.isHidden = self?.controlView.isHidden ?? false ? false : true
            default: break
            }
        }
        
        Timer.every(20.0.seconds) { [weak self] in
            guard let StrongSelf = self else { return }
            switch StrongSelf.playerState {
            case .playing:
                self?.controlView.isHidden = true
            default: break
            }
        }
    }
    

    
    // MARK: - IBActions
    @IBAction func playbackSliderValueChanged(_ sender:UISlider)
    {
        guard let duration = player?.currentItem?.duration else { return }
        let value = Float64(sender.value) * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        player?.seek(to: seekTime )
    }
    
    @IBAction func playPauseTapped(_ sender: UIButton) {
        guard let player = player else { return }
        if !player.isPlaying {
            self.playerState = .playing
            player.play()
            playPauseButton?.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            playPauseButton?.setImage(UIImage(named: "play"), for: .normal)
            player.pause()
            self.playerState = .paused
        }
    }
    
     @IBAction func expandAction(_ sender: UIButton) {
        self.playerAction?(.expand)
    }
    
}


extension LVPlayer {
    
    
    // MARK: - Helper
    func enableControls(val: Bool) {
        self.playPauseButton?.isEnabled = val
        self.progressSlider.isEnabled = val
        self.expand?.isEnabled = val
    }
    // MARK: - KVO
    private func addObserverPlayerItem()
    {
        if let playerItem = self.player?.currentItem{
            playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
            playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
            playerItem.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
            self.player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), options: [.new, .initial], context: nil)
            self.player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.new, .initial], context: nil)
            self.currentItem = playerItem
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerItemDidReachEnd),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: nil)
        }
    }
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        self.player?.seek(to: CMTime.zero)
        self.playerState = .playbackEndend
        self.playPauseTapped(self.playPauseButton ?? UIButton())
        self.controlView.isHidden = false
        
    }
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is AVPlayerItem {
            switch keyPath {
                
            case "playbackBufferEmpty":
                self.activityIndicator?.startAnimating()
            case "playbackLikelyToKeepUp":
                self.activityIndicator?.stopAnimating()
                self.enableControls(val: true)
            case "playbackBufferFull":
                self.activityIndicator?.stopAnimating()
                 self.enableControls(val: true)
            case #keyPath(AVPlayer.currentItem.status):
                
                let status: AVPlayerItem.Status
                if let statusNumber = change?[.newKey] as? NSNumber {
                    status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
                } else {
                    status = .unknown
                }
                
                // Switch over status value
                switch status {
                case .readyToPlay:
                self.enableControls(val: true)
                case .failed: break
                // Player item failed. See error.
                case .unknown: break
                    // Player item is not yet ready.
                @unknown default:
                    break
                }
            case #keyPath(AVPlayer.status):
                print()
            case .none: 
               self.activityIndicator?.stopAnimating()
            case .some(_):
                self.activityIndicator?.stopAnimating()
            }
        }
    }
}
