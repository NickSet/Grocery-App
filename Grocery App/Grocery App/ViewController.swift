//
//  ViewController.swift
//  Grocery App
//
//  Created by Nicholas Setliff on 12/14/18.
//  Copyright © 2018 Nicholas Setliff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var itemTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
    }
    
    @IBAction func AddItemButtonTapped(_ sender: UIButton) {
        let addItemViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddItemViewController") as! UIViewController
        addItemViewController.providesPresentationContextTransitionStyle = true
        addItemViewController.definesPresentationContext = true
        addItemViewController.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        self.present(addItemViewController, animated: true, completion: nil)
        
        // Make sure your vc2 background color is transparent
//        addItemViewController.view.backgroundColor = UIColor.clear
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? HeaderTableViewCell {
            
            headerCell.emojiLabel.text = Constants.SectionEmoji.dairy.rawValue
            headerCell.sectionLabel.text = "Dairy"
            return headerCell
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") {
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

