//
//  ViewController.swift
//  VideoStreamingLevin
//
//  Created by Levin Varghese on 11/24/19.
//  Copyright © 2019 Levin Varghese. All rights reserved.
//

import UIKit
import AVKit

class HomeViewController: UIViewController {

    @IBOutlet weak var streamListTableView: UITableView?
    var viewModel: StreamViewModel = StreamViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination: DetailViewController = segue.destination as? DetailViewController else {return}
        destination.viewModel = self.viewModel
    }

}

extension HomeViewController : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.streamList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.streamList[indexPath.row]
        let cell = model.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.streamList[indexPath.row]
        viewModel.currentStream = (model as? StreamCellConfigurator)?.item
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
}



    

