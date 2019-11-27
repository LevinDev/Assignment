//
//  StreamViewModel.swift
//  VideoStreamingLevin
//
//  Created by Levin varghese on 24/11/19.
//  Copyright © 2019 Levin Varghese. All rights reserved.
//

import Foundation

protocol StreamListProtocol {
    var numberOfSections: Int { get }
    func getDemoStreams() -> [CellConfigurator]
}
class StreamViewModel: StreamListProtocol {
    var numberOfSections: Int {
        return 1
    }
    
    func getDemoStreams() -> [CellConfigurator] {
        let items = [
            
            StreamCellConfigurator(item: Stream(url: "https://content.jwplatform.com/manifests/yp34SRmf.m3u8", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")),
            StreamCellConfigurator(item: Stream(url: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas sed sed risus pretium quam. Mauris augue neque gravida in fermentum et. Risus commodo viverra maecenas accumsan. Pulvinar neque laoreet suspendisse interdum consectetur. Urna id volutpat lacus laoreet non. Ac felis donec et odio pellentesque diam. Imperdiet nulla malesuada pellentesque elit eget gravida cum sociis. Suspendisse in est ante in. Suscipit adipiscing bibendum est ultricies. Orci ac auctor augue mauris augue neque gravida in fermentum. In fermentum posuere urna nec tincidunt praesent semper feugiat nibh. Vulputate eu scelerisque felis imperdiet. Tellus id interdum velit laoreet id donec ultrices tincidunt. Orci nulla pellentesque dignissim enim sit amet venenatis urna. Nunc sed augue lacus viverra vitae congue eu consequat ac. Pretium nibh ipsum consequat nisl vel pretium lectus quam id. Scelerisque varius morbi enim nunc faucibus a pellentesque. Molestie ac feugiat sed lectus. Leo vel fringilla est ullamcorper eget nulla facilisi etiam dignissim.")),
            StreamCellConfigurator(item: Stream(url: "https://mnmedias.api.telequebec.tv/m3u8/29880.m3u8", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")),
            StreamCellConfigurator(item: Stream(url: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sem viverra aliquet eget sit amet tellus cras adipiscing enim. Nisl condimentum id venenatis a condimentum. Enim nunc faucibus a pellentesque sit. Aliquam purus sit amet luctus venenatis lectus magna fringilla. Ac ut consequat semper viverra nam libero justo laoreet. Cras tincidunt lobortis feugiat vivamus at augue eget arcu dictum. Potenti nullam ac tortor vitae purus faucibus ornare suspendisse. Dui ut ornare lectus sit amet. Mi tempus imperdiet nulla malesuada. Tellus cras adipiscing enim eu turpis egestas. Consectetur adipiscing elit pellentesque habitant morbi tristique senectus et. Diam maecenas sed enim ut sem viverra. A cras semper auctor neque. Sit amet dictum sit amet. Diam quam nulla porttitor massa id neque. Eget nullam non nisi est sit amet facilisis magna" ))
        ]
        return items
    }
    
    var streamList: [CellConfigurator]
    var currentStream: Stream?
    
    init() {
        self.streamList = []
        self.streamList = getDemoStreams()
    }
    
}
