//
//  AnswerDetailViewController.swift
//  Pictures
//
//  Created by 廖慶麟 on 2015/12/25.
//  Copyright © 2015年 廖慶麟. All rights reserved.
//

import UIKit

class AnswerDetailViewController: UIViewController {

    @IBOutlet weak var questionPhoto: UIImageView!
    var answer: Answer?

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var toolBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let answer = answer {
            questionPhoto.image = UIImage(data: answer.photo)
            questionLabel.text = answer.question
            answerLabel.text = answer.answer
            
        }
        toolBarButton.width = view.frame.width
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
