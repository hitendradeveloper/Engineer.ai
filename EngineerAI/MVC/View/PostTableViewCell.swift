//
//  PostTableViewCell.swift
//  EngineerAI
//
//  Created by Apple on 29/04/19.
//  Copyright © 2019 Hitendra iDev. All rights reserved.
//

import UIKit

protocol PostTableViewCellSelectionDelegate: AnyObject {
    func postTableViewCell(cell: PostTableViewCell, selectionValueDidChange post: Post)
}

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var postSelectionSwitch: UISwitch!
    
    weak var selectionDelegate: PostTableViewCellSelectionDelegate?
    
    var post: Post! {
        didSet{
            self.titleLabel.text = post.title
            self.createdAtLabel.text = post.created_at
            self.postSelectionSwitch.isOn = self.post.isSelected
        }
    }
    
    @IBAction func postSelectionSwitchValueDidChange(_ sender: UISwitch) {
        self.toggleCellSelection()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func toggleCellSelection(){
        self.post.isSelected = !self.post.isSelected
        self.postSelectionSwitch.setOn(self.post.isSelected, animated: true)
        self.selectionDelegate?.postTableViewCell(cell: self, selectionValueDidChange: self.post)
    }
}
