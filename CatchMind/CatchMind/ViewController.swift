//
//  ViewController.swift
//  CatchMind
//
//  Created by kwangrae kim on 2020/01/20.
//  Copyright © 2020 conyconydev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var mainTableView: UITableView!
    
    //MARK: vlaue
    let sampleData = SampleData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.mainTableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.samples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainFeatureCell", for: indexPath) as? MainFeatureCell else {
            return UITableViewCell()
        }
        
        let sample = self.sampleData.samples[indexPath.row]
        cell.titleLabel.text = sample.title
        cell.descriptionLabel.text = sample.description
        cell.featureImageView.image = UIImage(named: sample.image)
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        
    }
}
